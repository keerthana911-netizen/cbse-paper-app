import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Change this to your deployed backend URL, e.g.
/// 'https://cbse-paper-backend.onrender.com'
/// For local testing:
///   Android emulator -> 'http://10.0.2.2:8000'
///   iOS simulator / Flutter web -> 'http://localhost:8000'
const String kBackendBaseUrl = 'http://localhost:8000';

const Map<String, Color> kDifficultyColors = {
  'Easy': Color(0xFF2E7D32),
  'Medium': Color(0xFFEF6C00),
  'Hard': Color(0xFFC62828),
};

const Map<String, Color> kSubjectColors = {
  'Math': Color(0xFF1F3D7A),
  'English': Color(0xFF7A1F1F),
};

class PaperViewScreen extends StatelessWidget {
  final String subject;
  final String difficulty;
  final int marks;

  const PaperViewScreen({
    super.key,
    required this.subject,
    required this.difficulty,
    required this.marks,
  });

  String get _paperUrl => '$kBackendBaseUrl/papers/fixed/$subject/$difficulty/$marks';
  String get _keyUrl => '$kBackendBaseUrl/papers/fixed/$subject/$difficulty/$marks/key';

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
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: subjectColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: subjectColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              subject == 'Math' ? Icons.calculate_rounded : Icons.menu_book_rounded,
                              color: subjectColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$subject CA-1', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 3),
                                const Text('Chapters 1–3', style: TextStyle(color: Colors.grey, fontSize: 12.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _Badge(label: difficulty, color: difficultyColor),
                          const SizedBox(width: 8),
                          _Badge(label: '$marks Marks', color: Colors.blueGrey),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          label: const Text('Open / Download Question Paper'),
                          style: FilledButton.styleFrom(
                            backgroundColor: subjectColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _openUrl(context, _paperUrl),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.key_rounded, color: subjectColor),
                          label: Text('Open / Download Answer Key', style: TextStyle(color: subjectColor)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: BorderSide(color: subjectColor, width: 1.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _openUrl(context, _keyUrl),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Both buttons open the PDF in your browser / device PDF viewer, '
                'which has its own save or download option.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w700)),
    );
  }
}
