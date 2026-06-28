part of 'walkthrough_cubit.dart';

abstract class WalkthroughState extends Equatable {
  const WalkthroughState();

  @override
  List<Object> get props => [];
}

class WalkthroughInitial extends WalkthroughState {}

class WalkthroughStepCreateCustomer extends WalkthroughState {}

class WalkthroughStepCreateTemplate extends WalkthroughState {}

class WalkthroughStepCreateOrder extends WalkthroughState {}

class WalkthroughCompleted extends WalkthroughState {}
