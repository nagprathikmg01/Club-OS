import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color accentColor = _getStatusColor(task.status);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: accentColor.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ClubOsTheme.onSurfaceMain,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _getStatusIcon(task.status),
                size: 14,
                color: accentColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: ClubOsTheme.primaryCommand.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        task.assigneeName[0].toUpperCase(),
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    task.assigneeName.toUpperCase(),
                    style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ],
              ),
              Text(
                DateFormat('MMM dd').format(task.dueDate).toUpperCase(),
                style: TextStyle(color: accentColor.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'todo':
        return ClubOsTheme.tertiaryAnalytical;
      case 'inprogress':
        return ClubOsTheme.primaryCommand;
      case 'done':
        return Colors.green.shade600;
      default:
        return ClubOsTheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'todo':
        return Icons.radio_button_off;
      case 'inprogress':
        return Icons.radio_button_checked;
      case 'done':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}
