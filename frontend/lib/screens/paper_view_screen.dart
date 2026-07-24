import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

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

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the PDF. Check your connection.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    final api = ApiService(auth);
    final paperUrl = api.paperUrl(subject: subject, difficulty: difficulty, marks: marks);

    return Scaffold(
      appBar: AppBar(title: Text('$subject · $difficulty · $marks Marks')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$subject CA-1', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Chapters 1–3 · $difficulty · $marks marks',
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Open Question Paper'),
                        onPressed: () => _openUrl(context, paperUrl),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.key),
                        label: const Text('Open Answer Key (login required)'),
                        onPressed: () async {
                          try {
                            final bytes = await api.downloadAnswerKeyBytes(
                              subject: subject,
                              difficulty: difficulty,
                              marks: marks,
                            );
                            // In a full build, save `bytes` locally (e.g. with
                            // path_provider) and open it, or share it directly.
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Answer key downloaded (${bytes.length} bytes).')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not fetch the answer key: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tip: "Open Question Paper" launches the PDF in your browser / PDF '
                'viewer app. For an in-app PDF viewer, add a package like '
                'flutter_pdfview or syncfusion_flutter_pdfviewer once you confirm '
                'which one builds cleanly for your Flutter version.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
