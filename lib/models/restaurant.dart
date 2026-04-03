class RestaurantResponse {
  final int status;
  final String message;
  final List<Restaurant> restaurants;

  RestaurantResponse({
    required this.status,
    required this.message,
    required this.restaurants,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      status: int.tryParse(json['status'].toString()) ?? 0,
      message: json['message'] ?? '',
      restaurants: (json['data']?['restaurants'] as List? ?? [])
          .map((e) => Restaurant.fromJson(e))
          .toList(),
    );
  }
}

/// ================= RESTAURANT =================
class Restaurant {
  final int id;
  final String name;
  final String description;
  final String image;
  final String logo;
  final String latlon;
  final bool isFeatured;
  final bool isOpen;
  final double distance;
  final int deliveryTime;
  final double rating;
  final int minimumOrderValue;
  final List<String> categoryName;
  final Label? label;
  final DeliveryPricing? deliveryPricing;
  final List<RestaurantItem> items;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.logo,
    required this.latlon,
    required this.isFeatured,
    required this.isOpen,
    required this.distance,
    required this.deliveryTime,
    required this.rating,
    required this.minimumOrderValue,
    required this.categoryName,
    this.label,
    this.deliveryPricing,
    required this.items,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      logo: json['logo'] ?? '',
      latlon: json['latlon'] ?? '',
      isFeatured: json['isFeatured'] == 1,
      isOpen: json['isOpen'] == 1,
      distance: double.tryParse(json['distance'].toString()) ?? 0,
      deliveryTime: int.tryParse(json['deliveryTime'].toString()) ?? 0,
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      minimumOrderValue:
      int.tryParse(json['minimumOrderValue'].toString()) ?? 0,
      categoryName: List<String>.from(json['categoryName'] ?? []),

      label: json['label'] != null
          ? Label.fromJson(json['label'])
          : null,

      deliveryPricing: json['deliveryPricing'] != null
          ? DeliveryPricing.fromJson(json['deliveryPricing'])
          : null,

      items: (json['items'] as List? ?? [])
          .map((e) => RestaurantItem.fromJson(e))
          .toList(),
    );
  }
}

/// ================= LABEL =================
class Label {
  final String name;
  final String icon;
  final String color;
  final String fontColor;

  Label({
    required this.name,
    required this.icon,
    required this.color,
    required this.fontColor,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      fontColor: json['fontColor'] ?? '',
    );
  }
}

/// ================= DELIVERY PRICING =================
class DeliveryPricing {
  final int id;
  final double price;
  final String userZoneId;
  final int restaurantZoneId;

  DeliveryPricing({
    required this.id,
    required this.price,
    required this.userZoneId,
    required this.restaurantZoneId,
  });

  factory DeliveryPricing.fromJson(Map<String, dynamic> json) {
    return DeliveryPricing(
      id: int.tryParse(json['id'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0,
      userZoneId: json['userZoneId']?.toString() ?? '',
      restaurantZoneId:
      int.tryParse(json['restaurantZoneId'].toString()) ?? 0,
    );
  }
}

/// ================= RESTAURANT ITEM =================
class RestaurantItem {
  final int id;
  final String name;
  final String description;
  final double regularPrice;
  final double finalPrice;
  final String defaultImage;
  final bool isAvailable;

  RestaurantItem({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.finalPrice,
    required this.defaultImage,
    required this.isAvailable,
  });

  factory RestaurantItem.fromJson(Map<String, dynamic> json) {
    return RestaurantItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      regularPrice:
      double.tryParse(json['regularPrice'].toString()) ?? 0,
      finalPrice:
      double.tryParse(json['finalPrice'].toString()) ?? 0,
      defaultImage: json['defaultImage'] ?? '',
      isAvailable: json['isAvailable'] == 1,
    );
  }
}