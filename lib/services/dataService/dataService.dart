import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class DataService {
  var _baseURL = "";
  String _authToken =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdG5hbWUiOiJkZXYiLCJsYXN0bmFtZSI6InV6aSIsImVtYWlsIjoiZGV2dXppQGdtYWlsLmNvbSIsInBob25lTnVtYmVyIjoiKzkyMzMyNTEyNDEyMSIsImVuY3J5cHRpb25LZXkiOiIiLCJpc1ZlcmlmaWVkIjp0cnVlLCJjcmVhdGVkQXQiOiIyMDIyLTA1LTMxVDA5OjU4OjUwLjIyNloiLCJ1cGRhdGVkQXQiOiIyMDIyLTA1LTMxVDA5OjU5OjQ0LjQwMloiLCJpZCI6IjYyOTVlNmRhYjIyM2UwOGM5NTBiOWFjMSIsImlhdCI6MTY1NDA2MDQxMCwiZXhwIjoxMTY1NDA2MDQwOX0.khsXCEm66yf9VSccmPNIP7s39pfKpWS5hIiHfBr4sCA';
  var _response;

  Future<Response?> genericDioGetCall(String api) async {
    print(_baseURL + '$api');
    await getToken().then((String? token) async {
      var _dio = Dio(BaseOptions(baseUrl: _baseURL, headers: {
        "Authorization": "$token",
        "Content-Type": "application/json"
      }));

      try {
        _response = await _dio.get(_baseURL + '$api');
      } on DioException catch (e) {
        if (e.response != null) {
          if (!api.contains('getLatestTrade')) {
            showToast(e.response?.data['message']);
          }
        } else {
          if (!api.contains('getLatestTrade')) {
            // showToast();
          }
        }
        _response = e.response;
      }
    });
    print(_baseURL + '$api' + ' Status_Code: ${_response?.statusCode}');
    return _response;
  }

  Future<Response?> genericDioPostCall(String api, {var data}) async {
    if (api.contains('auth/signup')) {
    } else if (api.contains('auth/resetPassword')) {
      await getTokenForVerifyOtp().then((String? token) {
        _authToken = token!;
      });
    } else {
      await getToken().then((String? token) {
        _authToken = token!;
      });
    }

    var _dio = Dio(BaseOptions(baseUrl: _baseURL, headers: {
      "Authorization": "$_authToken",
      "Content-Type": "application/json"
    }));
    var response;
    print(_baseURL + '$api' + ' data: $data');
    try {
      response = await _dio.post(api, data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['message']
            .contains('User account is already linked with')) {
        } else {
          showToast(e.response?.data['message']);
        }
      } else {
        // if (e.message.contains('User account is already linked with')) {
        // } else {
        //   showToast((e.message));
        // }
      }
      response = e.response;
    }
    print(_baseURL + '$api' + ' Status_Code: ${response.statusCode}');
    return response;
  }

  Future<Response> uploadImage(String api, File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    await getToken().then((String? token) {
      _authToken = token!;
    });
    var _dio = Dio(BaseOptions(baseUrl: _baseURL, headers: {
      "Authorization": "$_authToken",
      "Content-Type": "application/json"
    }));
    var response;
    try {
      response = await _dio.post(api, data: formData);
    } on DioError catch (e) {
      if (e.response != null) {
        showToast(e.response?.data['message']);
      } else {
        // showToast(e.message);
      }
      response = e.response;
    }

    return response;
  }

  uploadIMAGES(String api, File frontProof, File backProof,
      String documentNumber, bool isAddressImage) async {
    var res = '';
    String frontFileName = frontProof.path.split('/').last;
    String backFileName = backProof.path.split('/').last;
    print('frontFileName $frontFileName');
    print('backFileName $backFileName');
    await getToken().then((String? token) {
      _authToken = token!;
    });
    var headers = {'accept': '*/*', 'Authorization': '$_authToken'};
    var request = http.MultipartRequest('POST', Uri.parse('$_baseURL$api'));
    if (isAddressImage == false) {
      request.fields.addAll({'documentNumber': '$documentNumber'});
      request.files.add(
        await http.MultipartFile.fromPath(
          "front_proof",
          frontProof.path,
          filename: frontFileName,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          "back_proof",
          backProof.path,
          filename: frontFileName,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          "address_proof",
          frontProof.path,
          filename: frontFileName,
        ),
      );
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode <= 201) {
      print(await response.stream.bytesToString());
      res = 'OK';
    } else {
      print(response.reasonPhrase);
      if (response.statusCode >= 400) {
        showToast(response.reasonPhrase ?? '');
      }
    }
    print(' data RES $res');
    return res;
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken') != null ? prefs.getString('jwtToken') : '';
}

Future<String?> getTokenForVerifyOtp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authTokenForReset') != null
      ? prefs.getString('authTokenForReset')
      : '';
}

showToast(String message) {
  if (message.contains('SocketException')) {
    message = 'Server is temporary busy!';
  }

  if (message.contains('KYC not yet done!')) {
  } else {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
