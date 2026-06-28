import 'package:flutter/material.dart';

class WalkthroughKeys {
  // Step 1: Create Customer
  static final GlobalKey homeAddCustomerFab = GlobalKey();
  static final GlobalKey addCustomerNameField = GlobalKey();
  static final GlobalKey addCustomerPhoneField = GlobalKey();
  static final GlobalKey addCustomerSaveButton = GlobalKey();

  // Step 2: Create Template
  static final GlobalKey bottomNavTemplates = GlobalKey();
  static final GlobalKey templatesAddButton = GlobalKey();
  static final GlobalKey templatesQuickStart = GlobalKey();
  static final GlobalKey addTemplateNameField = GlobalKey();
  static final GlobalKey addTemplateContinueButton = GlobalKey();
  static final GlobalKey addTemplateQuickAddFields = GlobalKey();
  static final GlobalKey addTemplateSaveButton = GlobalKey();

  // Step 3: Create Order
  static final GlobalKey homeNewOrderQuickAction = GlobalKey();
  static final GlobalKey ordersAddButton = GlobalKey();
  static final GlobalKey bottomNavOrders = GlobalKey();
  static final GlobalKey orderWhatsAppGuide = GlobalKey();
  static final GlobalKey createOrderSelectCustomer = GlobalKey();
  static final GlobalKey createOrderSelectGarments = GlobalKey();
  static final GlobalKey createOrderSetQuantities = GlobalKey();
}
