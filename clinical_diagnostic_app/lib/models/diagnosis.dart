class Diagnosis {
  final String diagnosis;
  final int confidence;
  final List<String> matchedSymptoms;
  final int requiredMatched;
  final int totalRequired;
  final String reasoning;
  final String? icd10;
  final List<String> recommendations;

  Diagnosis({
    required this.diagnosis,
    required this.confidence,
    required this.matchedSymptoms,
    required this.requiredMatched,
    required this.totalRequired,
    required this.reasoning,
    this.icd10,
    required this.recommendations,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      diagnosis: json['diagnosis'] ?? '',
      confidence: json['confidence'] ?? 0,
      matchedSymptoms: List<String>.from(json['matchedSymptoms'] ?? []),
      requiredMatched: json['requiredMatched'] ?? 0,
      totalRequired: json['totalRequired'] ?? 0,
      reasoning: json['reasoning'] ?? '',
      icd10: json['icd10'],
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'confidence': confidence,
      'matchedSymptoms': matchedSymptoms,
      'requiredMatched': requiredMatched,
      'totalRequired': totalRequired,
      'reasoning': reasoning,
      'icd10': icd10,
      'recommendations': recommendations,
    };
  }
}