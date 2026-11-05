class CartResponseModel {
  final CartDataModel? data;
  final String? message;

  final int? status;

  const CartResponseModel({
    this.data,
    this.message,
    this.status,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      data: json['data'] is Map<String, dynamic>
          ? CartDataModel.fromJson(json['data'])
          : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'message': message,
      'status': status,
    };
  }
}


class CartDataModel {
  final int? id;
  final CartUserModel? user;
  final String? total;
  final List<CartItemModel>? cartItems;

  const CartDataModel({
    this.id,
    this.user,
    this.total,
    this.cartItems,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      id: json['id'],
      user: json['user'] is Map<String, dynamic>
          ? CartUserModel.fromJson(json['user'])
          : null,
      total: json['total']?.toString(),
      cartItems: (json['cart_items'] as List?)
          ?.map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'total': total,
      'cart_items': cartItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class CartUserModel {
  final int? userId;
  final String? userName;

  const CartUserModel({
    this.userId,
    this.userName,
  });

  factory CartUserModel.fromJson(Map<String, dynamic> json) {
    return CartUserModel(
      userId: json['user_id'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
    };
  }
}

class CartItemModel {
  final int? itemId;
  final int? itemProductId;
  final String? itemProductName;
  final String? itemProductImage;
  final String? itemProductPrice;
  final int? itemProductDiscount;
  final double? itemProductPriceAfterDiscount;
  final int? itemProductStock;
  final int? itemQuantity;
  final double? itemTotal;

  const CartItemModel({
    this.itemId,
    this.itemProductId,
    this.itemProductName,
    this.itemProductImage,
    this.itemProductPrice,
    this.itemProductDiscount,
    this.itemProductPriceAfterDiscount,
    this.itemProductStock,
    this.itemQuantity,
    this.itemTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json['item_id'],
      itemProductId: json['item_product_id'],
      itemProductName: json['item_product_name'],
      itemProductImage: json['item_product_image'],
      itemProductPrice: json['item_product_price']?.toString(),
      itemProductDiscount: json['item_product_discount'],
      itemProductPriceAfterDiscount:
      (json['item_product_price_after_discount'] as num?)?.toDouble(),
      itemProductStock: json['item_product_stock'],
      itemQuantity: json['item_quantity'],
      itemTotal: (json['item_total'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_product_id': itemProductId,
      'item_product_name': itemProductName,
      'item_product_image': itemProductImage,
      'item_product_price': itemProductPrice,
      'item_product_discount': itemProductDiscount,
      'item_product_price_after_discount': itemProductPriceAfterDiscount,
      'item_product_stock': itemProductStock,
      'item_quantity': itemQuantity,
      'item_total': itemTotal,
    };
  }
}