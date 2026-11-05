import 'package:app3/features/cart/data/repo/cart_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartDataModel? currentCartData;

  Future<void> getCartData({bool isSilent = false}) async {
    if (!isSilent) {
      emit(GetCartLoading());
    }
    final response = await CartRepo.getCartData();
    if (response is CartDataModel) {
      currentCartData = response;
      emit(GetCartSuccess(response));
    } else {
      emit(const GetCartError("Failed to fetch cart data"));
    }
  }

  Future<bool> updateQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    emit(CartItemActionLoading(itemId: cartItemId));
    final success = await CartRepo.updateCart(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    if (success) {
      await getCartData(isSilent: true);
      return true;
    } else {
      if (currentCartData != null) {
        emit(GetCartSuccess(currentCartData));
      }
      return false;
    }
  }

  Future<bool> removeFromCart({required int cartItemId}) async {
    emit(CartItemActionLoading(itemId: cartItemId));
    final success = await CartRepo.removeFromCart(cartItemId);
    if (success) {
      await getCartData(isSilent: true);
      return true;
    } else {
      if (currentCartData != null) {
        emit(GetCartSuccess(currentCartData));
      }
      return false;
    }
  }
}
