import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/constants.dart';
import 'package:habit_tracker/date_time.dart';
import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:habit_tracker/features/presentation/widgets/form_container_widget.dart';

class UpdateHabitMainPage extends StatefulWidget {
  final HabitEntity habitEntity;
  final String selectedDay;

  const UpdateHabitMainPage(
      {super.key, required this.habitEntity, required this.selectedDay});

  @override
  State<UpdateHabitMainPage> createState() => _UpdateHabitMainPageState();
}

class _UpdateHabitMainPageState extends State<UpdateHabitMainPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController executionFrequencyController;
  bool isTitleEmpty = false;
  int pickedColor = 0;
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    executionFrequencyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.habitEntity.title);
    descriptionController =
        TextEditingController(text: widget.habitEntity.description);
    executionFrequencyController =
        TextEditingController(text: widget.habitEntity.executionFrequency);

    titleController.addListener(_onTextChanged);
    super.initState();
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
        title: const Text("Update Habit"),
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
                    BlocProvider.of<HabitsBloc>(context).add(UpdateHabitEvent(
                        habitId: widget.habitEntity.habitId!,
                        isChangedOnlyCheckBool: false,
                        day: widget.selectedDay,
                        habitEntity: HabitEntity(
                          habitId: widget.habitEntity.habitId,
                          title: titleController.text,
                          description: descriptionController.text,
                          isCompleted: widget.habitEntity.isCompleted,
                          executionFrequency:
                              executionFrequencyController.text.toString(),
                          color: pickedColor,
                        )));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.update),
                  label: const Text("Update Habit")),
            ),
    );
  }
}
