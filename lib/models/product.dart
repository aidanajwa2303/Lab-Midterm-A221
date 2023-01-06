class Product {
  String? productsId;
  String? userId;
  String? productsName;
  String? productsDesc;
  String? productsPrice;
  String? productsQty;
  String? productsState;
  String? productsLocal;
  String? productsLat;
  String? productsDate;

  Product({
    this.productsId,
    this.userId,
    this.productsName,
    this.productsDesc,
    this.productsPrice,
    this.productsQty,
    this.productsState,
    this.productsLocal,
    this.productsLat,
    this.productsDate,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productsId = json['product_id'];
    userId = json['user_id'];
    productsName = json['product_name'];
    productsDesc = json['product_desc'];
    productsPrice = json['product_price'];
    productsQty = json['product_qty'];
    productsState = json['product_state'];
    productsLocal = json['product_local'];
    productsLat = json['product_lat'];
    productsDate = json['product_date'];
  }
}
