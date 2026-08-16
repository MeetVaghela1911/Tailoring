import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shop_setup_state.dart';

class ShopSetupCubit extends Cubit<ShopSetupState> {
  ShopSetupCubit() : super(const ShopSetupState());

  void setPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void setCapacity(double capacity) {
    emit(state.copyWith(capacity: capacity));
  }

  void toggleWorkingDay(int dayIndex) {
    final updatedDays = List<int>.from(state.workingDays);
    if (updatedDays.contains(dayIndex)) {
      updatedDays.remove(dayIndex);
    } else {
      updatedDays.add(dayIndex);
    }
    emit(state.copyWith(workingDays: updatedDays));
  }

  void setOpenTime(TimeOfDay time) {
    emit(state.copyWith(openTime: time));
  }

  void setCloseTime(TimeOfDay time) {
    emit(state.copyWith(closeTime: time));
  }

  void setLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void setLoadingLocation(bool isLoading) {
    emit(state.copyWith(isLoadingLocation: isLoading));
  }
}
