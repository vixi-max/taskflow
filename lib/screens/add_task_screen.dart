import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleFocus = FocusNode();

  String category = 'Personnel';
  String priority = 'Moyenne';
  bool _showTitleError = false;

  static const Color _primary = Color(0xFF7657E8);
  static const Color _primaryDark = Color(0xFF5B3FD1);

  // 📂 Catégories avec icônes
  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Travail', 'icon': Icons.work_outline_rounded},
    {'label': 'Études', 'icon': Icons.school_outlined},
    {'label': 'Personnel', 'icon': Icons.person_outline_rounded},
  ];

  // 🚩 Priorités avec couleurs
  static const List<Map<String, dynamic>> _priorities = [
    {'label': 'Basse', 'color': Color(0xFF43A047)},
    {'label': 'Moyenne', 'color': Color(0xFFFB8C00)},
    {'label': 'Haute', 'color': Color(0xFFE53935)},
  ];

  // 💾 Enregistrer une nouvelle tâche
  void saveTask() {
    if (titleController.text.trim().isEmpty) {
      setState(() => _showTitleError = true);
      titleFocus.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('Le titre est obligatoire')),
            ],
          ),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: category,
      priority: priority,
    );

    Navigator.pop(context, task);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: CustomScrollView(
        slivers: [
          // 🌈 AppBar personnalisée avec dégradé
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            elevation: 0,
            backgroundColor: _primary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 55, bottom: 16),
              title: const Text(
                'Nouvelle tâche',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primary, _primaryDark],
                  ),
                ),
                child: Stack(
                  children: [
                    // Cercles décoratifs
                    Positioned(
                      top: -30,
                      right: -30,
                      child: _circle(140, Colors.white.withValues(alpha: 0.08)),
                    ),
                    Positioned(
                      bottom: -50,
                      right: 60,
                      child: _circle(100, Colors.white.withValues(alpha: 0.06)),
                    ),
                    const Positioned(
                      left: 20,
                      bottom: 60,
                      child: Text(
                        'Ajoute une tâche à ta liste ✍️',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 📋 Formulaire
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ----- TITRE -----
                _Section(
                  icon: Icons.edit_outlined,
                  title: 'Titre de la tâche',
                  child: TextField(
                    controller: titleController,
                    focusNode: titleFocus,
                    onChanged: (_) {
                      if (_showTitleError) {
                        setState(() => _showTitleError = false);
                      }
                    },
                    decoration: _inputDecoration(
                      hint: 'Exemple : Réviser Flutter',
                      icon: Icons.title_rounded,
                      error: _showTitleError,
                      errorText: _showTitleError
                          ? 'Le titre est obligatoire'
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ----- DESCRIPTION -----
                _Section(
                  icon: Icons.description_outlined,
                  title: 'Description',
                  subtitle: 'Optionnel',
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      hint: 'Décris ta tâche...',
                      icon: Icons.notes_rounded,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ----- CATÉGORIE -----
                _Section(
                  icon: Icons.category_outlined,
                  title: 'Catégorie',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _categories.map((c) {
                      final selected = category == c['label'];
                      return _ChoiceChipCard(
                        icon: c['icon'] as IconData,
                        label: c['label'] as String,
                        selected: selected,
                        color: _primary,
                        onTap: () => setState(() => category = c['label']),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // ----- PRIORITÉ -----
                _Section(
                  icon: Icons.flag_outlined,
                  title: 'Priorité',
                  child: Row(
                    children: _priorities.map((p) {
                      final selected = priority == p['label'];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _PriorityCard(
                            label: p['label'] as String,
                            color: p['color'] as Color,
                            selected: selected,
                            onTap: () =>
                                setState(() => priority = p['label']),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 36),

                // ----- BOUTON -----
                _buildSaveButton(),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // 💾 Bouton enregistrer (gradient + ombre)
  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [_primary, _primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: saveTask,
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Enregistrer la tâche',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🎨 Décoration des champs de texte
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    bool error = false,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      errorText: errorText,
      filled: true,
      fillColor: const Color(0xFFF7F7FB),
      prefixIcon: Icon(
        icon,
        color: error ? const Color(0xFFE53935) : _primary,
        size: 20,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: error ? const Color(0xFFE53935) : const Color(0xFFE4E4EE),
          width: 1.4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.8),
      ),
    );
  }

  // ⚪ Cercle décoratif
  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ================== WIDGETS ANNEXES ==================

/// 📦 Section avec icône + titre
class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;

  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF7657E8)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF1F1F2E),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 6),
              Text(
                '($subtitle)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

/// 🎯 Chip de catégorie (sélection visuelle)
class _ChoiceChipCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceChipCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFFE4E4EE),
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: selected ? Colors.white : const Color(0xFF1F1F2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🚩 Carte de priorité (Basse / Moyenne / Haute)
class _PriorityCard extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityCard({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFFE4E4EE),
            width: 1.6,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: selected ? color : color.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? color : const Color(0xFF6B6B7B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}