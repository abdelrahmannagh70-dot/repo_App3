part of 'cart_cubit.dart';

@immutable
sealed class CartState {
  const CartState();
}

final class CartInitial extends CartState {}

final class GetCartLoading extends CartState {}

final class GetCartSuccess extends CartState {
  final CartDataModel? cartData;
  const GetCartSuccess(this.cartData);
}

final class GetCartError extends CartState {
  final String? message;
  const GetCartError([this.message]);
}

final class CartItemActionLoading extends CartState {
  final int? itemId;
  const CartItemActionLoading({this.itemId});
}

final class CartItemActionError extends CartState {
  final String message;
  const CartItemActionError(this.message);
}