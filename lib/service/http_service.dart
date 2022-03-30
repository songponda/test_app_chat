import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  static Future<SecurityContext> get globalContext async {
    // Note: Not allowed to load the same certificate
    final sslCert1 = await rootBundle.load('assets/cert/certificate.pem');
    // final sslCert2 = await rootBundle.load('assets/cert/certificate2.pem');

    SecurityContext sc = SecurityContext(withTrustedRoots: false);
    sc.setTrustedCertificatesBytes(sslCert1.buffer.asInt8List());
    // sc.setTrustedCertificatesBytes(sslCert2.buffer.asInt8List());
    return sc;
  }

  static Future<dynamic> post(String url, data) async {
    HttpClient _client = HttpClient(context: await globalContext);

    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    final _ioClient = IOClient(_client);
    var urlApi = Uri.parse(url);
    final body = jsonEncode(data);
    var envKeyBaseUrl = dotenv.env['API_KEY_BASE_URL'];

    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': envKeyBaseUrl!
    };

    var response =
        await _ioClient.post(urlApi, body: body, headers: requestHeaders);
    var res = json.decode(response.body);

    // print('res from apiPostBaseUrl -> ${res}');
    return res;
  }

  static Future<dynamic> get(String url) async {
    HttpClient _client = HttpClient(context: await globalContext);

    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    final _ioClient = IOClient(_client);
    var urlApi = Uri.parse(url);

    var envKeyBaseUrl = dotenv.env['API_KEY_BASE_URL'];

    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': envKeyBaseUrl!
    };

    var response = await _ioClient.get(urlApi, headers: requestHeaders);
    var res = json.decode(response.body);

    // print('res from api Get BaseUrl -> ${res}');
    return res;
  }

  static Future<dynamic> apiPostToken(String url, data) async {
    var urlApi = Uri.parse(url);
    final body = jsonEncode(data);
    var envKeyTokenUrl = dotenv.env['API_KEY_GET_TOKEN_URL'];

    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': envKeyTokenUrl!,
      'Authorization': ''
    };
    var response = await http.post(urlApi, body: body, headers: requestHeaders);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      var res = json.decode(response.body);
      return res;
    } else {
      return false;
    }
  }

  static Future<dynamic> apiPostAuthorizeToken(
      String url, data, String authorization) async {
    var urlApi = Uri.parse(url);
    final body = jsonEncode(data);
    var envKeyTokenUrl = dotenv.env['API_KEY_GET_TOKEN_URL'];

    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': envKeyTokenUrl!,
      'Authorization': authorization
    };
    var response = await http.post(urlApi, body: body, headers: requestHeaders);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      var res = json.decode(response.body);
      return res;
    } else {
      return false;
    }
  }

  static Future<String> apiPostS3upload(String url, Map jsonMap) async {
    // print(url);

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    var envKeyS3Url = dotenv.env['API_KEY_S3_URL'];
    request.headers.set('content-type', 'application/json');
    request.headers.set('x-api-key', envKeyS3Url!);
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  static callDocker5200(
    String url,
    path,
    Map jsonMap,
  ) async {
    String username = 'ags-ci';
    String password = 'cdWmW,o5HlNPd}gzEZlkbzCJ(zDtP)';
    String gg = '';
    HttpClient httpClient = HttpClient();
    httpClient.addCredentials(
        Uri.parse(url), gg, HttpClientBasicCredentials(username, password));
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('path', path.toString());
    request.headers.set('port', '5200');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    // print(reply);
    return reply;
  }
}
