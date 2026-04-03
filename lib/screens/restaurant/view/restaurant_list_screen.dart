import 'package:flutter/material.dart';
import '../../../models/restaurant.dart';
import '../../../widgets/error_fallback.dart';
import '../../../widgets/restaurant_card.dart';
import '../controller/restaurant_controller.dart';
import '../../../core/api_client.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  late RestaurantListController controller;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = RestaurantListController(ApiClient());
    /// Safe API call after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadInitial(context);
    });

    /// Pagination listener
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final max = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;

      if (current >= max - 100) {
        controller.loadMore(context);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    controller.onSearchChanged(value, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.restaurant, color: Colors.orange),
            ),

            const SizedBox(width: 10),

            /// 🔹 Title + Subtitle
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Restaurants",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Explore nearby food",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),

        /// Actions
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Coming soon"),
                ),
              );
              },
          ),

          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Coming soon"),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// ================= SEARCH =================
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  _onSearch(value);
                  setState(() {}); // 🔥 UI refresh for icon show/hide
                },
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search restaurants...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      controller.onSearchChanged("", context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear_rounded,color: Colors.red, size: 20,),
                  )
                      : null,
                ),
              ),
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.isError,
              builder: (context, isError, _) {
                if (isError) {
                  return ErrorFallbackWidget(
                    message: "Failed to load restaurants.",
                    onRetry: () => controller.retry(context),
                  );
                }

                return ValueListenableBuilder<List<Restaurant>>(
                  valueListenable: controller.restaurants,
                  builder: (context, list, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: controller.isLoading,
                      builder: (context, loading, _) {

                        /// First load loader
                        if (loading && list.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        /// Empty state
                        if (list.isEmpty) {
                          final isSearching = controller.currentQuery.isNotEmpty;

                          return ErrorFallbackWidget(
                            message: isSearching
                                ? "No record found for \"${controller.currentQuery}\""
                                : "No restaurants found",
                            onRetry: () => controller.retry(context),
                          );
                        }

                        /// List
                        return ListView.builder(
                          controller: scrollController,
                          itemCount:
                          list.length + (controller.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < list.length) {
                              return RestaurantCard(
                                restaurant: list[index],
                              );
                            }

                            /// Load more loader
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}