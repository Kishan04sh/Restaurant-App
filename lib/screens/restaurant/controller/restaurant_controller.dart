import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../models/restaurant.dart';
import '../../../core/api_client.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_config.dart';

class RestaurantListController {
  final ApiClient apiClient;

  RestaurantListController(this.apiClient);

  /// ================= STATES =================
  final ValueNotifier<List<Restaurant>> restaurants = ValueNotifier<List<Restaurant>>([]);

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  final ValueNotifier<bool> isError = ValueNotifier(false);

  /// ================= PAGINATION =================
  int page = 1;
  bool hasMore = true;

  /// ================= SEARCH =================
  Timer? _debounce;
  String _currentQuery = "";
  String get currentQuery => _currentQuery;

  /// ================= INIT LOAD =================
  Future<void> loadInitial(BuildContext context) async {
    page = 1;
    hasMore = true;
    restaurants.value = [];
    await fetchRestaurants(context);
  }

  /// ================= SEARCH =================
  void onSearchChanged(String query, BuildContext context) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentQuery = query;
      loadInitial(context);
    });
  }

  /// ================= MAIN API =================
  Future<void> fetchRestaurants(BuildContext context) async {
    if (!hasMore) return;

    try {
      /// Loading states
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      isError.value = false;

      final config = AppConfig.of(context);

      final url =
          "${AppConstant.baseUrl}/restaurant/search"
          "?lang=${AppConstant.lang}"
          "&storeCode=${AppConstant.storeCode}"
          "&page=$page"
          "&perPage=20"
          "&q=$_currentQuery"
          "&latlng=${AppConstant.latlng}"
          "&userId=${AppConstant.userId}";

      /// API CALL
      final raw = await apiClient.post(
        url,
        config.headers,
        {},
      );

      print(" RAW RESPONSE: $raw");

      /// SAFE JSON DECODE
      final response = raw is String ? jsonDecode(raw) : raw;

      /// PARSE MODEL
      final model = RestaurantResponse.fromJson(response);

      final newData = model.restaurants;

      print("API COUNT: ${newData.length}");
      print("CURRENT PAGE: $page");

      /// ASSIGN DATA
      if (page == 1) {
        restaurants.value = newData;
      } else {
        restaurants.value = [
          ...restaurants.value,
          ...newData,
        ];
      }

      /// PAGINATION FIX
      hasMore = newData.isNotEmpty;
      if (hasMore) page++;

    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("❌ STACK: $stack");
      isError.value = true;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// ================= LOAD MORE =================
  Future<void> loadMore(BuildContext context) async {
    if (isLoadingMore.value || isLoading.value) return;
    await fetchRestaurants(context);
  }

  /// ================= RETRY =================
  Future<void> retry(BuildContext context) async {
    await loadInitial(context);
  }

  /// ================= DISPOSE =================
  void dispose() {
    _debounce?.cancel();
  }
}