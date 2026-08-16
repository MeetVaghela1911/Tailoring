import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ShopSetupState extends Equatable {
  final int currentPage;
  final double capacity;
  final List<int> workingDays;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final String language;
  final bool isLoadingLocation;

  const ShopSetupState({
    this.currentPage = 0,
    this.capacity = 12,
    this.workingDays = const [0, 1, 2, 3, 4, 5],
    this.openTime = const TimeOfDay(hour: 10, minute: 0),
    this.closeTime = const TimeOfDay(hour: 20, minute: 0),
    this.language = 'English',
    this.isLoadingLocation = false,
  });

  ShopSetupState copyWith({
    int? currentPage,
    double? capacity,
    List<int>? workingDays,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    String? language,
    bool? isLoadingLocation,
  }) {
    return ShopSetupState(
      currentPage: currentPage ?? this.currentPage,
      capacity: capacity ?? this.capacity,
      workingDays: workingDays ?? this.workingDays,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      language: language ?? this.language,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        capacity,
        workingDays,
        openTime,
        closeTime,
        language,
        isLoadingLocation,
      ];
}
