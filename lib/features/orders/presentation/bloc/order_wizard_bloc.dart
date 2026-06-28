import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/order_form_data.dart';

part 'order_wizard_event.dart';
part 'order_wizard_state.dart';

class OrderWizardBloc extends Bloc<OrderWizardEvent, OrderWizardState> {
  OrderWizardBloc() : super(const OrderWizardState(formData: OrderFormData())) {
    on<StartOrderWizard>(_onStartOrderWizard);
    on<UpdateOrderData>(_onUpdateOrderData);
    on<CalculateTotals>(_onCalculateTotals);
  }

  void _onStartOrderWizard(StartOrderWizard event, Emitter<OrderWizardState> emit) {
    if (event.initialData != null) {
      emit(state.copyWith(formData: event.initialData));
    } else {
      emit(const OrderWizardState(formData: OrderFormData()));
    }
  }

  void _onUpdateOrderData(UpdateOrderData event, Emitter<OrderWizardState> emit) {
    emit(state.copyWith(formData: event.formData));
  }

  void _onCalculateTotals(CalculateTotals event, Emitter<OrderWizardState> emit) {
    double newTotal = 0.0;
    state.formData.garmentPrices.forEach((key, price) {
      final quantity = state.formData.garmentQuantities[key] ?? 1;
      newTotal += (price * quantity);
    });
    newTotal += state.formData.externalCharges;

    final updatedData = state.formData.copyWith(totalAmount: newTotal);
    emit(state.copyWith(formData: updatedData));
  }
}
