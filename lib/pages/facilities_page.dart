// pages/facilities_page.dart

import 'package:flutter/material.dart';
import 'package:monitoring_faskes_rsud/pages/detail_facility_page.dart';
import 'package:monitoring_faskes_rsud/pages/input_facility_form.dart';
import 'package:monitoring_faskes_rsud/services/api_service.dart';
import 'package:monitoring_faskes_rsud/widgets/reusable_bottom_nav.dart';

import '../models/facility_model.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({super.key});

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  List<Facility> facilities = [];
  List<Facility> filteredFacilities = [];

  bool isLoading = true;

  String selectedFilter = "Semua";
  String searchQuery = "";

  final List<String> filters = ["Semua", "safe", "warning", "critical"];

  @override
  void initState() {
    super.initState();
    getFacilities();
  }

  Future<void> getFacilities() async {
    try {
      final result = await ApiService.getFacilities();

      setState(() {
        facilities = result;
        filteredFacilities = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  void applyFilter() {
    List<Facility> result = facilities;

    // FILTER STATUS
    if (selectedFilter != "Semua") {
      result = result.where((item) {
        return item.status.toLowerCase() == selectedFilter.toLowerCase();
      }).toList();
    }

    // SEARCH
    if (searchQuery.isNotEmpty) {
      result = result.where((item) {
        return item.facilityType.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }).toList();
    }

    setState(() {
      filteredFacilities = result;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'safe':
        return Colors.green;

      case 'warning':
        return Colors.orange;

      case 'critical':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String getStatusName(String status) {
    switch (status) {
      case 'safe':
        return 'Aman';

      case 'warning':
        return 'Waspada';

      case 'critical':
        return 'Penuh';

      default:
        return 'Semua';
    }
  }

  Color getCardColor(String color) {
    switch (color) {
      case 'blue':
        return Colors.blue;

      case 'green':
        return Colors.green;

      case 'orange':
        return Colors.orange;

      case 'purple':
        return Colors.purple;

      case 'cyan':
        return Colors.cyan;

      case 'lime':
        return Colors.lime;

      case 'yellow':
        return Colors.amber;

      case 'pink':
        return Colors.pink;

      case 'indigo':
        return Colors.indigo;

      default:
        return Colors.grey;
    }
  }

  IconData getIcon(String icon) {
    switch (icon) {
      case 'baby':
        return Icons.child_care;

      case 'activity':
        return Icons.monitor_heart;

      case 'heart':
        return Icons.favorite;

      case 'stethoscope':
        return Icons.medical_services;

      case 'hospital':
        return Icons.local_hospital;

      case 'home':
        return Icons.home;

      case 'shield':
        return Icons.shield;

      case 'scissors':
        return Icons.content_cut;

      case 'plus':
        return Icons.add;

      default:
        return Icons.medical_information;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      bottomNavigationBar: const ReusableBottomNav(selected: 2),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0D47A1),
        automaticallyImplyLeading: false,
        title: const Text(
          "Daftar Fasilitas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),

        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputFacilityForm()),
                );

                // REFRESH DATA SETELAH TAMBAH
                if (result == true) {
                  getFacilities();
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // SEARCH
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilter();
                    },
                    decoration: InputDecoration(
                      hintText: "Cari fasilitas...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // FILTER
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];

                      final isSelected = selectedFilter == filter;

                      Color selectedColor = const Color(0xFF0D47A1);

                      if (filter.toLowerCase() == "safe") {
                        selectedColor = Colors.green;
                      } else if (filter.toLowerCase() == "warning") {
                        selectedColor = Colors.orange;
                      } else if (filter.toLowerCase() == "critical") {
                        selectedColor = Colors.red;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });

                          applyFilter();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: isSelected ? selectedColor : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedColor.withOpacity(0.25),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            getStatusName(filter),
                            style: TextStyle(
                              color: isSelected ? Colors.white : selectedColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFacilities.length,

                    itemBuilder: (context, index) {
                      final item = filteredFacilities[index];

                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(18),

                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),

                          splashColor: Colors.black.withOpacity(0.05),

                          highlightColor: Colors.black.withOpacity(0.08),

                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailFacilityPage(facility: item),
                              ),
                            );

                            // REFRESH SETELAH EDIT
                            if (result == true) {
                              getFacilities();
                            }
                          },

                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [
                                // ICON
                                Container(
                                  width: 54,
                                  height: 54,

                                  decoration: BoxDecoration(
                                    color: getCardColor(
                                      item.facilityType.color,
                                    ).withOpacity(0.15),

                                    borderRadius: BorderRadius.circular(16),
                                  ),

                                  child: Icon(
                                    getIcon(item.facilityType.icon),

                                    color: getCardColor(
                                      item.facilityType.color,
                                    ),

                                    size: 28,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // CONTENT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        item.facilityType.name,

                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "Tersedia ${item.availableUnit} dari ${item.totalUnit}",

                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),

                                              child: LinearProgressIndicator(
                                                value:
                                                    item.availableUnit /
                                                    item.totalUnit,

                                                minHeight: 8,

                                                backgroundColor:
                                                    Colors.grey.shade200,

                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      getStatusColor(
                                                        item.status,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          Text(
                                            "${item.percentage}%",

                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // STATUS
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),

                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      item.status,
                                    ).withOpacity(0.12),

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    getStatusName(item.status),

                                    style: TextStyle(
                                      color: getStatusColor(item.status),

                                      fontWeight: FontWeight.bold,

                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // ARROW ICON
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
