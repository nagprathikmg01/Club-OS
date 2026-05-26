import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../models/task.dart';
import '../providers/data_provider.dart';
import '../theme.dart';

class DetailSheet extends StatefulWidget {
  final dynamic item; // Can be Event or Task

  const DetailSheet({super.key, required this.item});

  @override
  State<DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<DetailSheet> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final bool isEvent = widget.item is Event;
    final String title = isEvent ? (widget.item as Event).title : (widget.item as Task).title;
    final String description = isEvent ? (widget.item as Event).description : (widget.item as Task).description;
    final DateTime itemDate = isEvent ? (widget.item as Event).date : (widget.item as Task).dueDate;
    _titleController = TextEditingController(text: title);
    _descController = TextEditingController(text: description);
    _selectedDate = itemDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final bool isEvent = widget.item is Event;
    final provider = context.read<DataProvider>();

    if (isEvent) {
      final oldEvent = widget.item as Event;
      provider.updateEvent(Event(
        id: oldEvent.id,
        title: _titleController.text,
        description: _descController.text,
        date: _selectedDate,
        imageUrl: oldEvent.imageUrl,
        clubId: oldEvent.clubId,
      ));
    } else {
      final oldTask = widget.item as Task;
      provider.updateTask(Task(
        id: oldTask.id,
        title: _titleController.text,
        description: _descController.text,
        assigneeId: oldTask.assigneeId,
        assigneeName: oldTask.assigneeName,
        status: oldTask.status,
        dueDate: _selectedDate,
        clubId: oldTask.clubId,
        eventId: oldTask.eventId,
      ));
    }

    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEvent = widget.item is Event;

    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32, // Keyboard padding
      ),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ClubOsTheme.primaryCommand.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isEvent ? 'EVENT' : 'TASK',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: ClubOsTheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isEditing) ...[
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ] else ...[
              Text(_titleController.text, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: ClubOsTheme.onSurfaceMain, fontSize: 32)),
            ],

            const SizedBox(height: 8),
            InkWell(
              onTap: _isEditing ? () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              } : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: _isEditing ? 8 : 0, horizontal: _isEditing ? 8 : 0),
                decoration: _isEditing ? BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ) : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ClubOsTheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(DateFormat('EEEE, MMM dd').format(_selectedDate).toUpperCase(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
                    if (_isEditing) Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.edit, size: 14, color: ClubOsTheme.primaryCommand),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            if (isEvent && !_isEditing) ...[
              Text('EVENT PROGRESS', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final provider = context.watch<DataProvider>();
                  final eventId = (widget.item as Event).id;
                  final rate = provider.getEventCompletionRate(eventId);
                  final taskCount = provider.getTasksForEvent(eventId).length;
                  
                  if (taskCount == 0) {
                    return Text('No operational tasks linked to this event.', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 13));
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\${(rate * 100).toInt()}% Completed', style: TextStyle(fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceMain)),
                          Text("\$taskCount Task\${taskCount > 1 ? 's' : ''}", style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: rate,
                          minHeight: 8,
                          backgroundColor: Colors.black.withOpacity(0.05),
                          color: ClubOsTheme.primaryCommand,
                        ),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 32),
            ],
            
            // Description
            Text('DETAILS', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 12),
            
            if (_isEditing) ...[
              TextField(
                controller: _descController,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ] else ...[
              Text(_descController.text, style: Theme.of(context).textTheme.bodyMedium),
            ],
            
            const SizedBox(height: 48),

            // Functional Controls
            Row(
              children: [
                if (!_isEditing)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        
                        if (isEvent) {
                          context.read<DataProvider>().deleteEvent((widget.item as Event).id);
                        } else {
                          context.read<DataProvider>().deleteTask((widget.item as Task).id);
                        }
                        
                        navigator.pop();
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Item archived.')),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('DELETE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (!_isEditing) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_isEditing) {
                        _saveChanges();
                      } else {
                        setState(() { _isEditing = true; });
                      }
                    },
                    icon: Icon(_isEditing ? Icons.save : Icons.edit_outlined, size: 20),
                    label: Text(_isEditing ? 'SAVE' : 'EDIT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
