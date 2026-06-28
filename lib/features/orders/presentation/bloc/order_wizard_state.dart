part of 'order_wizard_bloc.dart';

class OrderWizardState extends Equatable {
  final OrderFormData formData;
  
  const OrderWizardState({required this.formData});

  OrderWizardState copyWith({OrderFormData? formData}) {
    return OrderWizardState(
      formData: formData ?? this.formData,
    );
  }

  @override
  List<Object?> get props => [formData];
}
