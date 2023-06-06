import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/constants.dart';
import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:habit_tracker/features/presentation/widgets/form_container_widget.dart';

class CreateHabitMainHabitPage extends StatefulWidget {
  const CreateHabitMainHabitPage({super.key});

  @override
  State<CreateHabitMainHabitPage> createState() =>
      _CreateHabitMainHabitPageState();
}

class _CreateHabitMainHabitPageState extends State<CreateHabitMainHabitPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController executionFrequencyController =
      TextEditingController();
  bool isTitleEmpty = true;
  int pickedColor = 0;
  @override
  void initState() {
    titleController.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    executionFrequencyController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      isTitleEmpty = titleController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Habit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormContainerWidget(
              hintText: "Title",
              controller: titleController,
            ),
            sizeVer(15),
            FormContainerWidget(
              hintText: "Description",
              controller: descriptionController,
            ),
            sizeVer(15),
            FormContainerWidget(
              hintText: "Execution Frequency per week",
              inputType: TextInputType.number,
              controller: executionFrequencyController,
            ),
            sizeVer(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                ),
                sizeHor(10),
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
                sizeHor(10),
                const CircleAvatar(
                  backgroundColor: Colors.purple,
                ),
              ],
            ),
            sizeVer(15),
          ],
        ),
      ),
      bottomNavigationBar: isTitleEmpty
          ? const SizedBox(
              height: 0,
              width: 0,
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                  onPressed: () {
                    BlocProvider.of<HabitsBloc>(context).add(CreateHabitEvent(
                        habitEntity: HabitEntity(
                      title: titleController.text,
                      description: descriptionController.text,
                      executionFrequency:
                          executionFrequencyController.text.toString(),
                      color: pickedColor,
                    )));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add to Habits")),
            ),
    );
  }
}
