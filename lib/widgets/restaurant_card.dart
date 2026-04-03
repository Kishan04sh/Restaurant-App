import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../screens/restaurant/view/restaurant_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: (){
            Navigator.push(
                context, MaterialPageRoute(
              builder:(context) => RestaurantDetailScreen(restaurant: restaurant,)
            ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= IMAGE =================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    restaurant.image,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    /// Loading state
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 170,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },

                    ///Error state
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 170,
                        color: Colors.grey.shade300,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            SizedBox(height: 6),
                            Text(
                              "Image not available",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// Gradient overlay (modern feel)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                /// Rating badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: _badge(
                    icon: Icons.star,
                    text: restaurant.rating.toStringAsFixed(1),
                    color: Colors.green,
                  ),
                ),

                /// Open/Closed
                Positioned(
                  top: 10,
                  left: 10,
                  child: _statusBadge(restaurant.isOpen),
                ),

                /// Restaurant name on image
                Positioned(
                  bottom: 10,
                  left: 12,
                  right: 12,
                  child: Text(
                    restaurant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            /// ================= DETAILS =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Category
                  Text(
                    restaurant.categoryName.isNotEmpty
                        ? restaurant.categoryName.join(" • ")
                        : "Multi Cuisine",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Distance + Time + Min Order
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _info(Icons.location_on,
                          _formatDistance(restaurant.distance)),
                      _info(Icons.access_time,
                          "${restaurant.deliveryTime} min"),
                      _info(Icons.currency_rupee,
                          "Min ${restaurant.minimumOrderValue}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Logo + CTA
                  Row(
                    children: [
                      /// Logo
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: restaurant.logo.isNotEmpty
                            ? NetworkImage(restaurant.logo)
                            : null,
                        child: restaurant.logo.isEmpty
                            ? const Icon(Icons.store, size: 16)
                            : null,
                      ),

                      const SizedBox(width: 10),

                      const Spacer(),

                      GestureDetector(
                        onTap: restaurant.isOpen ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          );
                        } : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: restaurant.isOpen
                                ? const LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                            )
                                : LinearGradient(
                              colors: [Colors.grey.shade400, Colors.grey.shade400],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SMALL WIDGETS =================

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? "OPEN" : "CLOSED",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _formatDistance(double distance) {
    return "${(distance / 1000).toStringAsFixed(1)} km";
  }
}