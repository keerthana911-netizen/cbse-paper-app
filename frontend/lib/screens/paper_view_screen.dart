import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Change this to your deployed backend URL, e.g.
/// 'https://cbse-paper-backend.onrender.com'
/// For local testing:
///   Android emulator -> 'http://10.0.2.2:8000'
///   iOS simulator / Flutter web -> 'http://localhost:8000'
const String kBackendBaseUrl = 'https://cbse-paper-backend.onrender.com';

const Map<String, Color> kDifficultyColors = {
  'Easy': Color(0xFF2E7D32),
  'Medium': Color(0xFFEF6C00),
  'Hard': Color(0xFFC62828),
};

const Map<String, Color> kSubjectColors = {
  'Math': Color(0xFF1F3D7A),
  'Maths': Color(0xFF1F3D7A),
  'English': Color(0xFF7A1F1F),
  'EVS': Color(0xFF2E7D32),
  'Hindi': Color(0xFFEF6C00),
};

const Map<String, IconData> kSubjectIcons = {
  'Math': Icons.calculate_rounded,
  'Maths': Icons.calculate_rounded,
  'English': Icons.menu_book_rounded,
  'EVS': Icons.eco_rounded,
  'Hindi': Icons.translate_rounded,
};

class PaperViewScreen extends StatelessWidget {
  final String subject; // display label, e.g. "Maths"
  final String apiSubject; // key used in the backend URL, e.g. "Class3_Maths"
  final int classLevel;
  final String difficulty;
  final int marks;

  const PaperViewScreen({
    super.key,
    required this.subject,
    String? apiSubject,
    this.classLevel = 5,
    required this.difficulty,
    required this.marks,
  }) : apiSubject = apiSubject ?? subject;

  String get _paperUrl => '$kBackendBaseUrl/papers/fixed/$apiSubject/$difficulty/$marks';
  String get _keyUrl => '$kBackendBaseUrl/papers/fixed/$apiSubject/$difficulty/$marks/key';

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the PDF. Check that the backend is running and reachable.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectColor = kSubjectColors[subject] ?? Colors.indigo;
    final difficultyColor = kDifficultyColors[difficulty] ?? Colors.grey;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FB),
      appBar: AppBar(
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: subjectColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: subjectColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              kSubjectIcons[subject] ?? Icons.description_rounded,
                              color: subjectColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$subject CA-1', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                const Text('Chapters 1–3', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _Badge(label: difficulty, color: difficultyColor),
                          const SizedBox(width: 8),
                          _Badge(label: '$marks Marks', color: Colors.blueGrey),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
                          label: const Text('View Question Paper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          style: FilledButton.styleFrom(
                            backgroundColor: subjectColor,
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => _openUrl(context, _paperUrl),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.key_rounded, color: subjectColor, size: 22),
                          label: Text('View Answer Key', style: TextStyle(color: subjectColor, fontSize: 16, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            side: BorderSide(color: subjectColor, width: 1.6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => _openUrl(context, _keyUrl),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Opens in a new browser tab. Use the download icon inside the PDF viewer to save it.',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
    );
  }
}
