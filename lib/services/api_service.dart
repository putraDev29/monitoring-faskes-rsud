import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monitoring_faskes_rsud/models/facility_model.dart';
import 'package:monitoring_faskes_rsud/models/input_facility_model.dart';
import 'package:monitoring_faskes_rsud/models/notification_model.dart';
import 'package:monitoring_faskes_rsud/models/profile_model.dart';
import '../models/dashboard_model.dart';
import '../utils/api_constant.dart';
import 'auth_service.dart';

class ApiService {
  static Future<DashboardModel> getDashboard() async {
    /// AMBIL TOKEN
    String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/dashboard"),

      headers: {
        "Accept": "application/json",

        /// BEARER TOKEN
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    return DashboardModel.fromJson(data);
  }

  static Future<List<Facility>> getFacilities() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/facilities"),
        headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      final result = FacilityResponse.fromJson(data);

      return result.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> storeFacility(
    InputFacilityModel data,
  ) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}/facilities"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data.toJson()),
      );

      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // services/api_service.dart

  static Future<Map<String, dynamic>> updateFacility(
    int id,
    EditFacilityModel data,
  ) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse("${ApiConstant.baseUrl}/facilities/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data.toJson()),
      );

      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<HistoryFacility>> getHistory() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/histories"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        HistoryFacilityResponse result = HistoryFacilityResponse.fromJson(
          jsonData,
        );

        // return list data
        return result.data;
      } else {
        return [];
      }
    } catch (e) {
      print("ERROR : $e");
      return [];
    }
  }

  static Future<ProfileResponse?> getProfile() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/profile"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return ProfileResponse.fromJson(json);
      } else {
        throw Exception(
          'Gagal mengambil profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil profile: $e');
    }
  }

  static Future<List<NotificationModel>> getNotifications(String filter) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/notifications"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      final List list = data['data'];

      return list.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> readNotification(int id) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/notifications/$id/read'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal update notifikasi');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> getUnreadNotificationCount() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/notifications/unread/count'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      return data['count'];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
