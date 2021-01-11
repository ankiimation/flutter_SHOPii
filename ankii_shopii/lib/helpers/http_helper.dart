import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const DOMAIN = 'https://shopii.azurewebsites.net/api/';
// const DOMAIN = 'http://10.0.3.2:50107/api/';
const CATEGORY_ENDPOINT = DOMAIN + 'categories';
const PRODUCT_ENDPOINT = DOMAIN + 'products';
const LOGIN_ENDPOINT = DOMAIN + 'login';
const ACCOUNT_ENDPOINT = DOMAIN + 'current';
const FAVORITE_ENDPOINT = DOMAIN + 'favorites';
const ORDERING_ENDPOINT = DOMAIN + 'orderings';
const CART_ENDPOINT = DOMAIN + 'orderings/cart';
const CHECKOUT_ENDPOINT = DOMAIN + 'orderings/checkout';
const DELIVERY_ADDRESS_ENDPOINT = DOMAIN + 'deliveryaddresses';
const SHOP_ACCOUNT_ENDPOINT = DOMAIN + 'shopaccounts';

class HttpHelper {
  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {String bearerToken}) async {
//    print('HTTP POST: $url');
    return (await http.post(url, body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {String bearerToken}) async {
    return (await http.put(url, body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> get(String url, {String bearerToken}) async {
    return await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'});
  }
}
