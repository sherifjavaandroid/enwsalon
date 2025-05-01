import 'package:easycut/core/class/status_request.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/data/data_source/remote/search/salon_search_data.dart';
import 'package:easycut/data/data_source/remote/rating/rating_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalonSearchController extends GetxController {
  // Dependencies
  SalonSearchData salonSearchData = SalonSearchData(Get.find());
  RatingData ratingData = RatingData(Get.find());
  MyServices myServices = Get.find();

  // Search
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  Map<int, double> salonRatings = {}; // Store salon ratings by salon ID
  bool isLoading = false;

  // Filters
  bool filterByRating = false;
  String? filterByGender;

  // Perform search with API call
  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      update();
      return;
    }

    isLoading = true;
    update();

    try {
      var response = await salonSearchData.searchSalons(query);

      if (response is List) {
        searchResults = response;

        // Fetch ratings for all salons
        await _fetchSalonRatings();

        // Apply filters if needed
        _applyFilters();
      } else {
        searchResults = [];
      }
    } catch (e) {
      searchResults = [];
      print("Error searching salons: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchResults = [];
    update();
  }

  // Toggle rating filter
  void toggleRatingFilter() {
    filterByRating = !filterByRating;
    _applyFilters();
    update();
  }

  // Set gender filter
  void setGenderFilter(String gender) {
    if (filterByGender == gender) {
      filterByGender = null; // Toggle off if already selected
    } else {
      filterByGender = gender;
    }
    _applyFilters();
    update();
  }

  // Apply all active filters
  void _applyFilters() {
    // Create a copy of the original search results
    var filteredResults = List.from(searchResults);

    // Apply gender filter if set
    if (filterByGender != null) {
      filteredResults = filteredResults.where((salon) {
        return salon.gender == filterByGender;
      }).toList();
    }

    // Apply rating filter if enabled
    if (filterByRating) {
      // Sort by rating (highest first)
      filteredResults.sort((a, b) {
        double ratingA = salonRatings[a.id] ?? 0;
        double ratingB = salonRatings[b.id] ?? 0;
        return ratingB.compareTo(ratingA);
      });
    }

    searchResults = filteredResults;
  }

  // Fetch ratings for all salons in search results
  Future<void> _fetchSalonRatings() async {
    String userId = myServices.sharedPreferences.getInt('id')?.toString() ?? '0';

    for (var salon in searchResults) {
      if (salon.id != null) {
        try {
          var response = await ratingData.getSalonRatings(salon.id.toString(), userId);

          if (response['status'] == 'success' && response['data'] != null) {
            double averageRating = double.tryParse(response['data']['averageRating'].toString()) ?? 0.0;
            salonRatings[salon.id] = averageRating;
          }
        } catch (e) {
          print("Error fetching rating for salon ${salon.id}: $e");
        }
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}