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
  int _selectedTab = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTabButton(int index, String label, Color color, int count) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : ClubOsTheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? color : ClubOsTheme.onSurfaceVariant.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final tasks = dataProvider.tasks;
    final isAdmin = dataProvider.isAdmin;
    final bool isDesktop = MediaQuery.of(context).size.width > 750;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(ClubOsTheme.gutterLarge, 40, ClubOsTheme.gutterLarge, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WORKFLOW OPS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 4),
                ),
                Text('Task Board', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40)),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => dataProvider.updateSearchQuery(value),
                  style: TextStyle(color: ClubOsTheme.onSurfaceMain, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'FILTER OPERATIONS...',
                    hintStyle: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 10, letterSpacing: 1),
                    prefixIcon: Icon(Icons.search, color: ClubOsTheme.onSurfaceVariant, size: 18),
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
                : isDesktop
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildColumn(context, 'TO DO', 'todo', tasks.where((t) => t.status == 'todo').toList(), ClubOsTheme.tertiaryAnalytical, true),
                            const SizedBox(width: 24),
                            _buildColumn(context, 'ACTIVE', 'inprogress', tasks.where((t) => t.status == 'inprogress').toList(), ClubOsTheme.primaryCommand, true),
                            const SizedBox(width: 24),
                            _buildColumn(context, 'VERIFIED', 'done', tasks.where((t) => t.status == 'done').toList(), Colors.green.shade600, true),
                            SizedBox(width: ClubOsTheme.gutterLarge),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge, vertical: 8),
                            child: Row(
                              children: [
                                _buildTabButton(0, 'TO DO', ClubOsTheme.tertiaryAnalytical, tasks.where((t) => t.status == 'todo').length),
                                const SizedBox(width: 8),
                                _buildTabButton(1, 'ACTIVE', ClubOsTheme.primaryCommand, tasks.where((t) => t.status == 'inprogress').length),
                                const SizedBox(width: 8),
                                _buildTabButton(2, 'VERIFIED', Colors.green.shade600, tasks.where((t) => t.status == 'done').length),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge),
                              child: IndexedStack(
                                index: _selectedTab,
                                children: [
                                  _buildColumn(context, 'TO DO', 'todo', tasks.where((t) => t.status == 'todo').toList(), ClubOsTheme.tertiaryAnalytical, false),
                                  _buildColumn(context, 'ACTIVE', 'inprogress', tasks.where((t) => t.status == 'inprogress').toList(), ClubOsTheme.primaryCommand, false),
                                  _buildColumn(context, 'VERIFIED', 'done', tasks.where((t) => t.status == 'done').toList(), Colors.green.shade600, false),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildColumn(BuildContext context, String title, String status, List<Task> columnTasks, Color accentColor, bool isDesktop) {
    return DragTarget<Task>(
      onWillAccept: (data) => data?.status != status,
      onAccept: (task) {
        context.read<DataProvider>().updateTaskStatus(task.id, status);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: isDesktop ? 320 : MediaQuery.of(context).size.width - ClubOsTheme.gutterLarge * 2,
          margin: EdgeInsets.only(bottom: isDesktop ? 40 : 16),
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                  shrinkWrap: !isDesktop,
                  physics: isDesktop ? null : const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: columnTasks.length,
                  itemBuilder: (context, index) {
                    final task = columnTasks[index];
                    return Draggable<Task>(
                      data: task,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: isDesktop ? 290 : MediaQuery.of(context).size.width - ClubOsTheme.gutterLarge * 2 - 24,
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
              Text('ASSIGNEE', style: Theme.of(context).textTheme.labelSmall),
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
                      child: Text(m.name, style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain)),
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
                        Text('DUE DATE', style: Theme.of(context).textTheme.labelSmall),
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
                                Icon(Icons.calendar_today, size: 16, color: ClubOsTheme.onSurfaceMain),
                                const SizedBox(width: 8),
                                Text(
                                  '\${selectedDate.day}/\${selectedDate.month}/\${selectedDate.year}',
                                  style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain),
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
                        Text('LINK TO EVENT', style: Theme.of(context).textTheme.labelSmall),
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
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('None', style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain)),
                                ),
                                ...activeEvents.map((e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.title, style: TextStyle(fontSize: 14, color: ClubOsTheme.onSurfaceMain), overflow: TextOverflow.ellipsis),
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
          child: Text('DISCARD', style: TextStyle(color: ClubOsTheme.onSurfaceVariant)),
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
