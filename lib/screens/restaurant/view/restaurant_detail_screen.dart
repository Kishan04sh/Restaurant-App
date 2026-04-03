import 'package:flutter/material.dart';
import '../../../models/restaurant.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool isExpanded = false;
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          /// MAIN SCROLL
          CustomScrollView(
            slivers: [
              ///  HEADER
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  title: Text(
                    r.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        r.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///  CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STATUS + RATING
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          _chip(Icons.star, "${r.rating}",
                              Colors.green),
                          _chip(
                            Icons.circle,
                            r.isOpen ? "OPEN" : "CLOSED",
                            r.isOpen
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// CATEGORY
                      Text(
                        r.categoryName.isNotEmpty
                            ? r.categoryName.join(" • ")
                            : "Multi Cuisine",
                        style: TextStyle(
                            color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 14),

                      /// DESCRIPTION
                      Text(
                        r.description,
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() => isExpanded = !isExpanded);
                        },
                        child: Text(
                          isExpanded ? "Read less" : "Read more",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// INFO CARDS
                      Row(
                        children: [
                          _infoCard(
                            Icons.location_on,
                            "${(r.distance / 1000).toStringAsFixed(1)} km",
                          ),
                          _infoCard(
                            Icons.access_time,
                            "${r.deliveryTime} min",
                          ),
                          _infoCard(
                            Icons.currency_rupee,
                            "Min ${r.minimumOrderValue}",
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// MENU TITLE
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       "Menu",
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //
                      //     ///  TOGGLE (GRID / LIST)
                      //     Container(
                      //       padding: const EdgeInsets.all(4),
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade200,
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           /// GRID BUTTON
                      //           GestureDetector(
                      //             onTap: () {
                      //               if (!isGrid) {
                      //                 setState(() => isGrid = true);
                      //               }
                      //             },
                      //             child: AnimatedContainer(
                      //               duration: const Duration(milliseconds: 250),
                      //               padding: const EdgeInsets.all(8),
                      //               decoration: BoxDecoration(
                      //                 color: isGrid ? Colors.orange : Colors.transparent,
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               child: Icon(
                      //                 Icons.grid_view,
                      //                 size: 20,
                      //                 color: isGrid ? Colors.white : Colors.grey,
                      //               ),
                      //             ),
                      //           ),
                      //
                      //           /// LIST BUTTON
                      //           GestureDetector(
                      //             onTap: () {
                      //               if (isGrid) {
                      //                 setState(() => isGrid = false);
                      //               }
                      //             },
                      //             child: AnimatedContainer(
                      //               duration: const Duration(milliseconds: 250),
                      //               padding: const EdgeInsets.all(8),
                      //               decoration: BoxDecoration(
                      //                 color: !isGrid ? Colors.orange : Colors.transparent,
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               child: Icon(
                      //                 Icons.view_list,
                      //                 size: 20,
                      //                 color: !isGrid ? Colors.white : Colors.grey,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const Text( "Menu", style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold, ), ),

                      const SizedBox(height: 12),

                      ///  GRID MENU
                      if (r.items.isEmpty)
                        const Text("No items available")
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: r.items.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                            width < 600 ? 2 : 3, // responsive
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            return _menuGridCard(r.items[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          ///  BACK BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CHIP
  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// INFO CARD
  Widget _infoCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(height: 6),
            Text(text, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  ///  GRID CARD
  Widget _menuGridCard(RestaurantItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              item.defaultImage,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Icon(Icons.fastfood),
              ),
            ),
          ),

          /// DETAILS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${item.finalPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                          BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "ADD",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}