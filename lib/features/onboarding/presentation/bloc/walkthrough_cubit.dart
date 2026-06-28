import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'walkthrough_state.dart';

class WalkthroughCubit extends Cubit<WalkthroughState> {
  static const String _keyCustomerDone = 'walkthrough_customer_done';
  static const String _keyTemplateDone = 'walkthrough_template_done';
  static const String _keyOrderDone = 'walkthrough_order_done';

  bool isCustomerShown = false;
  bool isTemplateTabShown = false;
  bool isTemplateScreenShown = false;
  bool isOrderTabShown = false;
  bool isOrderScreenShown = false;

  WalkthroughCubit() : super(WalkthroughInitial());

  Future<void> checkWalkthroughState({
    required int customersCount,
    required int templatesCount,
    required int ordersCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Check permanently completed flags
    bool customerDone = prefs.getBool(_keyCustomerDone) ?? false;
    bool templateDone = prefs.getBool(_keyTemplateDone) ?? false;
    bool orderDone = prefs.getBool(_keyOrderDone) ?? false;

    // Load shown flags
    isCustomerShown = prefs.getBool('walkthrough_shown_customer') ?? false;
    isTemplateTabShown = prefs.getBool('walkthrough_shown_template_tab') ?? false;
    isTemplateScreenShown = prefs.getBool('walkthrough_shown_template_screen') ?? false;
    isOrderTabShown = prefs.getBool('walkthrough_shown_order_tab') ?? false;
    isOrderScreenShown = prefs.getBool('walkthrough_shown_order_screen') ?? false;

    // Update based on actual DB count if a user bypassed without completing walkthrough naturally
    if (!customerDone && customersCount > 0) {
      customerDone = true;
      await prefs.setBool(_keyCustomerDone, true);
    }
    if (!templateDone && templatesCount > 0) {
      templateDone = true;
      await prefs.setBool(_keyTemplateDone, true);
    }
    if (!orderDone && ordersCount > 0) {
      orderDone = true;
      await prefs.setBool(_keyOrderDone, true);
    }

    if (orderDone) {
      emit(WalkthroughCompleted());
      return;
    }

    if (state is WalkthroughInitial) {
      final bool autoStarted = prefs.getBool('walkthrough_auto_started') ?? false;
      if (autoStarted) {
        emit(WalkthroughCompleted());
        return;
      }
      await prefs.setBool('walkthrough_auto_started', true);
    }

    if (!customerDone) {
      emit(WalkthroughStepCreateCustomer());
      return;
    }

    if (!templateDone) {
      emit(WalkthroughStepCreateTemplate());
      return;
    }

    emit(WalkthroughStepCreateOrder());
  }

  Future<void> markCustomerCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCustomerDone, true);
    await checkWalkthroughState(customersCount: 1, templatesCount: 0, ordersCount: 0);
  }

  Future<void> markCustomerShown() async {
    if (isCustomerShown) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_shown_customer', true);
    isCustomerShown = true;
  }

  Future<void> markTemplateTabShown() async {
    if (isTemplateTabShown) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_shown_template_tab', true);
    isTemplateTabShown = true;
  }

  Future<void> markTemplateScreenShown() async {
    if (isTemplateScreenShown) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_shown_template_screen', true);
    isTemplateScreenShown = true;
  }

  Future<void> markOrderTabShown() async {
    if (isOrderTabShown) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_shown_order_tab', true);
    isOrderTabShown = true;
  }

  Future<void> markOrderScreenShown() async {
    if (isOrderScreenShown) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_shown_order_screen', true);
    isOrderScreenShown = true;
    
    // Once the order screen guide is shown, the entire walkthrough has been fully displayed.
    // Even if the user hasn't added a single order yet, the guide should be marked as completed permanently
    // so it doesn't appear a second time.
    await prefs.setBool(_keyOrderDone, true);
    emit(WalkthroughCompleted());
  }

  Future<void> restartWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCustomerDone, false);
    await prefs.setBool(_keyTemplateDone, false);
    await prefs.setBool(_keyOrderDone, false);
    await prefs.remove('walkthrough_whatsapp_done');
    await prefs.setBool('walkthrough_auto_started', false);

    await prefs.setBool('walkthrough_shown_customer', false);
    await prefs.setBool('walkthrough_shown_template_tab', false);
    await prefs.setBool('walkthrough_shown_template_screen', false);
    await prefs.setBool('walkthrough_shown_order_tab', false);
    await prefs.setBool('walkthrough_shown_order_screen', false);

    isCustomerShown = false;
    isTemplateTabShown = false;
    isTemplateScreenShown = false;
    isOrderTabShown = false;
    isOrderScreenShown = false;

    emit(WalkthroughStepCreateCustomer());
  }
}
