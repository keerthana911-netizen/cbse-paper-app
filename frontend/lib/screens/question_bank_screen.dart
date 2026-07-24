import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'question_form_screen.dart';

class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  late ApiService _api;
  List<Question> _questions = [];
  bool _loading = true;
  String? _error;
  String? _subjectFilter;

  @override
  void initState() {
    super.initState();
    _api = ApiService(context.read<AuthService>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final qs = await _api.listQuestions(subject: _subjectFilter);
      setState(() => _questions = qs);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(Question q) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete question?'),
        content: Text(q.questionText, maxLines: 3, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _api.deleteQuestion(q.id);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Bank'),
        actions: [
          PopupMenuButton<String?>(
            tooltip: 'Filter by subject',
            onSelected: (v) {
              setState(() => _subjectFilter = v);
              _load();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All subjects')),
              PopupMenuItem(value: 'Math', child: Text('Math')),
              PopupMenuItem(value: 'English', child: Text('English')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add question'),
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const QuestionFormScreen()),
          );
          if (created == true) _load();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Error: $_error')))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _questions.isEmpty
                      ? ListView(children: const [
                          Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: Text('No questions yet. Tap "Add question" to create one.')),
                          )
                        ])
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: _questions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final q = _questions[i];
                            return Card(
                              child: ListTile(
                                title: Text(q.questionText, maxLines: 2, overflow: TextOverflow.ellipsis),
                                subtitle: Text('${q.subject} · ${q.chapter} · ${q.difficulty} · ${q.marks} mark(s)'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () async {
                                        final updated = await Navigator.of(context).push<bool>(
                                          MaterialPageRoute(builder: (_) => QuestionFormScreen(existing: q)),
                                        );
                                        if (updated == true) _load();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20),
                                      onPressed: () => _delete(q),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
