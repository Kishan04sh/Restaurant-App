import 'dart:async';
import 'dart:io';

class ExceptionHandler {
  /// ================= ERROR MESSAGES =================
  static String getMessage(Object error) {
    if (error is SocketException) {
      return "No Internet Connection";
    }

    if (error is HttpException) {
      return error.message.isNotEmpty
          ? error.message
          : "Server Error";
    }

    if (error is FormatException) {
      return "Invalid data received from server";
    }

    if (error is HandshakeException) {
      return "Secure connection failed";
    }

    if (error is TimeoutException) {
      return "Request timed out. Please try again.";
    }

    return "Something went wrong. Please try again.";
  }
}