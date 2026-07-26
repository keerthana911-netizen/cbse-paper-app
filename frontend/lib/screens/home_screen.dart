import 'package:flutter/material.dart';
import 'paper_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _subject = 'Math';
  String _difficulty = 'Easy';
  int _marks = 30;

  static const subjects = [
    (label: 'Math', icon: Icons.calculate_rounded, color: Color(0xFF1F3D7A)),
    (label: 'English', icon: Icons.menu_book_rounded, color: Color(0xFF7A1F1F)),
  ];
  static const difficulties = ['Easy', 'Medium', 'Hard'];
  static const difficultyColors = {
    'Easy': Color(0xFF2E7D32),
    'Medium': Color(0xFFEF6C00),
    'Hard': Color(0xFFC62828),
  };
  static const markOptions = [30, 50, 70];

  @override
  Widget build(BuildContext context) {
    final subjectMeta = subjects.firstWhere((s) => s.label == _subject);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _DashboardHeader(subject: _subject, difficulty: _difficulty, marks: _marks),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune_rounded, color: Colors.indigo, size: 22),
                          SizedBox(width: 8),
                          Text('Choose a paper', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 22),

                      const _SectionLabel('Subject'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        children: subjects.map((s) {
                          final isSelected = s.label == _subject;
                          return _SubjectCard(
                            label: s.label,
                            icon: s.icon,
                            color: s.color,
                            selected: isSelected,
                            onTap: () => setState(() => _subject = s.label),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),

                      const _SectionLabel('Difficulty'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: difficulties.map((d) {
                          final isSelected = d == _difficulty;
                          final color = difficultyColors[d]!;
                          return ChoiceChip(
                            label: Text(d),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _difficulty = d),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.w700,
                            ),
                            selectedColor: color,
                            backgroundColor: color.withValues(alpha: 0.08),
                            side: BorderSide(color: color.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),

                      const _SectionLabel('Max Marks'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: markOptions.map((m) {
                          final isSelected = m == _marks;
                          return ChoiceChip(
                            label: Text('$m Marks'),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _marks = m),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            selectedColor: Colors.indigo,
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('View Paper', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600)),
                          style: FilledButton.styleFrom(
                            backgroundColor: subjectMeta.color,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  PaperViewScreen(subject: _subject, difficulty: _difficulty, marks: _marks),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String subject;
  final String difficulty;
  final int marks;

  const _DashboardHeader({required this.subject, required this.difficulty, required this.marks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                'CA-1 Paper Bank',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Class 5 · CBSE / NCERT · Chapters 1–3',
            style: TextStyle(color: Colors.white70, fontSize: 13.5),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _StatChip(icon: Icons.category_rounded, label: '2 Subjects'),
              _StatChip(icon: Icons.speed_rounded, label: '3 Difficulty Levels'),
              _StatChip(icon: Icons.description_rounded, label: '18 Papers'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 11.5,
        letterSpacing: 0.6,
        color: Colors.black54,
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : color.withValues(alpha: 0.25), width: 1.4),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : color,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
