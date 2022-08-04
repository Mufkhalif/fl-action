// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:fl_cicd/config/config.dart';
import 'package:fl_cicd/utils/log.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> get(
      {required String url, Map<String, String>? headers}) async {
    Log.info("URL_GET: $url");

    return await http.get(Uri.parse('${BaseUrl.baseUrl}$url'),
        headers: headers);
  }

  Future<http.Response> getFullUrl(
      {required String url, Map<String, String>? headers}) async {
    Log.info("URL_GET: $url");

    return await http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(
      {required String url,
      required Map<String, dynamic> bodyObject,
      Map<String, String>? headers}) async {
    Log.info("URL_POST: $url");
    Log.info("PARAMS_POST: $bodyObject");

    return await http.post(Uri.parse('${BaseUrl.baseUrl}$url'),
        headers: headers, body: json.encode(bodyObject));
  }

  Future<http.Response> put(
      {required String url,
      Map<String, dynamic>? bodyObject,
      Map<String, String>? headers}) async {
    Log.info("URL_PUT: '${BaseUrl.baseUrl}$url'");
    Log.info("PARAMS_PUT: $bodyObject");

    return await http.put(Uri.parse('${BaseUrl.baseUrl}$url'),
        headers: headers, body: json.encode(bodyObject));
  }

  Future<http.Response> delete(
      {required String url, Map<String, String>? headers}) async {
    Log.info("URL_DELETE: $url");

    return await http.delete(Uri.parse('${BaseUrl.baseUrl}$url'),
        headers: headers);
  }
}
