import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _geminiKeyKey = 'gemini_api_key';
  static const String _chatgptKeyKey = 'chatgpt_api_key';
  static const String _chatgptModelKey = 'chatgpt_model';
  static const String _geminiModelKey = 'gemini_model';
  static const String _aiProviderKey = 'ai_provider';
  static const String _cachePrefix = 'ai_cache_';
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Model Lists
  static const List<String> geminiModels = [
    'gemini-2.5-flash-preview',
    'gemini-2.5-pro',
    'gemini-1.5-pro',
    'gemini-1.5-flash',
  ];

  static const List<String> chatgptModels = [
    'gpt-5',
    'gpt-5-mini',
    'gpt-5-nano',
    'gpt-4.1-mini',
    'o3',
    'o4-mini',
    'gpt-4o',
  ];

  // Getters & Setters
  Future<String?> getGeminiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_geminiKeyKey);
  }

  Future<String?> getChatGPTKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chatgptKeyKey);
  }

  Future<String> getAIProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_aiProviderKey) ?? 'gemini';
  }

  Future<void> setAIProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_aiProviderKey, provider);
  }

  Future<void> saveGeminiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyKey, key);
  }

  Future<void> saveChatGPTKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatgptKeyKey, key);
  }

  Future<String> getChatGPTModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chatgptModelKey) ?? 'gpt-4o';
  }

  Future<void> setChatGPTModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatgptModelKey, model);
  }

  Future<String> getGeminiModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_geminiModelKey) ?? 'gemini-1.5-flash';
  }

  Future<void> setGeminiModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiModelKey, model);
  }

  // Cache Management
  Future<Map<String, dynamic>?> _getCachedResponse(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('$_cachePrefix$key');
      if (cached != null) {
        final data = jsonDecode(cached);
        final timestamp = DateTime.parse(data['timestamp']);
        // Cache expires after 24 hours
        if (DateTime.now().difference(timestamp).inHours < 24) {
          debugPrint('✅ Using cached AI response for: $key');
          return Map<String, dynamic>.from(data['response']);
        } else {
          // Clean up expired cache
          await prefs.remove('$_cachePrefix$key');
        }
      }
    } catch (e) {
      debugPrint('Cache read error: $e');
    }
    return null;
  }

  Future<void> _cacheResponse(String key, Map<String, dynamic> response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'response': response,
      };
      await prefs.setString('$_cachePrefix$key', jsonEncode(cacheData));
      debugPrint('💾 Cached AI response for: $key');
    } catch (e) {
      debugPrint('Cache write error: $e');
    }
  }

  String _generateCacheKey(String? textInput, List<int>? imageBytes) {
    if (imageBytes != null) {
       // Use a hash of the first few bytes for image cache key
      return 'img_${imageBytes.take(100).join('-')}';
    }
    return 'text_${textInput ?? ''}';
  }

  // Smart Model Validation
  Future<String> validateApiKey(String provider, String key) async {
    if (provider == 'gemini') {
      return await _findWorkingGeminiModel(key);
    } else if (provider == 'chatgpt') {
      return await _findWorkingChatGPTModel(key);
    }
    throw Exception('Unknown provider');
  }

  Future<String> _findWorkingGeminiModel(String key) async {
    final selectedModel = await getGeminiModel();
    final modelsToTry = [selectedModel, ...geminiModels.where((m) => m != selectedModel)];

    for (final modelName in modelsToTry) {
      try {
        final model = GenerativeModel(model: modelName, apiKey: key);
        await model.generateContent([Content.text('Test')]);
        debugPrint('✅ Found working Gemini model: $modelName');
        return modelName;
      } catch (e) {
        debugPrint('❌ Model $modelName failed: $e');
        continue;
      }
    }
    throw Exception('No working Gemini models found. Check your API Key.');
  }

  Future<String> _findWorkingChatGPTModel(String key) async {
    final selectedModel = await getChatGPTModel();
    final modelsToTry = [selectedModel, ...chatgptModels.where((m) => m != selectedModel)];

    for (final modelName in modelsToTry) {
      try {
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key',
          },
          body: jsonEncode({
            'model': modelName,
            'messages': [{'role': 'user', 'content': 'Test'}],
            'max_tokens': 5,
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('✅ Found working ChatGPT model: $modelName');
          return modelName;
        }
      } catch (e) {
        debugPrint('❌ Model $modelName failed: $e');
        continue;
      }
    }
    throw Exception('No working ChatGPT models found. Check your API Key.');
  }

  // Analyze food with AI (text or image) - WITH RETRY AND CACHING
  Future<Map<String, dynamic>> analyzeFood(String? textInput, List<int>? imageBytes) async {
    // Check cache first (only for text inputs, images are too large to cache effectively)
    if (imageBytes == null && textInput != null) {
      final cacheKey = _generateCacheKey(textInput, null);
      final cached = await _getCachedResponse(cacheKey);
      if (cached != null) {
        return cached;
      }
    }

    final provider = await getAIProvider();
    
    // Retry logic
    int attempts = 0;
    Exception? lastError;

    while (attempts < maxRetries) {
      try {
        debugPrint('🔄 AI analysis attempt ${attempts + 1}/$maxRetries');
        
        Map<String, dynamic> result;
        if (provider == 'chatgpt') {
          result = await _analyzeWithChatGPT(textInput, imageBytes != null ? Uint8List.fromList(imageBytes) : null);
        } else {
          result = await _analyzeWithGemini(textInput, imageBytes != null ? Uint8List.fromList(imageBytes) : null);
        }
        
        // Cache successful result (text only)
        if (imageBytes == null && textInput != null) {
          final cacheKey = _generateCacheKey(textInput, null);
          await _cacheResponse(cacheKey, result);
        }
        
        debugPrint('✅ AI analysis successful');
        return result;
      } catch (e) {
        lastError = e as Exception;
        attempts++;
        debugPrint('❌ Attempt $attempts failed: $e');
        
        if (attempts < maxRetries) {
          debugPrint('⏳ Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay * attempts); // Exponential backoff
        }
      }
    }
    
    // All retries failed
    throw Exception('Failed after $maxRetries attempts. Last error: ${lastError.toString()}');
  }

  Future<Map<String, dynamic>> _analyzeWithGemini(String? textInput, Uint8List? imageBytes) async {
    final apiKey = await getGeminiKey();
    if (apiKey == null) throw Exception('Gemini API Key not set. Please add it in Settings.');

    String modelName = await getGeminiModel();

    final prompt = _buildEnhancedFoodPrompt(textInput);

    // Try selected model first
    try {
      final model = GenerativeModel(model: modelName, apiKey: apiKey);
      return await _generateContent(model, prompt, imageBytes);
    } catch (e) {
      debugPrint('Selected Gemini model $modelName failed: $e. Trying fallback models...');
      
      // Fallback loop
      for (final fallbackModel in geminiModels) {
        if (fallbackModel == modelName) continue;
        try {
           final model = GenerativeModel(model: fallbackModel, apiKey: apiKey);
           final result = await _generateContent(model, prompt, imageBytes);
           debugPrint('✅ Fallback model $fallbackModel succeeded');
           return result;
        } catch (e2) {
          debugPrint('❌ Fallback model $fallbackModel failed: $e2');
          continue;
        }
      }
      throw Exception('All Gemini models failed. Please check your API key and internet connection.');
    }
  }

  String _buildEnhancedFoodPrompt(String? textInput) {
    return '''
You are a nutrition expert. Analyze this food and provide accurate nutritional information.

${textInput != null ? 'Food description: $textInput' : 'Analyze the food shown in the image.'}

Important guidelines:
- If multiple food items are listed, calculate the combined totals
- Use standard serving sizes
- Round nutritional values to whole numbers
- Be as accurate as possible based on common portion sizes

Return ONLY valid JSON in this exact format (no markdown, no extra text):
{
  "name": "Complete food name or meal description",
  "calories": 0,
  "protein": 0,
  "carbs": 0,
  "fat": 0,
  "servingSize": "e.g. 100g, 1 cup, 1 serving"
}
''';
  }

  Future<Map<String, dynamic>> _generateContent(GenerativeModel model, String prompt, Uint8List? imageBytes) async {
    final Content content;
    if (imageBytes != null) {
      content = Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ]);
    } else {
      content = Content.text(prompt);
    }

    final response = await model.generateContent([content]);
    final text = response.text ?? '';
    
    // Try to extract JSON from response
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (jsonMatch != null) {
      final parsed = jsonDecode(jsonMatch.group(0)!);
      
      // Validate required fields
      if (parsed['name'] != null && 
          parsed['calories'] != null && 
          parsed['protein'] != null &&
          parsed['carbs'] != null &&
          parsed['fat'] != null) {
        return Map<String, dynamic>.from(parsed);
      }
    }
    
    throw Exception('Could not parse AI response. Please try again with a clearer description.');
  }

  Future<Map<String, dynamic>> _analyzeWithChatGPT(String? textInput, Uint8List? imageBytes) async {
    final apiKey = await getChatGPTKey();
    if (apiKey == null) throw Exception('ChatGPT API Key not set. Please add it in Settings.');

    final prompt = _buildEnhancedFoodPrompt(textInput);

    final messages = <Map<String, dynamic>>[];
    if (imageBytes != null) {
      final base64Image = base64Encode(imageBytes);
      messages.add({
        'role': 'user',
        'content': [
          {'type': 'text', 'text': prompt},
          {
            'type': 'image_url',
            'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
          }
        ]
      });
    } else {
      messages.add({'role': 'user', 'content': prompt});
    }

    String modelName = await getChatGPTModel();

    try {
      return await _callChatGPT(apiKey, modelName, messages);
    } catch (e) {
      debugPrint('Selected ChatGPT model $modelName failed: $e. Trying fallback models...');
       for (final fallbackModel in chatgptModels) {
        if (fallbackModel == modelName) continue;
        try {
           final result = await _callChatGPT(apiKey, fallbackModel, messages);
           debugPrint('✅ Fallback model $fallbackModel succeeded');
           return result;
        } catch (e2) {
          debugPrint('❌ Fallback model $fallbackModel failed: $e2');
          continue;
        }
      }
      throw Exception('All ChatGPT models failed. Please check your API key or quota.');
    }
  }

  Future<Map<String, dynamic>> _callChatGPT(String apiKey, String model, List<Map<String, dynamic>> messages) async {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          'max_tokens': 500,
        }),
      ).timeout(const Duration(seconds: 30)); // Add timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'];
        
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
        if (jsonMatch != null) {
          final parsed = jsonDecode(jsonMatch.group(0)!);
          
          // Validate required fields
          if (parsed['name'] != null && 
              parsed['calories'] != null && 
              parsed['protein'] != null &&
              parsed['carbs'] != null &&
              parsed['fat'] != null) {
            return Map<String, dynamic>.from(parsed);
          }
        }
      }
      
      if (response.statusCode == 429) {
        throw Exception('API quota exceeded. Please check your OpenAI account.');
      }
      
      if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your settings.');
      }
      
      throw Exception('API error (${response.statusCode}). Please try again.');
  }

  // Chat function for AI Coach - WITH RETRY
  Future<String> chat(String prompt) async {
    final provider = await getAIProvider();
    
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        debugPrint('🔄 AI chat attempt ${attempts + 1}/$maxRetries');
        
        String result;
        if (provider == 'chatgpt') {
          result = await _chatWithChatGPT(prompt);
        } else {
          result = await _chatWithGemini(prompt);
        }
        
        debugPrint('✅ AI chat successful');
        return result;
      } catch (e) {
        attempts++;
        debugPrint('❌ Chat attempt $attempts failed: $e');
        
        if (attempts < maxRetries) {
          await Future.delayed(retryDelay * attempts);
        }
      }
    }
    
    return 'I apologize, but I\'m having trouble connecting right now. Please check your internet connection and API key in Settings.';
  }

  Future<String> _chatWithGemini(String prompt) async {
    final apiKey = await getGeminiKey();
    if (apiKey == null) return "Please set your Gemini API Key in Settings.";

    String modelName = await getGeminiModel();

    try {
      final model = GenerativeModel(model: modelName, apiKey: apiKey);
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "I'm not sure how to respond to that.";
    } catch (e) {
       // Fallback
       for (final fallbackModel in geminiModels) {
        if (fallbackModel == modelName) continue;
        try {
           final model = GenerativeModel(model: fallbackModel, apiKey: apiKey);
           final response = await model.generateContent([Content.text(prompt)]);
           return response.text ?? "I'm not sure how to respond to that.";
        } catch (e2) {
          continue;
        }
      }
      return "Error connecting to Gemini. Please check your API key in Settings.";
    }
  }

  Future<String> _chatWithChatGPT(String prompt) async {
    final apiKey = await getChatGPTKey();
    if (apiKey == null) return "Please set your ChatGPT API Key in Settings.";

    String modelName = await getChatGPTModel();

    try {
      return await _callChatGPTChat(apiKey, modelName, prompt);
    } catch (e) {
      // Fallback
       for (final fallbackModel in chatgptModels) {
        if (fallbackModel == modelName) continue;
        try {
           return await _callChatGPTChat(apiKey, fallbackModel, prompt);
        } catch (e2) {
          continue;
        }
      }
      return "Error connecting to ChatGPT. Please check your API key or quota.";
    }
  }

  Future<String> _callChatGPTChat(String apiKey, String model, String prompt) async {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
      
      if (response.statusCode == 429) {
        throw Exception('Quota exceeded');
      }
      
      throw Exception('API error: ${response.statusCode}');
  }

  // Clear all cached responses
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_cachePrefix));
      for (final key in keys) {
        await prefs.remove(key);
      }
      debugPrint('🧹 Cache cleared');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}
