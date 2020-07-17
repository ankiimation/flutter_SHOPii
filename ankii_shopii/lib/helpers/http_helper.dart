import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const DOMAIN = 'http://10.0.3.2:50107/api/';
const CATEGORY_ENDPOINT = DOMAIN + 'categories';
const PRODUCT_ENDPOINT = DOMAIN + 'products';
const LOGIN_ENDPOINT = DOMAIN + 'login';

class HttpHelper {
  static Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return (await http.post(

      url, body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
    }));
  }

  static Future<http.Response> get(String url) async {
    return await http.get(url);
  }
}
