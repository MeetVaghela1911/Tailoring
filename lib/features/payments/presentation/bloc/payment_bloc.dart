import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc({required this.repository}) : super(PaymentInitial()) {
    on<LoadOrderPayments>(_onLoadOrderPayments);
    on<LoadCustomerKhata>(_onLoadCustomerKhata);
    on<LoadDailyCashbook>(_onLoadDailyCashbook);
    on<LoadFilteredFinance>(_onLoadFilteredFinance);
    on<AddPaymentTransactionEvent>(_onAddPaymentTransaction);
  }

  Future<void> _onLoadOrderPayments(
    LoadOrderPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await repository.getPaymentsForOrder(event.orderId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payments) => emit(OrderPaymentsLoaded(orderId: event.orderId, payments: payments)),
    );
  }

  Future<void> _onLoadCustomerKhata(
    LoadCustomerKhata event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await repository.getCustomerKhataSummary(event.customerId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (summary) => emit(CustomerKhataLoaded(summary)),
    );
  }

  Future<void> _onLoadDailyCashbook(
    LoadDailyCashbook event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await repository.getDailyCashbookSummary();
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (summary) => emit(DailyCashbookLoaded(summary)),
    );
  }

  Future<void> _onLoadFilteredFinance(
    LoadFilteredFinance event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await repository.getFilteredFinanceSummary(
      startDate: event.startDate,
      endDate: event.endDate,
      filterName: event.filterName,
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (summary) => emit(FilteredFinanceLoaded(summary)),
    );
  }

  Future<void> _onAddPaymentTransaction(
    AddPaymentTransactionEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await repository.addPayment(
      orderId: event.orderId,
      customerId: event.customerId,
      customerName: event.customerName,
      customerPhone: event.customerPhone,
      amount: event.amount,
      paymentMode: event.paymentMode,
      paymentModeName: event.paymentModeName,
      paymentStage: event.paymentStage,
      notes: event.notes,
      referenceNumber: event.referenceNumber,
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (transaction) => emit(PaymentAddedSuccess(transaction)),
    );
  }
}
