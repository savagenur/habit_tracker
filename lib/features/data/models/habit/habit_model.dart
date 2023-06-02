import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../domain/entities/habit/habit_entity.dart';

class HabitModel extends HabitEntity {
  final String? title;
  final String? habitId;
  final String? description;
  final String? repetitionsPerDay;
  final String? executionFrequency;
  final Timestamp? createdAt;
  final int? color;
  final bool? isCompleted;
  HabitModel({
    this.title,
    this.habitId,
    this.description,
    this.repetitionsPerDay,
    this.executionFrequency,
    this.createdAt,
    this.color,
    this.isCompleted,
  }) : super(
          title: title,
          habitId: habitId,
          description: description,
          repetitionsPerDay: repetitionsPerDay,
          executionFrequency: executionFrequency,
          createdAt: createdAt,
          color: color,
          isCompleted: isCompleted,
        );

  factory HabitModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return HabitModel(
      title: snapshot["title"],
      habitId: snapshot["habitId"],
      description: snapshot["description"],
      repetitionsPerDay: snapshot["repetitionsPerDay"],
      executionFrequency: snapshot["executionFrequency"],
      createdAt: snapshot["createdAt"],
      color: snapshot["color"],
      isCompleted: snapshot["isCompleted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "habitId": habitId,
      "description": description,
      "repetitionsPerDay": repetitionsPerDay,
      "executionFrequency": executionFrequency,
      "createdAt": createdAt,
      "color": color,
      "isCompleted": isCompleted,
    };
  }
}
