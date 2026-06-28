part of 'order_wizard_bloc.dart';

sealed class OrderWizardEvent extends Equatable {
  const OrderWizardEvent();
  
  @override
  List<Object?> get props => [];
}

class StartOrderWizard extends OrderWizardEvent {
  final OrderFormData? initialData;
  const StartOrderWizard({this.initialData});
  
  @override
  List<Object?> get props => [initialData];
}

class UpdateOrderData extends OrderWizardEvent {
  final OrderFormData formData;
  const UpdateOrderData(this.formData);

  @override
  List<Object?> get props => [formData];
}

class CalculateTotals extends OrderWizardEvent {}
