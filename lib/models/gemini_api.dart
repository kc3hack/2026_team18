import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApi {
    final String _apiKey;
    late final GenerativeModel _model;

    GeminiApi({required String apiKey, required String model}) : _apiKey = apiKey {
        _model = GenerativeModel(
            model: model, 
            apiKey: _apiKey
        );
    }

    Future<String?> generateResponse(String prompt) async {
        try {
            final content = [Content.text(prompt)];
            final response = await _model.generateContent(content);

            return response.text;
        } catch(e) {
            print('Error: $e');
            return null;
        }
    }
}