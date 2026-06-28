import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tailoring_flutter/features/orders/presentation/orders_list_screen.dart';
import 'package:tailoring_flutter/features/orders/domain/entities/order_entity.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import '../../../test_helpers.dart';

class MockOrderWizardBloc extends Mock implements OrderWizardBloc {}

class FakeOrderBloc extends Fake implements OrderBloc {
  OrderState _state;
  FakeOrderBloc(this._state);

  @override
  OrderState get state => _state;

  @override
  Stream<OrderState> get stream => Stream.value(_state);

  @override
  void emit(OrderState state) {
    _state = state;
  }
  
  @override
  void add(OrderEvent event) {}

  @override
  Future<void> close() async {}
}

void main() {
  testWidgets('debug widget tree', (WidgetTester tester) async {
    final mockWizard = MockOrderWizardBloc();
    final fakeWalkthroughCubit = FakeWalkthroughCubit(WalkthroughInitial());
    final fakeOrder = FakeOrderBloc(OrdersLoaded([
      OrderEntity(
        id: '1',
        customerName: 'DEBUG_NAME',
        customerPhone: '123',
        garmentTypes: const ['Shirt'],
        measurements: const {},
        specialInstructions: '',
        assignedTailor: '',
        priorityIndex: 0,
        totalAmount: 100,
        advancePaid: 0,
        paymentMode: 0,
        status: 'Pending',
        createdAt: DateTime.now(),
        deliveryDate: DateTime.now().add(const Duration(days: 2)),
      )
    ]));

    if (getIt.isRegistered<OrderWizardBloc>()) {
      getIt.unregister<OrderWizardBloc>();
    }
    getIt.registerSingleton<OrderWizardBloc>(mockWizard);

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: ShowCaseWidget(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<OrderBloc>.value(value: fakeOrder),
            BlocProvider<WalkthroughCubit>.value(value: fakeWalkthroughCubit),
          ],
          child: const OrdersListScreen(),
        ),
      ),
    ));

    await tester.pumpAndSettle();
    
    debugPrint('WIDGET TREE:');
    debugDumpApp();
  });
}
