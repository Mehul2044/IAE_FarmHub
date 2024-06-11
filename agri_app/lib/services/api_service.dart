import 'dart:convert';
import 'dart:io';
import '../constants/api_constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ApiService {
  Future<String> encodeImage(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  Future<GenerateContentResponse> sendMessageGPT(
      {required String diseaseName}) async {
    final apiKey = API_GEMINI;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [
      Content.text(
          'Upon receiving the name of a plant disease, provide three precautionary measures to prevent or manage the disease. These measures should be concise, clear, and limited to one sentence each. No additional information or context is needed—only the three precautions in bullet-point format. The disease is $diseaseName')
    ];
    return model.generateContent(content);
  }

    Future<GenerateContentResponse> diseaseInformation(
      {required String diseaseName}) async {
    final apiKey = API_GEMINI;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [
      Content.text(
          'Upon receiving the name of a plant disease, provide information about the disease. This information should be concise, clear, and limited to one sentence each. No additional information or context is needed—only the three pieces of information in bullet-point format. The disease is $diseaseName')
    ];
    return model.generateContent(content);
  }

  Future<GenerateContentResponse> sendImageToGPT4Vision({
    required File image,
    int maxTokens = 50,
  }) async {
    final apiKey = API_GEMINI;
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final firstImage = await (image.readAsBytes());
    final prompt = TextPart(
        'Gemini, your task is to identify plant health issues with precision. Analyze any image of a plant or leaf I provide, and detect all abnormal conditions, whether they are diseases, pests, deficiencies, or decay. Respond strictly with the name of the condition identified, and nothing else—no explanations, no additional text. If a condition is unrecognizable, reply with \'I don\'t know\'. If the image is not plant-related, say \'Please pick another image\'');
    final imageParts = [
      DataPart('image/jpeg', firstImage),
    ];
    return model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);
  }

  Future<GenerateContentResponse> sendMessageGemini(
      {required String text}) async {
    final apiKey = API_GEMINI;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [
      Content.text(
          'You are talking with a farmer.You are a multilingual model and can respond in several languages. Default reply should be in english unless user specifies language to be Hindi. If you do not understand the given language then reply with "I do not understand this language . Please type in English or Hindi." Your task is to assist the farmer in whichever way possible. If any other questions are asked then politely decline to answer them stating that you are specifically designed to answer farming related issues.Your output should be in simple string formatt. Chat:$text')
    ];
    return model.generateContent(content);
  }
}
