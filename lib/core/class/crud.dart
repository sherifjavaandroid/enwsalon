import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easycut/core/functions/check_internet.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';

import 'status_request.dart';

class Crud {
  // Method for GET request
  Future<Either<StatusRequest, dynamic>> getData(String linkUrl) async {
    try {
      Logger().i('GET Request: $linkUrl'); // Log the request URL
      if (await checkInternet()) {
        var response = await http.get(Uri.parse(linkUrl));

        // Log the response details
        Logger().i('Response Status Code: ${response.statusCode}');
        Logger().i('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final responseBody = jsonDecode(response.body);
            Logger().i('API GET Response: $responseBody');

            // ✅ Handle both List and Map responses
            if (responseBody is Map<String, dynamic> || responseBody is List) {
              return Right(responseBody);
            } else {
              Logger().e('Unexpected response format: $responseBody');
              return const Left(StatusRequest.serverFailure);
            }
          } catch (e) {
            Logger().e('Error decoding GET response: $e');
            return const Left(StatusRequest.serverFailure);
          }
        } else {
          Logger().e('Server error: ${response.statusCode}');
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        Logger().e('No internet connection');
        return const Left(StatusRequest.offlineFailure);
      }
    } catch (e) {
      Logger().e('Exception in getData: $e');
      return const Left(StatusRequest.serverException);
    }
  }

  // Method for POST request (without file)
  Future<Either<StatusRequest, Map<String, dynamic>>> postData(
      String linkUrl, Map<String, dynamic> data) async {
    try {
      Logger().i('POST Request: $linkUrl'); // Log the request URL
      Logger().i('Request Body: $data'); // Log the request body
      if (await checkInternet()) {
        var response = await http.post(
          Uri.parse(linkUrl),
          body: data,
        );

        // Log the response details
        Logger().i("Raw Response: ${response.body}"); // Debugging

        Logger().i('Response Status Code: ${response.statusCode}');
        Logger().i('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          try {
            final dynamic responseBody = jsonDecode(response.body);

            if (responseBody == null || responseBody is! Map<String, dynamic>) {
              Logger().e('Invalid JSON format or null response');
              return const Left(StatusRequest.serverFailure);
            }

            Logger().i('Decoded Response: $responseBody');

            // Ensure 'status' is a string and valid
            final status = responseBody['status'];
            final message = responseBody['message'];

            if (status == null || status != 'success') {
              Logger().e("Error: Status is not success. Message: $message");
              return const Left(StatusRequest.serverFailure);
            }

            // If 'status' is success, return the response body
            return Right(responseBody);
          } catch (e) {
            Logger().e('Error decoding response: $e');
            return const Left(StatusRequest.serverFailure);
          }
        } else {
          Logger().e('Server error: ${response.statusCode}');
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        Logger().e('No internet connection');
        return const Left(StatusRequest.offlineFailure);
      }
    } catch (_) {
      return const Left(StatusRequest.serverException);
    }
  }
  // Method for POST request (with file upload)
  Future<Either<StatusRequest, Map<String, dynamic>>> postDataWithFile(
      String linkUrl,
      Map<String, dynamic> data,
      File file,
      ) async {
    try {
      Logger().i('POST Request with File: $linkUrl'); // Log the request URL
      Logger().i('Request Data: $data'); // Log the data being posted
      Logger().i('Uploading File: ${file.path}'); // Log the file being uploaded

      if (await checkInternet()) {
        var request = http.MultipartRequest(
          "POST",
          Uri.parse(linkUrl),
        );

        var length = await file.length();

        var stream = http.ByteStream(file.openRead());

        var multipartFile = http.MultipartFile(
          "file",
          stream,
          length,
          filename: basename(file.path),
        );

        request.files.add(multipartFile);
        data.forEach((key, value) {
          request.fields[key] = value;
        });

        var myRequest = await request.send();
        var response = await http.Response.fromStream(myRequest);

        // Log the response details
        Logger().i('Response Status Code: ${response.statusCode}');
        Logger().i('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        return const Left(StatusRequest.offlineFailure);
      }
    } catch (_) {
      return const Left(StatusRequest.serverException);
    }
  }
}
