import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String apiKey = "${dotenv.env['API_KEY']}";
String defaultCity = "caracas";
String defaultAmountOfDays = "1";
DateTime date = DateTime.now();

class DataRepository {
  DataRepository(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<String?> fetchData() async {
    final localData = sharedPreferences.getString('data');

    if (localData != null) {
      return localData;
    }

    final response = await http.get(
      Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?q=$defaultCity&days=$defaultAmountOfDays&dt=$date&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      sharedPreferences.setString('data', response.body);

      return response.body;
    }

    throw Exception('Failed to load data');
  }
}
