import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String? title;
  final String? habitId;
  final String? description;
  final String? repetitionsPerDay;
  final String? executionFrequency;
  final Timestamp? createdAt;
  final int? color;
  final bool? isCompleted;
  HabitEntity({
    this.title,
    this.habitId,
    this.description,
    this.repetitionsPerDay,
    this.executionFrequency,
    this.createdAt,
    this.color,
    this.isCompleted = false,
  });
  HabitEntity copyWith({
    String? title,
    String? habitId,
    String? description,
    String? repetitionsPerDay,
    String? executionFrequency,
    Timestamp? createdAt,
    int? color,
    bool? isCompleted,
  }) {
    return HabitEntity(
      title: title ?? this.title,
      habitId: habitId ?? this.habitId,
      description: description ?? this.description,
      repetitionsPerDay: repetitionsPerDay ?? this.repetitionsPerDay,
      executionFrequency: executionFrequency ?? this.executionFrequency,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        title,
        habitId,
        description,
        repetitionsPerDay,
        executionFrequency,
        createdAt,
        color,
        isCompleted,
      ];
}
