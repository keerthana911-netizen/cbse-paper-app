import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class QuestionFormScreen extends StatefulWidget {
  final Question? existing;
  const QuestionFormScreen({super.key, this.existing});

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionCtrl;
  late TextEditingController _chapterCtrl;
  late TextEditingController _optACtrl, _optBCtrl, _optCCtrl, _optDCtrl;
  late TextEditingController _answerTextCtrl;
  late TextEditingController _marksCtrl;

  String _subject = 'Math';
  String _difficulty = 'Easy';
  String _questionType = 'mcq';
  String? _correctOption;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _questionCtrl = TextEditingController(text: e?.questionText ?? '');
    _chapterCtrl = TextEditingController(text: e?.chapter ?? '');
    _optACtrl = TextEditingController(text: e?.optionA ?? '');
    _optBCtrl = TextEditingController(text: e?.optionB ?? '');
    _optCCtrl = TextEditingController(text: e?.optionC ?? '');
    _optDCtrl = TextEditingController(text: e?.optionD ?? '');
    _answerTextCtrl = TextEditingController(text: e?.answerText ?? '');
    _marksCtrl = TextEditingController(text: '${e?.marks ?? 1}');
    _subject = e?.subject ?? 'Math';
    _difficulty = e?.difficulty ?? 'Easy';
    _questionType = e?.questionType ?? 'mcq';
    _correctOption = e?.correctOption;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final q = Question(
      id: widget.existing?.id ?? 0,
      subject: _subject,
      chapter: _chapterCtrl.text.trim(),
      difficulty: _difficulty,
      questionText: _questionCtrl.text.trim(),
      optionA: _questionType == 'mcq' ? _optACtrl.text.trim() : null,
      optionB: _questionType == 'mcq' ? _optBCtrl.text.trim() : null,
      optionC: _questionType == 'mcq' ? _optCCtrl.text.trim() : null,
      optionD: _questionType == 'mcq' ? _optDCtrl.text.trim() : null,
      correctOption: _questionType == 'mcq' ? _correctOption : null,
      answerText: _questionType != 'mcq' ? _answerTextCtrl.text.trim() : null,
      marks: int.tryParse(_marksCtrl.text) ?? 1,
      questionType: _questionType,
    );

    final api = ApiService(context.read<AuthService>());
    try {
      if (_isEdit) {
        await api.updateQuestion(widget.existing!.id, q);
      } else {
        await api.createQuestion(q);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Question' : 'Add Question')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _subject,
                      decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Math', child: Text('Math')),
                        DropdownMenuItem(value: 'English', child: Text('English')),
                      ],
                      onChanged: (v) => setState(() => _subject = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _difficulty,
                      decoration: const InputDecoration(labelText: 'Difficulty', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                      ],
                      onChanged: (v) => setState(() => _difficulty = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _chapterCtrl,
                decoration: const InputDecoration(labelText: 'Chapter (e.g. Fractions)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _questionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Question text', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _questionType,
                decoration: const InputDecoration(labelText: 'Question type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'mcq', child: Text('Multiple choice (MCQ)')),
                  DropdownMenuItem(value: 'short_answer', child: Text('Short answer')),
                  DropdownMenuItem(value: 'long_answer', child: Text('Long answer')),
                ],
                onChanged: (v) => setState(() => _questionType = v!),
              ),
              const SizedBox(height: 14),
              if (_questionType == 'mcq') ...[
                TextFormField(
                  controller: _optACtrl,
                  decoration: const InputDecoration(labelText: 'Option A', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _optBCtrl,
                  decoration: const InputDecoration(labelText: 'Option B', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _optCCtrl,
                  decoration: const InputDecoration(labelText: 'Option C', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _optDCtrl,
                  decoration: const InputDecoration(labelText: 'Option D', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _correctOption,
                  decoration: const InputDecoration(labelText: 'Correct option', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'A', child: Text('A')),
                    DropdownMenuItem(value: 'B', child: Text('B')),
                    DropdownMenuItem(value: 'C', child: Text('C')),
                    DropdownMenuItem(value: 'D', child: Text('D')),
                  ],
                  onChanged: (v) => setState(() => _correctOption = v),
                ),
              ] else
                TextFormField(
                  controller: _answerTextCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Model answer', border: OutlineInputBorder()),
                ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _marksCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Marks', border: OutlineInputBorder()),
                validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a number' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: _saving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isEdit ? 'Save changes' : 'Create question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
