import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  // 🎨 Couleur selon la priorité
  Color get _priorityColor {
    switch (task.priority) {
      case 'Haute':
        return const Color(0xFFE53935); // rouge
      case 'Basse':
        return const Color(0xFF43A047); // vert
      default:
        return const Color(0xFFFB8C00); // orange
    }
  }

  // 🏷️ Icône selon la catégorie
  IconData get _categoryIcon {
    switch (task.category) {
      case 'Travail':
        return Icons.work_outline_rounded;
      case 'Études':
        return Icons.school_outlined;
      default:
        return Icons.person_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF5F5F8) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDone
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF7657E8).withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
        border: Border.all(
          color: isDone ? Colors.transparent : const Color(0xFFEDEDF2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🎨 Barre d'accent colorée (priorité)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDone
                            ? [Colors.grey.shade300, Colors.grey.shade300]
                            : [
                                _priorityColor,
                                _priorityColor.withValues(alpha: 0.45),
                              ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Checkbox custom + Titre + Delete
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: onToggle,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isDone
                                        ? const Color(0xFF7657E8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDone
                                          ? const Color(0xFF7657E8)
                                          : const Color(0xFFBDBDD1),
                                      width: 2,
                                    ),
                                  ),
                                  child: isDone
                                      ? const Icon(
                                          Icons.check,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  task.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDone
                                        ? Colors.grey.shade500
                                        : const Color(0xFF1F1F2E),
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.grey.shade500,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              _buildDeleteButton(),
                            ],
                          ),

                          // 📝 Description (si présente)
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 36),
                              child: Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: isDone
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],

                          // 🏷️ Badges catégorie + priorité
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 36),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildChip(
                                  icon: _categoryIcon,
                                  label: task.category,
                                  color: const Color(0xFF7657E8),
                                  filled: false,
                                ),
                                _buildChip(
                                  icon: Icons.flag_rounded,
                                  label: task.priority,
                                  color: _priorityColor,
                                  filled: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🗑️ Bouton supprimer
  Widget _buildDeleteButton() {
    return InkWell(
      onTap: onDelete,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 20,
          color: Colors.red.shade300,
        ),
      ),
    );
  }

  // 🏷️ Chip / badge
  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
    required bool filled,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}