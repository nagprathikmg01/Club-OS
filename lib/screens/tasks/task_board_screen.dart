import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/task.dart';
import '../../models/app_user.dart';
import '../../providers/data_provider.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/neon_bottom_sheet.dart';
import '../../widgets/detail_sheet.dart';
import '../../theme.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final tasks = dataProvider.tasks;
    final isAdmin = dataProvider.isAdmin;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(ClubOsTheme.gutterLarge, 40, ClubOsTheme.gutterLarge, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WORKFLOW OPS',
                  style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(letterSpacing: 4),
                ),
                Text('Task Board', style: ClubOsTheme.lightTheme.textTheme.displayLarge?.copyWith(fontSize: 40)),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => dataProvider.updateSearchQuery(value),
                  style: const TextStyle(color: ClubOsTheme.onSurfaceMain, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'FILTER OPERATIONS...',
                    hintStyle: const TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 10, letterSpacing: 1),
                    prefixIcon: const Icon(Icons.search, color: ClubOsTheme.onSurfaceVariant, size: 18),
                    filled: true,
                    fillColor: ClubOsTheme.solarSurfaceLow.withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: tasks.isEmpty
                ? const NeonEmptyState(
                    title: 'NO TASKS MATCHED',
                    message: 'Check your spelling or create a new task.',
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumn(context, 'TO DO', 'todo', tasks.where((t) => t.status == 'todo').toList(), ClubOsTheme.tertiaryAnalytical),
                        const SizedBox(width: 24),
                        _buildColumn(context, 'ACTIVE', 'inprogress', tasks.where((t) => t.status == 'inprogress').toList(), ClubOsTheme.primaryCommand),
                        const SizedBox(width: 24),
                        _buildColumn(context, 'VERIFIED', 'done', tasks.where((t) => t.status == 'done').toList(), Colors.green.shade600),
                        const SizedBox(width: ClubOsTheme.gutterLarge),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddTaskBottomSheet(context),
              backgroundColor: ClubOsTheme.primaryCommand,
              icon: const Icon(Icons.add_task, color: Colors.white),
              label: const Text('NEW OPERATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            )
          : null,
    );
  }

  Widget _buildColumn(BuildContext context, String title, String status, List<Task> columnTasks, Color accentColor) {
    return DragTarget<Task>(
      onWillAccept: (data) => data?.status != status,
      onAccept: (task) {
        context.read<DataProvider>().updateTaskStatus(task.id, status);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 320,
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty ? accentColor.withOpacity(0.02) : ClubOsTheme.solarSurfaceLow.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(width: 4, height: 16, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: ClubOsTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        columnTasks.length.toString(),
                        style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: columnTasks.length,
                  itemBuilder: (context, index) {
                    final task = columnTasks[index];
                    return Draggable<Task>(
                      data: task,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 290,
                          child: TaskCard(task: task),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.2,
                        child: TaskCard(task: task),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _showDetail(context, task),
                          child: TaskCard(task: task),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailSheet(item: task),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final dataProvider = context.read<DataProvider>();
    final members = dataProvider.clubMembers;
    final activeEvents = dataProvider.activeEventsList;
    
    AppUser? selectedMember = members.isNotEmpty ? members.first : null;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
    String? selectedEventId;

    NeonBottomSheet.show(
      context: context,
      title: 'Assign Operation',
      content: StatefulBuilder(
        builder: (context, setModalState) {
          if (members.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No members found to assign task to.', style: TextStyle(color: Colors.red)),
            );
          }
          selectedMember ??= members.first;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'TASK NAME'),
              ),
              const SizedBox(height: 24),
              Text('ASSIGNEE', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ClubOsTheme.solarSurfaceLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AppUser>(
                    value: selectedMember,
                    isExpanded: true,
                    dropdownColor: ClubOsTheme.solarSurfaceLowest,
                    items: members.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.name, style: const TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain)),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedMember = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                   Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DUE DATE', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setModalState(() => selectedDate = date);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: ClubOsTheme.solarSurfaceLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: ClubOsTheme.onSurfaceMain),
                                const SizedBox(width: 8),
                                Text(
                                  '\${selectedDate.day}/\${selectedDate.month}/\${selectedDate.year}',
                                  style: const TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LINK TO EVENT', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: ClubOsTheme.solarSurfaceLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: selectedEventId,
                              isExpanded: true,
                              hint: const Text('Optional', style: TextStyle(fontSize: 14)),
                              dropdownColor: ClubOsTheme.solarSurfaceLowest,
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('None', style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain)),
                                ),
                                ...activeEvents.map((e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.title, style: const TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain), overflow: TextOverflow.ellipsis),
                                )),
                              ],
                              onChanged: (val) {
                                setModalState(() => selectedEventId = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'OBJECTIVES'),
              ),
            ],
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('DISCARD', style: TextStyle(color: ClubOsTheme.onSurfaceVariant)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && selectedMember != null) {
              final newTask = Task(
                id: const Uuid().v4(),
                title: titleController.text,
                description: descController.text,
                status: 'todo',
                assigneeId: selectedMember!.uid,
                assigneeName: selectedMember!.name,
                dueDate: selectedDate,
                clubId: context.read<DataProvider>().activeClubId,
                eventId: selectedEventId,
              );
              context.read<DataProvider>().addTask(newTask);
              Navigator.pop(context);
            }
          },
          child: const Text('INITIATE'),
        ),
      ],
    );
  }
}
