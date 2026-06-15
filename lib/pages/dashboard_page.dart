import 'package:flutter/material.dart';
import 'package:monitoring_faskes_rsud/pages/facilities_page.dart';

import '../config/app_color.dart';
import '../models/dashboard_model.dart';
import '../services/api_service.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/reusable_bottom_nav.dart';
import '../widgets/stat_card.dart';
import '../widgets/warning_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardModel? dashboard;

  getData() async {
    dashboard = await ApiService.getDashboard();

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      bottomNavigationBar: const ReusableBottomNav(selected: 0),

      body: dashboard == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// HEADER
                  DashboardHeader(
                    hospitalName: dashboard!.hospital.name,

                    description: dashboard!.hospital.description,

                    status: dashboard!.hospital.status,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        /// ROW 1
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: "Total Fasilitas",

                                subtitle: "Jenis",

                                value: dashboard!.summary.totalFacility,

                                color: AppColor.blue,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: StatCard(
                                title: "Total Tersedia",

                                subtitle: "Unit",

                                value: dashboard!.summary.totalAvailableUnit,

                                color: AppColor.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// ROW 2
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: "Aman",

                                subtitle: "Fasilitas",

                                value: dashboard!.summary.safe,

                                color: AppColor.green,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: StatCard(
                                title: "Waspada",

                                subtitle: "Fasilitas",

                                value: dashboard!.summary.warning,

                                color: AppColor.orange,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// ROW 3
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: "Kritis",

                                subtitle: "Fasilitas",

                                value: dashboard!.summary.critical,

                                color: AppColor.red,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),

                                  borderRadius: BorderRadius.circular(18),

                                  /// ADD BORDER
                                  border: Border.all(
                                    color: Colors.purple.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Persediaan",
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const Text(
                                      "",
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      "${dashboard!.summary.percentage}%",
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    LinearProgressIndicator(
                                      value:
                                          dashboard!.summary.percentage / 100,
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        /// TITLE ALERT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              "Peringatan",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 18,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FacilitiesPage(),
                                  ),
                                );
                              },

                              child: const Text("Lihat Semua"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// ALERT LIST
                        ListView.builder(
                          itemCount: dashboard!.alerts.length,

                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemBuilder: (context, index) {
                            final item = dashboard!.alerts[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: WarningCard(
                                facilityName: item.facilityName,

                                available: item.available,

                                total: item.total,

                                percentage: item.percentage,

                                status: item.status,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
