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
    (label: 'EVS', icon: Icons.eco_rounded, color: Color(0xFF2E7D32)),
    (label: 'Hindi', icon: Icons.translate_rounded, color: Color(0xFFEF6C00)),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF0FB), Color(0xFFFBF2EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _DashboardHeader(subject: _subject, difficulty: _difficulty, marks: _marks),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune_rounded, color: Colors.indigo, size: 24),
                            SizedBox(width: 8),
                            Text('Choose a paper', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 26),

                        const _SectionLabel('Subject'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 14,
                          runSpacing: 12,
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
                        const SizedBox(height: 26),

                        const _SectionLabel('Difficulty'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: difficulties.map((d) {
                            final isSelected = d == _difficulty;
                            final color = difficultyColors[d]!;
                            return _BigChip(
                              label: d,
                              selected: isSelected,
                              color: color,
                              onTap: () => setState(() => _difficulty = d),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 26),

                        const _SectionLabel('Max Marks'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: markOptions.map((m) {
                            final isSelected = m == _marks;
                            return _BigChip(
                              label: '$m Marks',
                              selected: isSelected,
                              color: Colors.indigo,
                              onTap: () => setState(() => _marks = m),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 34),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.arrow_forward_rounded, size: 22),
                            label: const Text('View Paper', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            style: FilledButton.styleFrom(
                              backgroundColor: subjectMeta.color,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
      padding: const EdgeInsets.fromLTRB(26, 32, 26, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded, color: Colors.white, size: 34),
              SizedBox(width: 12),
              Text(
                'CA-1 Paper Bank',
                style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Class 5 · CBSE / NCERT · Chapters 1–3',
            style: TextStyle(color: Colors.white70, fontSize: 14.5),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _StatChip(icon: Icons.category_rounded, label: '4 Subjects'),
              _StatChip(icon: Icons.speed_rounded, label: '3 Difficulty Levels'),
              _StatChip(icon: Icons.description_rounded, label: '36 Papers'),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
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
        fontWeight: FontWeight.w800,
        fontSize: 12.5,
        letterSpacing: 0.7,
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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 155,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : color.withValues(alpha: 0.25), width: 1.6),
          boxShadow: selected ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : color, size: 34),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : color,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _BigChip({required this.label, required this.selected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : color.withValues(alpha: 0.35), width: 1.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
