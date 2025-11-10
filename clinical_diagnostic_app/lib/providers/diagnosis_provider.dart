import 'package:flutter/material.dart';
import '../models/diagnosis.dart';
import '../services/api_service.dart';

class DiagnosisProvider with ChangeNotifier {
  List<String> _selectedSymptoms = [];
  String? _selectedSpecialty;
  List<Diagnosis> _diagnoses = [];
  bool _isLoading = false;
  String? _error;

  List<String> get selectedSymptoms => _selectedSymptoms;
  String? get selectedSpecialty => _selectedSpecialty;
  List<Diagnosis> get diagnoses => _diagnoses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<String> specialties = [
    'Internal Medicine',
    'Psychiatry',
    'Dermatology',
  ];

  final Map<String, List<String>> symptomsBySpecialty = {
    'Internal Medicine': [
      'fever',
      'cough',
      'fatigue',
      'body aches',
      'headache',
      'shortness of breath',
      'chest pain',
      'nausea',
      'vomiting',
      'diarrhea',
    ],
    'Psychiatry': [
      'depressed mood',
      'loss of interest',
      'sleep disturbance',
      'concentration problems',
      'anxiety',
      'mood swings',
      'irritability',
      'social withdrawal',
    ],
    'Dermatology': [
      'itchy skin',
      'red rash',
      'dry skin',
      'skin inflammation',
      'blisters',
      'scaling',
      'burning sensation',
      'swelling',
    ],
  };

  void setSpecialty(String specialty) {
    _selectedSpecialty = specialty;
    _selectedSymptoms.clear();
    _diagnoses.clear();
    _error = null;
    notifyListeners();
  }

  void toggleSymptom(String symptom) {
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }
    notifyListeners();
  }

  Future<void> getDiagnosis() async {
    if (_selectedSymptoms.isEmpty) {
      _error = 'Please select at least one symptom';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _diagnoses = await ApiService.getDiagnosis(_selectedSymptoms, _selectedSpecialty);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAll() {
    _selectedSymptoms.clear();
    _selectedSpecialty = null;
    _diagnoses.clear();
    _error = null;
    notifyListeners();
  }

  List<String> getAvailableSymptoms() {
    if (_selectedSpecialty == null) return [];
    return symptomsBySpecialty[_selectedSpecialty!] ?? [];
  }
}