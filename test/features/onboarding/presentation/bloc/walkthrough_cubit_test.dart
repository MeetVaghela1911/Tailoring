import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';

void main() {
  group('WalkthroughCubit', () {
    late WalkthroughCubit walkthroughCubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      walkthroughCubit = WalkthroughCubit();
    });

    tearDown(() {
      walkthroughCubit.close();
    });

    test('initial state is WalkthroughInitial', () {
      expect(walkthroughCubit.state, isA<WalkthroughInitial>());
    });

    blocTest<WalkthroughCubit, WalkthroughState>(
      'emits WalkthroughStepCreateCustomer if there are no customers',
      build: () => walkthroughCubit,
      act: (cubit) => cubit.checkWalkthroughState(
        customersCount: 0,
        templatesCount: 0,
        ordersCount: 0,
      ),
      expect: () => [
        isA<WalkthroughStepCreateCustomer>(),
      ],
    );

    blocTest<WalkthroughCubit, WalkthroughState>(
      'emits WalkthroughStepCreateTemplate if there is a customer but no templates',
      build: () => walkthroughCubit,
      act: (cubit) => cubit.checkWalkthroughState(
        customersCount: 1,
        templatesCount: 0,
        ordersCount: 0,
      ),
      expect: () => [
        isA<WalkthroughStepCreateTemplate>(),
      ],
    );

    blocTest<WalkthroughCubit, WalkthroughState>(
      'emits WalkthroughStepCreateOrder if there are customers and templates but no orders',
      build: () => walkthroughCubit,
      act: (cubit) => cubit.checkWalkthroughState(
        customersCount: 1,
        templatesCount: 1,
        ordersCount: 0,
      ),
      expect: () => [
        isA<WalkthroughStepCreateOrder>(),
      ],
    );

    blocTest<WalkthroughCubit, WalkthroughState>(
      'emits WalkthroughCompleted if there are customers, templates, and orders',
      build: () => walkthroughCubit,
      act: (cubit) => cubit.checkWalkthroughState(
        customersCount: 1,
        templatesCount: 1,
        ordersCount: 1,
      ),
      expect: () => [
        isA<WalkthroughCompleted>(),
      ],
    );

    test('markCustomerCompleted sets preference and triggers step template', () async {
      await walkthroughCubit.markCustomerCompleted();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('walkthrough_customer_done'), isTrue);
      // It calls checkWalkthroughState internally
      expect(walkthroughCubit.state, isA<WalkthroughStepCreateTemplate>());
    });

    test('restartWalkthrough clears all preferences and goes to create customer', () async {
      SharedPreferences.setMockInitialValues({
        'walkthrough_customer_done': true,
        'walkthrough_template_done': true,
        'walkthrough_order_done': true,
      });
      await walkthroughCubit.restartWalkthrough();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('walkthrough_customer_done'), isFalse);
      expect(prefs.getBool('walkthrough_template_done'), isFalse);
      expect(prefs.getBool('walkthrough_order_done'), isFalse);
      expect(walkthroughCubit.state, isA<WalkthroughStepCreateCustomer>());
    });

    test('mark shown flags correctly update variables and preferences', () async {
      await walkthroughCubit.markCustomerShown();
      expect(walkthroughCubit.isCustomerShown, isTrue);

      await walkthroughCubit.markTemplateTabShown();
      expect(walkthroughCubit.isTemplateTabShown, isTrue);

      await walkthroughCubit.markTemplateScreenShown();
      expect(walkthroughCubit.isTemplateScreenShown, isTrue);

      await walkthroughCubit.markOrderTabShown();
      expect(walkthroughCubit.isOrderTabShown, isTrue);

      await walkthroughCubit.markOrderScreenShown();
      expect(walkthroughCubit.isOrderScreenShown, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('walkthrough_shown_customer'), isTrue);
      expect(prefs.getBool('walkthrough_shown_template_tab'), isTrue);
      expect(prefs.getBool('walkthrough_shown_template_screen'), isTrue);
      expect(prefs.getBool('walkthrough_shown_order_tab'), isTrue);
      expect(prefs.getBool('walkthrough_shown_order_screen'), isTrue);
    });
  });
}
