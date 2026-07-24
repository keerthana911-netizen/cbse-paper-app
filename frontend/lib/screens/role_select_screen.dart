import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 72, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text(
                'CBSE Class 5 Paper Bank',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Who are you signing in as?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _RoleCard(
                icon: Icons.backpack,
                label: 'Student',
                subtitle: 'View and download CA-1 papers',
                role: 'student',
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.menu_book,
                label: 'Teacher',
                subtitle: 'View papers, manage the question bank',
                role: 'teacher',
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.admin_panel_settings,
                label: 'Admin',
                subtitle: 'Full access',
                role: 'admin',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String role;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 32, color: Colors.indigo),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.read<AuthService>().setSelectedRole(role);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
      ),
    );
  }
}
