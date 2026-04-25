import 'package:flutter/material.dart';
import 'dart:ui';

// ── Color Palette ───────────────────────────────────────────
const kBlack      = Color(0xFF000000);
const kNavy       = Color(0xFF14213D);
const kAmber      = Color(0xFFFCA311);
const kLight      = Color(0xFFE5E5E5);
const kWhite      = Color(0xFFFFFFFF);
const kNeonCyan   = Color(0xFF00F5FF);
const kNeonPurple = Color(0xFFB400FF);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const TaskPage(),
    );
  }
}

// ── Task Model ──────────────────────────────────────────────
class Task {
  String title;
  String description;
  bool done;
  Task({required this.title, this.description = '', this.done = false});
}

// ── Main Page ───────────────────────────────────────────────
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // ── Starts empty ──
  List<Task> tasks = [];

  final titleController = TextEditingController();
  final descController  = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void addTask() {
    if (titleController.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(Task(
          title: titleController.text.trim(),
          description: descController.text.trim(),
        ));
        titleController.clear();
        descController.clear();
      });
    }
  }

  void deleteTask(int index) => setState(() => tasks.removeAt(index));
  void toggleTask(int index)  => setState(() => tasks[index].done = !tasks[index].done);

  // ── Responsive column count ──
  int _columns(double width) {
    if (width > 1200) return 5;
    if (width > 900)  return 4;
    if (width > 600)  return 3;
    return 2;
  }

  // ── Pop-up expanded card overlay ──
  void _openCard(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "close",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim1, _, __) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return Stack(
          children: [
            // ── Blurred dark backdrop ──
            AnimatedBuilder(
              animation: anim1,
              builder: (_, __) => BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 14 * anim1.value,
                  sigmaY: 14 * anim1.value,
                ),
                child: Container(
                  color: kBlack.withOpacity(0.65 * anim1.value),
                ),
              ),
            ),
            // ── Expanded card in center ──
            Center(
              child: ScaleTransition(
                scale: curved,
                child: FadeTransition(
                  opacity: anim1,
                  child: _ExpandedCard(
                    task: tasks[index],
                    onToggle: () {
                      setState(() => tasks[index].done = !tasks[index].done);
                      Navigator.pop(ctx);
                    },
                    onDelete: () {
                      deleteTask(index);
                      Navigator.pop(ctx);
                    },
                    onClose: () => Navigator.pop(ctx),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Add Task Bottom Sheet ──
  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.add_task, color: kAmber, size: 24),
              const SizedBox(width: 10),
              const Text("New Task",
                  style: TextStyle(color: kAmber, fontSize: 22, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 20),
            _field(titleController, "Task title", Icons.title),
            const SizedBox(height: 12),
            _field(descController, "Description (optional)", Icons.notes, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline, color: kBlack),
                label: const Text("Add Task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kBlack)),
                onPressed: () { addTask(); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAmber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: c,
      style: const TextStyle(color: kWhite),
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: kAmber, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: kLight.withOpacity(0.35)),
        filled: true,
        fillColor: kBlack.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount  = tasks.where((t) => t.done).length;
    final screenW    = MediaQuery.of(context).size.width;
    final cols       = _columns(screenW);

    return Scaffold(
      body: Container(
        // ── Neon gradient background ──
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.8),
            radius: 1.4,
            colors: [
              Color(0xFFDFF8FB), // neon cyan tint
              Color(0xFFF0E6FF), // neon purple tint
              Color(0xFFE5E5E5), // base kLight
            ],
          ),
        ),
        child: Column(
          children: [

            // ── Top Header ──
            Container(
              decoration: BoxDecoration(
                color: kNavy,
                boxShadow: [
                  BoxShadow(
                    color: kNeonCyan.withOpacity(0.18),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo
                          Row(children: [
                            const Icon(Icons.bolt, color: kAmber, size: 28),
                            const SizedBox(width: 6),
                            const Text("Traksyra",
                                style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 24)),
                          ]),
                          // Counter badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: kAmber.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kAmber.withOpacity(0.35)),
                            ),
                            child: Text("$doneCount / ${tasks.length}",
                                style: const TextStyle(
                                    color: kAmber, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: tasks.isEmpty ? 0 : doneCount / tasks.length,
                          backgroundColor: kBlack.withOpacity(0.3),
                          color: kAmber,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text("$doneCount of ${tasks.length} completed",
                          style: TextStyle(color: kLight.withOpacity(0.45), fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ),

            // ── Grid / Empty State ──
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: kNeonCyan.withOpacity(0.25),
                                    blurRadius: 40,
                                    spreadRadius: 8),
                              ],
                            ),
                            child: Icon(Icons.inbox_outlined, size: 72,
                                color: kNavy.withOpacity(0.25)),
                          ),
                          const SizedBox(height: 18),
                          Text("No tasks yet!",
                              style: TextStyle(
                                  color: kNavy.withOpacity(0.55),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("Tap  + Add Task  to get started",
                              style: TextStyle(color: kNavy.withOpacity(0.35), fontSize: 13)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: screenW > 600 ? 0.92 : 0.82,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => _TaskCard(
                        task: tasks[index],
                        onTap:    () => _openCard(context, index),
                        onDelete: () => deleteTask(index),
                      ),
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        backgroundColor: kAmber,
        foregroundColor: kBlack,
        icon: const Icon(Icons.add),
        label: const Text("Add Task", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ── Grid Card ───────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TaskCard({required this.task, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: task.done ? kAmber : kNavy,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: task.done
                  ? kAmber.withOpacity(0.45)
                  : kNeonCyan.withOpacity(0.12),
              blurRadius: task.done ? 18 : 10,
              spreadRadius: task.done ? 2 : 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: kBlack.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    task.done ? Icons.task_alt : Icons.pending_actions,
                    color: task.done ? kNavy : kAmber,
                    size: 18,
                  ),
                ),
                // ── Delete: contained InkWell, no overflow ──
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.close,
                        color: kWhite.withOpacity(0.45), size: 16),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              task.title,
              style: TextStyle(
                color: kWhite,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                decoration: task.done ? TextDecoration.lineThrough : null,
                decorationColor: kWhite,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.touch_app, color: kWhite.withOpacity(0.28), size: 10),
              const SizedBox(width: 3),
              Text("tap to expand",
                  style: TextStyle(color: kWhite.withOpacity(0.28), fontSize: 9)),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Expanded Card Overlay ───────────────────────────────────
class _ExpandedCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const _ExpandedCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenW  = MediaQuery.of(context).size.width;
    final cardW    = screenW > 600 ? 440.0 : screenW * 0.88;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: cardW,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: kBlack,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: kAmber.withOpacity(0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: kAmber.withOpacity(0.22),
                blurRadius: 45,
                spreadRadius: 6),
            BoxShadow(
                color: kNeonCyan.withOpacity(0.1),
                blurRadius: 70,
                spreadRadius: 12),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.bolt, color: kAmber, size: 18),
                  const SizedBox(width: 6),
                  const Text("TASK DETAILS",
                      style: TextStyle(
                          color: kAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.5)),
                ]),
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: kLight, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Status badge ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: task.done ? Colors.green.shade900 : kNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: task.done ? Colors.greenAccent : kAmber.withOpacity(0.3),
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  task.done ? Icons.check_circle : Icons.pending,
                  color: task.done ? Colors.greenAccent : kAmber,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  task.done ? "Completed" : "In Progress",
                  style: TextStyle(
                    color: task.done ? Colors.greenAccent : kAmber,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Title ──
            Text(
              task.title,
              style: TextStyle(
                color: kWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: task.done ? TextDecoration.lineThrough : null,
                decorationColor: kLight.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 14),

            // ── Description box ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kNavy.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kWhite.withOpacity(0.05)),
              ),
              child: Text(
                task.description.isEmpty
                    ? "No description provided."
                    : task.description,
                style: TextStyle(
                    color: kLight.withOpacity(0.8), fontSize: 14, height: 1.6),
              ),
            ),
            const SizedBox(height: 24),

            // ── Action buttons ──
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(
                      task.done ? Icons.undo : Icons.check_circle_outline,
                      size: 16),
                  label: Text(task.done ? "Undo" : "Mark Done",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: onToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        task.done ? Colors.green.shade900 : kAmber,
                    foregroundColor:
                        task.done ? Colors.greenAccent : kBlack,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text("Delete",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: Colors.redAccent.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 18),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}