import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Stitch'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'NEW ORDER'**
  String get newOrder;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @todaysDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Deliveries'**
  String get todaysDeliveries;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @estimatedRevenue.
  ///
  /// In en, this message translates to:
  /// **'Estimated Revenue'**
  String get estimatedRevenue;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @saveLanguage.
  ///
  /// In en, this message translates to:
  /// **'Save Language'**
  String get saveLanguage;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred app language'**
  String get chooseLanguage;

  /// No description provided for @shopManagement.
  ///
  /// In en, this message translates to:
  /// **'Shop Management'**
  String get shopManagement;

  /// No description provided for @shopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop Details'**
  String get shopDetails;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get dataStorage;

  /// No description provided for @subscriptionCloud.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Cloud Sync'**
  String get subscriptionCloud;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out?'**
  String get logOutTitle;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Owner Dashboard'**
  String get ownerDashboard;

  /// No description provided for @shopCurrentlyOpen.
  ///
  /// In en, this message translates to:
  /// **'Shop is currently'**
  String get shopCurrentlyOpen;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @addNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addNewCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @deleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get deleteCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @customerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customerPhone;

  /// No description provided for @customerAddress.
  ///
  /// In en, this message translates to:
  /// **'Customer Address'**
  String get customerAddress;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get selectCustomer;

  /// No description provided for @garmentType.
  ///
  /// In en, this message translates to:
  /// **'Garment Type'**
  String get garmentType;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @advancePaid.
  ///
  /// In en, this message translates to:
  /// **'Advance Paid'**
  String get advancePaid;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @noTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get noTemplatesFound;

  /// No description provided for @addTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add Template'**
  String get addTemplate;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get templateName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// No description provided for @shopAddress.
  ///
  /// In en, this message translates to:
  /// **'Shop Address'**
  String get shopAddress;

  /// No description provided for @shopPhone.
  ///
  /// In en, this message translates to:
  /// **'Shop Phone'**
  String get shopPhone;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'All Set!'**
  String get allSet;

  /// No description provided for @allSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your catalogue, customers, and measurements are ready to go.'**
  String get allSetSubtitle;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @roleSelection.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get roleSelection;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @tailor.
  ///
  /// In en, this message translates to:
  /// **'Tailor'**
  String get tailor;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'APP SETTINGS'**
  String get selectLanguageTitle;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @localMode.
  ///
  /// In en, this message translates to:
  /// **'Local Mode'**
  String get localMode;

  /// No description provided for @orderSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order Created!'**
  String get orderSuccess;

  /// No description provided for @orderSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order has been added successfully'**
  String get orderSuccessSubtitle;

  /// No description provided for @viewOrder.
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get viewOrder;

  /// No description provided for @createAnother.
  ///
  /// In en, this message translates to:
  /// **'Create Another'**
  String get createAnother;

  /// No description provided for @addCust.
  ///
  /// In en, this message translates to:
  /// **'Add Cust.'**
  String get addCust;

  /// No description provided for @tailorOf.
  ///
  /// In en, this message translates to:
  /// **'Tailor of'**
  String get tailorOf;

  /// No description provided for @tapToSetup.
  ///
  /// In en, this message translates to:
  /// **'Tap to set up profile'**
  String get tapToSetup;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// No description provided for @welcomeBackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, let\'s manage your tailoring business.'**
  String get welcomeBackSubtitle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us to manage your tailoring business efficiently.'**
  String get signUpSubtitle;

  /// No description provided for @setupStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String setupStep(int step, int total);

  /// No description provided for @shopDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Details'**
  String get shopDetailsTitle;

  /// No description provided for @shopDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your digital storefront.'**
  String get shopDetailsSubtitle;

  /// No description provided for @businessSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Settings'**
  String get businessSettingsTitle;

  /// No description provided for @businessSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your daily operations and capacity.'**
  String get businessSettingsSubtitle;

  /// No description provided for @finalSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Setup'**
  String get finalSetupTitle;

  /// No description provided for @finalSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your app experience.'**
  String get finalSetupSubtitle;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopNameLabel;

  /// No description provided for @shopNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lakshmi Tailors'**
  String get shopNameHint;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerNameLabel;

  /// No description provided for @shopAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Address'**
  String get shopAddressLabel;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current'**
  String get useCurrentLocation;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Shop No., Street, Landmark, City – Pincode'**
  String get addressHint;

  /// No description provided for @notAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get notAdded;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @businessSettings.
  ///
  /// In en, this message translates to:
  /// **'Business Settings'**
  String get businessSettings;

  /// No description provided for @dailyCapacity.
  ///
  /// In en, this message translates to:
  /// **'Daily Capacity'**
  String get dailyCapacity;

  /// No description provided for @maxOrdersPerDay.
  ///
  /// In en, this message translates to:
  /// **'Max orders per day'**
  String get maxOrdersPerDay;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @workingDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDaysLabel;

  /// No description provided for @workingDaysSub.
  ///
  /// In en, this message translates to:
  /// **'Select the days your shop is open'**
  String get workingDaysSub;

  /// No description provided for @shopTimings.
  ///
  /// In en, this message translates to:
  /// **'Shop Timings'**
  String get shopTimings;

  /// No description provided for @shopTimingsSub.
  ///
  /// In en, this message translates to:
  /// **'Standard operating hours'**
  String get shopTimingsSub;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'OPENING'**
  String get opening;

  /// No description provided for @closing.
  ///
  /// In en, this message translates to:
  /// **'CLOSING'**
  String get closing;

  /// No description provided for @businessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get businessDetails;

  /// No description provided for @gstinNumber.
  ///
  /// In en, this message translates to:
  /// **'GSTIN NUMBER'**
  String get gstinNumber;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @gstinHint.
  ///
  /// In en, this message translates to:
  /// **'GSTIN Number'**
  String get gstinHint;

  /// No description provided for @usedOnInvoices.
  ///
  /// In en, this message translates to:
  /// **'Used on customer invoices.'**
  String get usedOnInvoices;

  /// No description provided for @editShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Shop Details'**
  String get editShopDetails;

  /// No description provided for @saveShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Shop Details'**
  String get saveShopDetails;

  /// No description provided for @savingShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Saving shop details...'**
  String get savingShopDetails;

  /// No description provided for @resetShopDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Shop Details?'**
  String get resetShopDetailsTitle;

  /// No description provided for @resetShopDetailsConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will clear all shop details and cannot be undone.'**
  String get resetShopDetailsConfirm;

  /// No description provided for @shopDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Shop details saved!'**
  String get shopDetailsSaved;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @ownerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Anita Kumar'**
  String get ownerNameHint;

  /// No description provided for @shopAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Shop No., Street Name, Near Landmark,\nArea, City - Pincode'**
  String get shopAddressHint;

  /// No description provided for @addressTip.
  ///
  /// In en, this message translates to:
  /// **'Include landmarks for easier delivery.'**
  String get addressTip;

  /// No description provided for @shopInfoTip.
  ///
  /// In en, this message translates to:
  /// **'This information will be displayed on your customer invoices and WhatsApp messages.'**
  String get shopInfoTip;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @dailyCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Capacity'**
  String get dailyCapacityLabel;

  /// No description provided for @dailyCapacitySub.
  ///
  /// In en, this message translates to:
  /// **'Maximum orders you can stitch per day'**
  String get dailyCapacitySub;

  /// No description provided for @shopTimingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Timings'**
  String get shopTimingsLabel;

  /// No description provided for @appLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguageLabel;

  /// No description provided for @businessDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get businessDetailsLabel;

  /// No description provided for @gstinTip.
  ///
  /// In en, this message translates to:
  /// **'You can add this later in settings.'**
  String get gstinTip;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @termsConditionTip.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Conditions'**
  String get termsConditionTip;

  /// Welcome message when setup is complete
  ///
  /// In en, this message translates to:
  /// **'You\'re all set,\n{shopName}!'**
  String allSetTitle(String shopName);

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @needHelpStarted.
  ///
  /// In en, this message translates to:
  /// **'Need help getting started? '**
  String get needHelpStarted;

  /// No description provided for @viewTutorial.
  ///
  /// In en, this message translates to:
  /// **'View Tutorial'**
  String get viewTutorial;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @roleTitle.
  ///
  /// In en, this message translates to:
  /// **'Role / Title'**
  String get roleTitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @savingProfile.
  ///
  /// In en, this message translates to:
  /// **'Saving profile…'**
  String get savingProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved!'**
  String get profileSaved;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove your profile data.'**
  String get deleteAccountConfirm;

  /// No description provided for @emailLockTip.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed. Contact support.'**
  String get emailLockTip;

  /// No description provided for @shopOrders.
  ///
  /// In en, this message translates to:
  /// **'Shop Orders'**
  String get shopOrders;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search customer or order #...'**
  String get searchPlaceholder;

  /// No description provided for @allOrders.
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get allOrders;

  /// No description provided for @readyForTrial.
  ///
  /// In en, this message translates to:
  /// **'Ready for Trial'**
  String get readyForTrial;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @markDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get markDelivered;

  /// No description provided for @noDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDate;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @overdueBy.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days} days'**
  String overdueBy(int days);

  /// No description provided for @dueIn.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dueIn(int days);

  /// No description provided for @addFirstCustomer.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first customer'**
  String get addFirstCustomer;

  /// No description provided for @noMatchingCustomers.
  ///
  /// In en, this message translates to:
  /// **'No matching customers found'**
  String get noMatchingCustomers;

  /// No description provided for @garment.
  ///
  /// In en, this message translates to:
  /// **'Garment'**
  String get garment;

  /// No description provided for @yourCustomTemplates.
  ///
  /// In en, this message translates to:
  /// **'Your custom garment templates'**
  String get yourCustomTemplates;

  /// No description provided for @searchTemplates.
  ///
  /// In en, this message translates to:
  /// **'Search templates...'**
  String get searchTemplates;

  /// No description provided for @quickStartTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick Start Templates'**
  String get quickStartTemplates;

  /// No description provided for @yourCollection.
  ///
  /// In en, this message translates to:
  /// **'Your Collection'**
  String get yourCollection;

  /// No description provided for @noTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get noTemplatesYet;

  /// No description provided for @createFirstTemplate.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first\ngarment template.'**
  String get createFirstTemplate;

  /// No description provided for @noMatchingTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates match.'**
  String get noMatchingTemplates;

  /// No description provided for @trySearchingDifferent.
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different term.'**
  String get trySearchingDifferent;

  /// No description provided for @addedToTemplates.
  ///
  /// In en, this message translates to:
  /// **'{name} added to your templates!'**
  String addedToTemplates(String name);

  /// No description provided for @moreFields.
  ///
  /// In en, this message translates to:
  /// **'+{count} MORE'**
  String moreFields(int count);

  /// No description provided for @fieldsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Fields'**
  String fieldsCount(int count);

  /// No description provided for @customerAdded.
  ///
  /// In en, this message translates to:
  /// **'Customer added!'**
  String get customerAdded;

  /// No description provided for @customerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated!'**
  String get customerUpdated;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted!'**
  String get customerDeleted;

  /// No description provided for @customerDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer?'**
  String get customerDeletedTitle;

  /// No description provided for @customerDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String customerDeleteConfirm(String name);

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @addressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (Optional)'**
  String get addressOptional;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @updateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Update Customer'**
  String get updateCustomer;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get saveCustomer;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneRequired;

  /// No description provided for @welcomeTitlePart1.
  ///
  /// In en, this message translates to:
  /// **'Crafting the\n'**
  String get welcomeTitlePart1;

  /// No description provided for @welcomeTitlePart2.
  ///
  /// In en, this message translates to:
  /// **'Future of Tailoring'**
  String get welcomeTitlePart2;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The ultimate management tool for tailors and boutique owners.'**
  String get welcomeSubtitle;

  /// No description provided for @stitchBusiness.
  ///
  /// In en, this message translates to:
  /// **'STITCH · BUSINESS'**
  String get stitchBusiness;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordRequired;

  /// No description provided for @minPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get minPasswordLength;

  /// No description provided for @roleMasterTailor.
  ///
  /// In en, this message translates to:
  /// **'Master Tailor'**
  String get roleMasterTailor;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleShopManager.
  ///
  /// In en, this message translates to:
  /// **'Shop Manager'**
  String get roleShopManager;

  /// No description provided for @roleTailor.
  ///
  /// In en, this message translates to:
  /// **'Tailor'**
  String get roleTailor;

  /// No description provided for @roleAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get roleAssistant;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 chars'**
  String get min6Chars;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySun;

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get editTemplate;

  /// No description provided for @templateDetails.
  ///
  /// In en, this message translates to:
  /// **'Template Details'**
  String get templateDetails;

  /// No description provided for @measurementFields.
  ///
  /// In en, this message translates to:
  /// **'Measurement Fields'**
  String get measurementFields;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Template?'**
  String get deleteTemplateTitle;

  /// No description provided for @deleteTemplateConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove \"{name}\".'**
  String deleteTemplateConfirm(Object name);

  /// No description provided for @addCustomField.
  ///
  /// In en, this message translates to:
  /// **'Add custom field'**
  String get addCustomField;

  /// No description provided for @noFieldsYet.
  ///
  /// In en, this message translates to:
  /// **'No fields yet — add some above.'**
  String get noFieldsYet;

  /// No description provided for @noFieldsDefined.
  ///
  /// In en, this message translates to:
  /// **'No fields defined.'**
  String get noFieldsDefined;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder · tap ✕ to remove · tap chip to add'**
  String get dragToReorder;

  /// No description provided for @templateUpdated.
  ///
  /// In en, this message translates to:
  /// **'Template updated!'**
  String get templateUpdated;

  /// No description provided for @templateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted.'**
  String get templateDeleted;

  /// No description provided for @templateNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Template name cannot be empty.'**
  String get templateNameEmpty;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get statusNotStarted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetailTitle;

  /// No description provided for @garmentsDesign.
  ///
  /// In en, this message translates to:
  /// **'Garments & Design'**
  String get garmentsDesign;

  /// No description provided for @scheduleAssign.
  ///
  /// In en, this message translates to:
  /// **'Schedule & Assign'**
  String get scheduleAssign;

  /// No description provided for @deliveryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDateLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @assignedTailorLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned Tailor'**
  String get assignedTailorLabel;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @advancePaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Advance Paid'**
  String get advancePaidLabel;

  /// No description provided for @paymentModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentModeLabel;

  /// No description provided for @specialInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructionsLabel;

  /// No description provided for @detailsByGarment.
  ///
  /// In en, this message translates to:
  /// **'Details by Garment'**
  String get detailsByGarment;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paid;

  /// No description provided for @balanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get balanceDue;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentOnline.
  ///
  /// In en, this message translates to:
  /// **'Online/UPI'**
  String get paymentOnline;

  /// No description provided for @deleteOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Order?'**
  String get deleteOrderTitle;

  /// No description provided for @deleteOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the order for {name}? This cannot be undone.'**
  String deleteOrderConfirm(Object name);

  /// No description provided for @couldNotLaunchWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch WhatsApp'**
  String get couldNotLaunchWhatsApp;

  /// No description provided for @noPhoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number available'**
  String get noPhoneAvailable;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation successful!'**
  String get operationSuccessful;

  /// No description provided for @imageFailed.
  ///
  /// In en, this message translates to:
  /// **'Image failed to load'**
  String get imageFailed;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'NOTE'**
  String get note;

  /// No description provided for @templateMenShirt.
  ///
  /// In en, this message translates to:
  /// **'Men\'s Shirt'**
  String get templateMenShirt;

  /// No description provided for @templateTrousers.
  ///
  /// In en, this message translates to:
  /// **'Trousers/Pants'**
  String get templateTrousers;

  /// No description provided for @templateMenKurta.
  ///
  /// In en, this message translates to:
  /// **'Men\'s Kurta'**
  String get templateMenKurta;

  /// No description provided for @templateFullSuit.
  ///
  /// In en, this message translates to:
  /// **'Full Suit'**
  String get templateFullSuit;

  /// No description provided for @templateBlouse.
  ///
  /// In en, this message translates to:
  /// **'Blouse'**
  String get templateBlouse;

  /// No description provided for @templateKurtiWomen.
  ///
  /// In en, this message translates to:
  /// **'Kurti/Top'**
  String get templateKurtiWomen;

  /// No description provided for @templateSalwar.
  ///
  /// In en, this message translates to:
  /// **'Salwar/Plazo'**
  String get templateSalwar;

  /// No description provided for @templateGown.
  ///
  /// In en, this message translates to:
  /// **'Gown/Dress'**
  String get templateGown;

  /// No description provided for @mensWear.
  ///
  /// In en, this message translates to:
  /// **'Men\'s Wear'**
  String get mensWear;

  /// No description provided for @womensWear.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Wear'**
  String get womensWear;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplate;

  /// No description provided for @templateNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Princess Cut Blouse'**
  String get templateNameHint;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blouses, Suits, Bottoms…'**
  String get categoryHint;

  /// No description provided for @basePriceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500'**
  String get basePriceHint;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @customTemplate.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM TEMPLATE'**
  String get customTemplate;

  /// No description provided for @continueToFields.
  ///
  /// In en, this message translates to:
  /// **'Continue to Fields'**
  String get continueToFields;

  /// No description provided for @step1of2.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get step1of2;

  /// No description provided for @step2of2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get step2of2;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @fieldsList.
  ///
  /// In en, this message translates to:
  /// **'Fields List'**
  String get fieldsList;

  /// No description provided for @noFieldsAdded.
  ///
  /// In en, this message translates to:
  /// **'No fields added yet.'**
  String get noFieldsAdded;

  /// No description provided for @dragToRemove.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder · tap ✕ to remove'**
  String get dragToRemove;

  /// No description provided for @templateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved successfully!'**
  String get templateSaved;

  /// No description provided for @missingTemplateInfo.
  ///
  /// In en, this message translates to:
  /// **'Missing template information.'**
  String get missingTemplateInfo;

  /// No description provided for @addCustomFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Add custom field (e.g. APEX POINT)'**
  String get addCustomFieldHint;

  /// No description provided for @fieldsCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'{count} fields'**
  String fieldsCountSuffix(Object count);

  /// No description provided for @fieldBust.
  ///
  /// In en, this message translates to:
  /// **'BUST'**
  String get fieldBust;

  /// No description provided for @fieldWaist.
  ///
  /// In en, this message translates to:
  /// **'WAIST'**
  String get fieldWaist;

  /// No description provided for @fieldHip.
  ///
  /// In en, this message translates to:
  /// **'HIP'**
  String get fieldHip;

  /// No description provided for @fieldShoulder.
  ///
  /// In en, this message translates to:
  /// **'SHOULDER'**
  String get fieldShoulder;

  /// No description provided for @fieldSleeve.
  ///
  /// In en, this message translates to:
  /// **'SLEEVE'**
  String get fieldSleeve;

  /// No description provided for @fieldLength.
  ///
  /// In en, this message translates to:
  /// **'LENGTH'**
  String get fieldLength;

  /// No description provided for @fieldChest.
  ///
  /// In en, this message translates to:
  /// **'CHEST'**
  String get fieldChest;

  /// No description provided for @fieldFlare.
  ///
  /// In en, this message translates to:
  /// **'FLARE'**
  String get fieldFlare;

  /// No description provided for @fieldThigh.
  ///
  /// In en, this message translates to:
  /// **'THIGH'**
  String get fieldThigh;

  /// No description provided for @fieldKnee.
  ///
  /// In en, this message translates to:
  /// **'KNEE'**
  String get fieldKnee;

  /// No description provided for @fieldAnkle.
  ///
  /// In en, this message translates to:
  /// **'ANKLE'**
  String get fieldAnkle;

  /// No description provided for @fieldNeck.
  ///
  /// In en, this message translates to:
  /// **'NECK'**
  String get fieldNeck;

  /// No description provided for @fieldSlit.
  ///
  /// In en, this message translates to:
  /// **'SLIT'**
  String get fieldSlit;

  /// No description provided for @fieldArmhole.
  ///
  /// In en, this message translates to:
  /// **'ARMHOLE'**
  String get fieldArmhole;

  /// No description provided for @fieldFullLength.
  ///
  /// In en, this message translates to:
  /// **'FULL LENGTH'**
  String get fieldFullLength;

  /// No description provided for @fieldSleeveLength.
  ///
  /// In en, this message translates to:
  /// **'SLEEVE LENGTH'**
  String get fieldSleeveLength;

  /// No description provided for @fieldCuff.
  ///
  /// In en, this message translates to:
  /// **'CUFF'**
  String get fieldCuff;

  /// No description provided for @fieldCollar.
  ///
  /// In en, this message translates to:
  /// **'COLLAR'**
  String get fieldCollar;

  /// No description provided for @fieldBottom.
  ///
  /// In en, this message translates to:
  /// **'BOTTOM'**
  String get fieldBottom;

  /// No description provided for @fieldInseam.
  ///
  /// In en, this message translates to:
  /// **'INSEAM'**
  String get fieldInseam;

  /// No description provided for @fieldJacketLength.
  ///
  /// In en, this message translates to:
  /// **'JACKET LENGTH'**
  String get fieldJacketLength;

  /// No description provided for @fieldPantsLength.
  ///
  /// In en, this message translates to:
  /// **'PANTS LENGTH'**
  String get fieldPantsLength;

  /// No description provided for @fieldPantsWaist.
  ///
  /// In en, this message translates to:
  /// **'PANTS WAIST'**
  String get fieldPantsWaist;

  /// No description provided for @fieldFrontNeck.
  ///
  /// In en, this message translates to:
  /// **'FRONT NECK'**
  String get fieldFrontNeck;

  /// No description provided for @fieldBackNeck.
  ///
  /// In en, this message translates to:
  /// **'BACK NECK'**
  String get fieldBackNeck;

  /// No description provided for @fieldCrossBack.
  ///
  /// In en, this message translates to:
  /// **'CROSS BACK'**
  String get fieldCrossBack;

  /// No description provided for @fieldBackDepth.
  ///
  /// In en, this message translates to:
  /// **'BACK DEPTH'**
  String get fieldBackDepth;

  /// No description provided for @fieldFrontDepth.
  ///
  /// In en, this message translates to:
  /// **'FRONT DEPTH'**
  String get fieldFrontDepth;

  /// No description provided for @selectedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Selected Customer'**
  String get selectedCustomer;

  /// No description provided for @recentCustomers.
  ///
  /// In en, this message translates to:
  /// **'Recent Customers'**
  String get recentCustomers;

  /// No description provided for @step1of5.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 5'**
  String get step1of5;

  /// No description provided for @searchCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone...'**
  String get searchCustomerHint;

  /// No description provided for @keepSelected.
  ///
  /// In en, this message translates to:
  /// **'Keep Selected'**
  String get keepSelected;

  /// No description provided for @createNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create New Customer'**
  String get createNewCustomer;

  /// No description provided for @addOrderItems.
  ///
  /// In en, this message translates to:
  /// **'Add Order Items'**
  String get addOrderItems;

  /// No description provided for @selectGarmentsDesign.
  ///
  /// In en, this message translates to:
  /// **'Select garments and design details'**
  String get selectGarmentsDesign;

  /// No description provided for @itemX.
  ///
  /// In en, this message translates to:
  /// **'Item {index}'**
  String itemX(Object index);

  /// No description provided for @garmentTypeCap.
  ///
  /// In en, this message translates to:
  /// **'GARMENT TYPE'**
  String get garmentTypeCap;

  /// No description provided for @selectAllApply.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get selectAllApply;

  /// No description provided for @quantitiesCap.
  ///
  /// In en, this message translates to:
  /// **'QUANTITIES'**
  String get quantitiesCap;

  /// No description provided for @takeMeasurementsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Take Measurements ({count} {count, plural, =1{garment} other{garments}})'**
  String takeMeasurementsWithCount(num count);

  /// No description provided for @designDetails.
  ///
  /// In en, this message translates to:
  /// **'Design Details'**
  String get designDetails;

  /// No description provided for @addReferencePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Reference Photo'**
  String get addReferencePhoto;

  /// No description provided for @uploadPatternHint.
  ///
  /// In en, this message translates to:
  /// **'Upload fabric pattern or design sketch'**
  String get uploadPatternHint;

  /// No description provided for @specialInstructionsCap.
  ///
  /// In en, this message translates to:
  /// **'SPECIAL INSTRUCTIONS'**
  String get specialInstructionsCap;

  /// No description provided for @specialInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Deep back neck, gold piping on sleeves, double stitching required...'**
  String get specialInstructionsHint;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @nextMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Next: Measurements'**
  String get nextMeasurements;

  /// No description provided for @selectAtLeastOneGarment.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one garment type first.'**
  String get selectAtLeastOneGarment;

  /// No description provided for @scheduleAndAssign.
  ///
  /// In en, this message translates to:
  /// **'Schedule & Assign'**
  String get scheduleAndAssign;

  /// No description provided for @setDeliveryExpectations.
  ///
  /// In en, this message translates to:
  /// **'Set delivery expectations and allocate work.'**
  String get setDeliveryExpectations;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @selectDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Date'**
  String get selectDeliveryDate;

  /// No description provided for @highCapacityDay.
  ///
  /// In en, this message translates to:
  /// **'High Capacity Day'**
  String get highCapacityDay;

  /// No description provided for @shopFloorLoadHint.
  ///
  /// In en, this message translates to:
  /// **'Shop floor is at 90% load. Delivery might be tight.'**
  String get shopFloorLoadHint;

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority Level'**
  String get priorityLevel;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent •'**
  String get urgent;

  /// No description provided for @highPrioritySurchargeHint.
  ///
  /// In en, this message translates to:
  /// **'High priority adds a 15% surcharge to the total bill.'**
  String get highPrioritySurchargeHint;

  /// No description provided for @reviewAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Review & Payment'**
  String get reviewAndPayment;

  /// No description provided for @finalizeDetailsCollectAdvance.
  ///
  /// In en, this message translates to:
  /// **'Finalize details and collect advance.'**
  String get finalizeDetailsCollectAdvance;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'{count} Qty'**
  String qty(Object count);

  /// No description provided for @externalCharges.
  ///
  /// In en, this message translates to:
  /// **'External Charges'**
  String get externalCharges;

  /// No description provided for @additionalServices.
  ///
  /// In en, this message translates to:
  /// **'Additional services'**
  String get additionalServices;

  /// No description provided for @collectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Collection Details'**
  String get collectionDetails;

  /// No description provided for @advanceAmountCap.
  ///
  /// In en, this message translates to:
  /// **'ADVANCE AMOUNT'**
  String get advanceAmountCap;

  /// No description provided for @paymentModeCap.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT MODE'**
  String get paymentModeCap;

  /// No description provided for @onlineUPI.
  ///
  /// In en, this message translates to:
  /// **'Online/UPI'**
  String get onlineUPI;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload Error: {error}'**
  String uploadError(String error);

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order Created\nSuccessfully!'**
  String get orderCreatedSuccessfully;

  /// No description provided for @orderCreatedSubtext.
  ///
  /// In en, this message translates to:
  /// **'Great job! The measurements have been\nsaved and the order is now in the queue.'**
  String get orderCreatedSubtext;

  /// No description provided for @orderReferenceCap.
  ///
  /// In en, this message translates to:
  /// **'ORDER REFERENCE'**
  String get orderReferenceCap;

  /// No description provided for @createAnotherOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Another Order'**
  String get createAnotherOrder;

  /// No description provided for @viewOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get viewOrderDetails;

  /// No description provided for @takeMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Take Measurements'**
  String get takeMeasurements;

  /// No description provided for @enterGarmentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Enter {garment} measurements for this order'**
  String enterGarmentMeasurements(Object garment);

  /// No description provided for @neckDepthDetails.
  ///
  /// In en, this message translates to:
  /// **'Neck Depth Details'**
  String get neckDepthDetails;

  /// No description provided for @front.
  ///
  /// In en, this message translates to:
  /// **'FRONT'**
  String get front;

  /// No description provided for @frontNeckDepth.
  ///
  /// In en, this message translates to:
  /// **'FRONT NECK DEPTH'**
  String get frontNeckDepth;

  /// No description provided for @backNeckDepth.
  ///
  /// In en, this message translates to:
  /// **'BACK NECK DEPTH'**
  String get backNeckDepth;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Specific fitting requests, alterations...'**
  String get notesHint;

  /// No description provided for @setAsDefaultProfile.
  ///
  /// In en, this message translates to:
  /// **'Set as Default Profile'**
  String get setAsDefaultProfile;

  /// No description provided for @reuseForFutureOrders.
  ///
  /// In en, this message translates to:
  /// **'Reuse for future {garment} orders'**
  String reuseForFutureOrders(Object garment);

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @saveMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Save Measurements'**
  String get saveMeasurements;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @step2of5.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 5'**
  String get step2of5;

  /// No description provided for @step3of5.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 5'**
  String get step3of5;

  /// No description provided for @step4of5.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 5'**
  String get step4of5;

  /// No description provided for @step5of5.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 5'**
  String get step5of5;

  /// No description provided for @editOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit Order'**
  String get editOrder;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// No description provided for @garmentTypes.
  ///
  /// In en, this message translates to:
  /// **'Garment Types'**
  String get garmentTypes;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save Template'**
  String get saveTemplate;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @quickStartGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get quickStartGuide;

  /// No description provided for @step1ShopSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Setup'**
  String get step1ShopSetupTitle;

  /// No description provided for @step1ShopSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings and set up your shop details like name and address.'**
  String get step1ShopSetupDesc;

  /// No description provided for @step2TemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Templates'**
  String get step2TemplatesTitle;

  /// No description provided for @step2TemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Create measurement templates for different garments like Shirt, Pant, etc.'**
  String get step2TemplatesDesc;

  /// No description provided for @step3CustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Customers'**
  String get step3CustomersTitle;

  /// No description provided for @step3CustomersDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your customers\' contact details to your directory.'**
  String get step3CustomersDesc;

  /// No description provided for @step4CreateOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get step4CreateOrderTitle;

  /// No description provided for @step4CreateOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create a new order and follow the steps.'**
  String get step4CreateOrderDesc;

  /// No description provided for @step5TrackOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Track & Update'**
  String get step5TrackOrdersTitle;

  /// No description provided for @step5TrackOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your orders and send updates to customers via WhatsApp.'**
  String get step5TrackOrdersDesc;

  /// No description provided for @walkthroughAddCustFab.
  ///
  /// In en, this message translates to:
  /// **'Start by creating your first customer.'**
  String get walkthroughAddCustFab;

  /// No description provided for @walkthroughCustName.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer\'s full name.'**
  String get walkthroughCustName;

  /// No description provided for @walkthroughCustPhone.
  ///
  /// In en, this message translates to:
  /// **'Add their phone number to contact them later.'**
  String get walkthroughCustPhone;

  /// No description provided for @walkthroughCustSave.
  ///
  /// In en, this message translates to:
  /// **'Tap here to save your first customer!'**
  String get walkthroughCustSave;

  /// No description provided for @walkthroughNavTemplates.
  ///
  /// In en, this message translates to:
  /// **'Now create your first measurement template.'**
  String get walkthroughNavTemplates;

  /// No description provided for @walkthroughTemplatesAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap here to create a template for a garment (e.g. Shirt, Suit).'**
  String get walkthroughTemplatesAdd;

  /// No description provided for @walkthroughQuickStartTemplates.
  ///
  /// In en, this message translates to:
  /// **'Tap any Quick Start Template to instantly add it to your collection!'**
  String get walkthroughQuickStartTemplates;

  /// No description provided for @walkthroughOrdersAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap here to create a new order!'**
  String get walkthroughOrdersAdd;

  /// No description provided for @walkthroughNavOrders.
  ///
  /// In en, this message translates to:
  /// **'Tap here to go to the Orders tab.'**
  String get walkthroughNavOrders;

  /// No description provided for @walkthroughWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Tap the WhatsApp icon to message your customer directly.'**
  String get walkthroughWhatsApp;

  /// No description provided for @walkthroughTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the template (e.g. Men\'s Shirt).'**
  String get walkthroughTemplateName;

  /// No description provided for @walkthroughTemplateContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap here to continue to the next step.'**
  String get walkthroughTemplateContinue;

  /// No description provided for @walkthroughTemplateQuickFields.
  ///
  /// In en, this message translates to:
  /// **'Tap standard chips to add fields quickly, or type custom ones below.'**
  String get walkthroughTemplateQuickFields;

  /// No description provided for @walkthroughTemplateSave.
  ///
  /// In en, this message translates to:
  /// **'Tap here to save the template.'**
  String get walkthroughTemplateSave;

  /// No description provided for @walkthroughSettingsTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: You can update your shop details anytime from the Settings tab.'**
  String get walkthroughSettingsTip;

  /// No description provided for @walkthroughRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart Onboarding Guide'**
  String get walkthroughRestart;

  /// No description provided for @walkthroughSelectGarments.
  ///
  /// In en, this message translates to:
  /// **'Tap any garment type to select it. You can select multiple garments as well!'**
  String get walkthroughSelectGarments;

  /// No description provided for @walkthroughSetQuantities.
  ///
  /// In en, this message translates to:
  /// **'You can adjust the quantity for each selected garment type here!'**
  String get walkthroughSetQuantities;

  /// No description provided for @pleaseSelectDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Please select an estimated delivery date before proceeding.'**
  String get pleaseSelectDeliveryDate;

  /// No description provided for @orderSuccessTip.
  ///
  /// In en, this message translates to:
  /// **'You can track this order from the Orders tab. Tap to view details or share updates with your customer.'**
  String get orderSuccessTip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mr',
    'pa',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
