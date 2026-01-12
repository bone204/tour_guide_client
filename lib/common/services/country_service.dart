import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_guide_app/features/auth/data/models/country.dart';

class CountryService {
  Future<List<Country>> fetchCountries() async {
    final response = await http.get(
      Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flags,cca2,translations',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
