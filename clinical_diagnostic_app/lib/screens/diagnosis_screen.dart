import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/diagnosis_provider.dart';
import '../services/api_service.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Diagnostic Assistant'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Logged in as: ${authProvider.user?['email'] ?? 'Unknown'}'),
                  ),
                  PopupMenuItem(
                    child: const Text('Logout'),
                    onTap: () {
                      authProvider.logout();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<DiagnosisProvider>(
        builder: (context, diagnosisProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpecialtySelection(diagnosisProvider),
                const SizedBox(height: 24),
                if (diagnosisProvider.selectedSpecialty != null) ...[
                  _buildSymptomSelection(diagnosisProvider),
                  const SizedBox(height: 24),
                  _buildActionButtons(diagnosisProvider),
                  const SizedBox(height: 24),
                  if (diagnosisProvider.error != null)
                    _buildErrorMessage(diagnosisProvider.error!),
                  if (diagnosisProvider.isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (diagnosisProvider.diagnoses.isNotEmpty)
                    _buildDiagnosisResults(diagnosisProvider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialtySelection(DiagnosisProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Medical Specialty',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: provider.specialties.map((specialty) {
                return ChoiceChip(
                  label: Text(specialty),
                  selected: provider.selectedSpecialty == specialty,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setSpecialty(specialty);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomSelection(DiagnosisProvider provider) {
    final availableSymptoms = provider.getAvailableSymptoms();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Symptoms',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: availableSymptoms.map((symptom) {
                return FilterChip(
                  label: Text(symptom),
                  selected: provider.selectedSymptoms.contains(symptom),
                  onSelected: (selected) {
                    provider.toggleSymptom(symptom);
                  },
                );
              }).toList(),
            ),
            if (provider.selectedSymptoms.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Selected: ${provider.selectedSymptoms.join(', ')}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(DiagnosisProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: provider.selectedSymptoms.isEmpty
                ? null
                : () => provider.getDiagnosis(),
            child: const Text('Get Diagnosis'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => provider.clearAll(),
            child: const Text('Clear All'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String error) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisResults(DiagnosisProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Diagnostic Results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () => _showEmailDialog(provider),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.diagnoses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final diagnosis = provider.diagnoses[index];
                return ListTile(
                  title: Text(
                    diagnosis.diagnosis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confidence: ${diagnosis.confidence}%'),
                      Text('Reasoning: ${diagnosis.reasoning}'),
                      if (diagnosis.icd10 != null)
                        Text('ICD-10: ${diagnosis.icd10}'),
                      if (diagnosis.recommendations.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.w500)),
                        ...diagnosis.recommendations.map(
                          (rec) => Text('• $rec', style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _getConfidenceColor(diagnosis.confidence),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }

  void _showEmailDialog(DiagnosisProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Report'),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_emailController.text.isNotEmpty) {
                final reportData = {
                  'symptoms': provider.selectedSymptoms,
                  'diagnoses': provider.diagnoses.map((d) => d.toJson()).toList(),
                  'timestamp': DateTime.now().toIso8601String(),
                };
                
                final success = await ApiService.emailReport(_emailController.text, reportData);
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Report sent successfully!' : 'Failed to send report'),
                  ),
                );
                
                _emailController.clear();
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}