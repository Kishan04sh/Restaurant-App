import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'exception_handler.dart';

class ApiClient {

  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 15);

  /// ================= HEADERS =================
  void _setHeaders(
      HttpClientRequest request,
      Map<String, String> headers,
      ) {
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });
  }

  /// ================= HANDLE RESPONSE =================
  Future<dynamic> _handleResponse(HttpClientResponse response) async {
    final body = await response.transform(utf8.decoder).join();

    print("STATUS: ${response.statusCode}");
    print("RESPONSE: $body");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body.isEmpty ? null : jsonDecode(body);
    }

    throw HttpException("Error ${response.statusCode}: $body");
  }

  /// ================= GET =================
  Future<dynamic> get(
      String url,
      Map<String, String> headers,
      ) async {
    try {
      final uri = Uri.parse(url);
      final request = await _client.getUrl(uri);

      _setHeaders(request, headers);

      final response =
      await request.close().timeout(const Duration(seconds: 20));

      return await _handleResponse(response);
    } on SocketException {
      throw ExceptionHandler.getMessage(const SocketException(""));
    } on TimeoutException {
      throw ExceptionHandler.getMessage(TimeoutException(""));
    } on HttpException catch (e) {
      throw ExceptionHandler.getMessage(e);
    }
  }

  /// ================= POST =================
  Future<dynamic> post(
      String url,
      Map<String, String> headers,
      Map<String, dynamic> body,
      ) async {
    try {
      final uri = Uri.parse(url);
      final request = await _client.postUrl(uri);

      _setHeaders(request, headers);

      request.add(utf8.encode(jsonEncode(body)));

      final response =
      await request.close().timeout(const Duration(seconds: 20));

      return await _handleResponse(response);
    } on SocketException {
      throw ExceptionHandler.getMessage(const SocketException(""));
    } on TimeoutException {
      throw ExceptionHandler.getMessage(TimeoutException(""));
    } on HttpException catch (e) {
      throw ExceptionHandler.getMessage(e);
    }
  }
}