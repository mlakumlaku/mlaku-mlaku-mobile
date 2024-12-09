class Place {
  final String placeName;
  final String descriptionPlace;
  final String city;
  final String productName;
  final String descriptionProduct;
  final String businessName;
  final double price;

  Place({
    required this.placeName,
    required this.descriptionPlace,
    required this.city,
    required this.productName,
    required this.descriptionProduct,
    required this.businessName,
    required this.price,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeName: json['Place Name'],
      descriptionPlace: json['Description Place'],
      city: json['City'],
      productName: json['Product Name'],
      descriptionProduct: json['Description Product'],
      businessName: json['Business Name'],
      price: (json['Price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Place Name': placeName,
      'Description Place': descriptionPlace,
      'City': city,
      'Product Name': productName,
      'Description Product': descriptionProduct,
      'Business Name': businessName,
      'Price': price,
    };
  }
} 