import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'paper_view_screen.dart';
import 'question_bank_screen.dart';
import 'role_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _subject = 'Math';
  String _difficulty = 'Easy';
  int _marks = 30;

  static const subjects = ['Math', 'English'];
  static const difficulties = ['Easy', 'Medium', 'Hard'];
  static const markOptions = [30, 50, 70];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final canManageQuestions = user?.role == 'teacher' || user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CA-1 Paper Bank'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text('Hi, ${user?.name ?? ''} 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text('Signed in as ${user?.role ?? ''}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),

              const Text('Subject', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _ChoiceRow(
                options: subjects,
                selected: _subject,
                onSelected: (v) => setState(() => _subject = v),
              ),
              const SizedBox(height: 20),

              const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _ChoiceRow(
                options: difficulties,
                selected: _difficulty,
                onSelected: (v) => setState(() => _difficulty = v),
              ),
              const SizedBox(height: 20),

              const Text('Max Marks', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _ChoiceRow(
                options: markOptions.map((m) => '$m').toList(),
                selected: '$_marks',
                onSelected: (v) => setState(() => _marks = int.parse(v)),
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                icon: const Icon(Icons.description),
                label: const Text('View Paper'),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PaperViewScreen(subject: _subject, difficulty: _difficulty, marks: _marks),
                  ));
                },
              ),

              if (canManageQuestions) ...[
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Manage Question Bank'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuestionBankScreen()));
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChoiceRow({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.map((o) {
        final isSelected = o == selected;
        return ChoiceChip(
          label: Text(o),
          selected: isSelected,
          onSelected: (_) => onSelected(o),
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
          selectedColor: Colors.indigo,
          backgroundColor: Colors.grey.shade200,
        );
      }).toList(),
    );
  }
}
