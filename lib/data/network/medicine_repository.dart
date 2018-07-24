import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medical_app/config.dart';
import 'package:medical_app/data/model/medicine.dart';

class MedicineRepository {
  Future<List<Medicine>> fetchAllMedicines(String userId) async {
    final response = await http.get('${Config.url}/medicine/$userId');
    print(response.body);
    final jsonResponse = json.decode(response.body);

    var medicines = Medicine.fromJsonArray(jsonResponse);
    return medicines;
  }

  Future<List<Medicine>> fetchMedicineByQuery(String query) async {
    final response = await http.get('${Config.url}/medicine/search/query?q=$query');
    print(response.body);
    final jsonResponse = json.decode(response.body);

    var medicines = Medicine.fromJsonArray(jsonResponse);
    return medicines;
  }

  Future<Null> addMedicine(Medicine medicine, String userId) async {
    try {
      final response = await http.post('${Config.url}/medicine/user/$userId', body: {
        'barcode': medicine.barcode,
        'name': medicine.name,
        'ingredient': medicine.ingredient,
        'category': medicine.category,
        'type': medicine.type,
        'for': medicine.fors,
        'method': medicine.method,
        'notice': medicine.notice,
        'keeping': medicine.keeping,
        'forget': medicine.forget,
        'user_id': userId,
      });

      print(response.request);
    } catch (error) {
      print(error.toString());
    }
  }
}
