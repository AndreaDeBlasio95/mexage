import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  OpenAIService();

  Future<double> getExplicitnessScore(String userContent) async {
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': 'You are an assistant trained to evaluate text across three dimensions: sexual content, racial content, and the presence of personal identifiable information (PII), which includes phone numbers, ID card numbers, and other sensitive details. Rate the text s explicitness in terms of sexual and racial content combined on a scale from 0 to 10, where 0 means there is no explicit content and 10 means the content is extremely explicit.If the sexual content relates to a personal experience or a story, then it will be tolerated, and the score will be less than 8. However, if sexual content is used as an insult, then the score will be higher than 8. The same applies to racial content. If PII is detected, the content should be flagged separately. Note that personal stories are allowed as long as they do not contain identifiable information. Provide a single numeric rating for the overall explicitness, taking into account the context and nuances of the submission. The output you provider should be a number, no string, no text, only number between 0 and 10, double check your output, i only need the number as output and string will not be tolerate'
        },
        {
          'role': 'user',
          'content': userContent,
        }
      ],
    };

    // Set up headers for the HTTP request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env["OPEN_AI_API_KEY"]}'
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final responseBody = json.decode(response.body);
        final String assistantResponse = responseBody['choices'][0]['message']['content'];
        print(assistantResponse);
        // Extract the score from the assistant's response
        // This part depends on how you prompt GPT and might need adjustment
        final double score = double.parse(assistantResponse.trim());

        return score;
      } else {
        // Handle errors or non-200 responses
        print('Request failed with status: ${response.statusCode}.');
        return -1; // Indicates an error
      }
    } catch (e) {
      print('An error occurred: $e');
      return -1; // Indicates an error
    }
  }
}
