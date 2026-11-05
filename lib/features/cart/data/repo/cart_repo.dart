import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../model/cart_model.dart';

class CartRepo {

  static bool _isSuccess(int? code) =>
      code != null && code >= 200 && code < 300;


  static void _logError(String name, Object e) {
    if (e is DioException) {
      debugPrint(
        '[$name] DioException | status: ${e.response?.statusCode} '
            '| type: ${e.type} | url: ${e.requestOptions.uri}',
      );
    } else {
      debugPrint('[$name] Unexpected error: $e');
    }
  }

  static Future<CartDataModel?> getCartData() async {
    try {
      final response = await DioFactory.dio.get(ApiEndPoint.cart);
      if (_isSuccess(response.statusCode)) {
        CartResponseModel cart = CartResponseModel.fromJson(response.data);
        return cart.data;
      } else {
        debugPrint('[getCartData] bad status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logError('getCartData', e);
      return null;
    }
  }

  static Future<bool> removeFromCart(int cartItemId) async {
    try {
      final response = await DioFactory.dio.post(
        ApiEndPoint.removeFromCart,
        data: {
          "cart_item_id": cartItemId,
        },
      );
      if (!_isSuccess(response.statusCode)) {
        debugPrint('[removeFromCart] bad status: ${response.statusCode}');
      }
      return _isSuccess(response.statusCode);
    } catch (e) {
      _logError('removeFromCart', e);
      return false;
    }
  }

  static Future<bool> updateCart({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await DioFactory.dio.post(
        ApiEndPoint.updateCart,
        data: {
          "cart_item_id": cartItemId,
          "quantity": quantity,
        },
      );
      if (!_isSuccess(response.statusCode)) {
        debugPrint('[updateCart] bad status: ${response.statusCode}');
      }
      return _isSuccess(response.statusCode);
    } catch (e) {
      _logError('updateCart', e);
      return false;
    }
  }
}