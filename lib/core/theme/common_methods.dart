import 'package:flutter/material.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:tailoring_flutter/core/theme/app_colors.dart';

AppColorScheme getThemeBaseColors(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colors = isDark ? AppColors.dark : AppColors.light;
  return colors;
}

String getLocalizedRole(String? roleKey, AppLocalizations l10n) {
  if (roleKey == null || roleKey.isEmpty) return '';
  switch (roleKey) {
    case 'Master Tailor':
      return l10n.roleMasterTailor;
    case 'Owner':
      return l10n.roleOwner;
    case 'Shop Manager':
      return l10n.roleShopManager;
    case 'Tailor':
      return l10n.roleTailor;
    case 'Assistant':
      return l10n.roleAssistant;
    default:
      return roleKey;
  }
}
String getLocalizedStatus(String? statusKey, AppLocalizations l10n) {
  if (statusKey == null || statusKey.isEmpty) return '';
  switch (statusKey.toUpperCase()) {
    case 'NOT STARTED':
      return l10n.statusNotStarted;
    case 'IN PROGRESS':
      return l10n.statusInProgress;
    case 'READY':
      return l10n.statusReady;
    case 'OVERDUE':
      return l10n.statusOverdue;
    case 'DELIVERED':
      return l10n.statusDelivered;
    default:
      return statusKey;
  }
}

String getLocalizedTemplateName(String? templateId, String fallback, AppLocalizations l10n) {
  switch (templateId) {
    case 'template_shirt': return l10n.templateMenShirt;
    case 'template_trousers': return l10n.templateTrousers;
    case 'template_kurta_men': return l10n.templateMenKurta;
    case 'template_suit': return l10n.templateFullSuit;
    case 'template_blouse': return l10n.templateBlouse;
    case 'template_kurti_women': return l10n.templateKurtiWomen;
    case 'template_salwar': return l10n.templateSalwar;
    case 'template_gown': return l10n.templateGown;
    default: return fallback;
  }
}

String getLocalizedCategory(String? category, AppLocalizations l10n) {
  if (category == 'Men\'s Wear') return l10n.mensWear;
  if (category == 'Women\'s Wear') return l10n.womensWear;
  return category ?? '';
}

String getLocalizedMeasurementField(String field, AppLocalizations l10n) {
  final upper = field.toUpperCase();
  switch (upper) {
    case 'BUST': return l10n.fieldBust;
    case 'WAIST': return l10n.fieldWaist;
    case 'HIP': return l10n.fieldHip;
    case 'SHOULDER': return l10n.fieldShoulder;
    case 'SLEEVE': return l10n.fieldSleeve;
    case 'LENGTH': return l10n.fieldLength;
    case 'CHEST': return l10n.fieldChest;
    case 'SLEEVE LENGTH': return l10n.fieldSleeveLength;
    case 'CUFF': return l10n.fieldCuff;
    case 'COLLAR': return l10n.fieldCollar;
    case 'BOTTOM': return l10n.fieldBottom;
    case 'INSEAM': return l10n.fieldInseam;
    case 'JACKET LENGTH': return l10n.fieldJacketLength;
    case 'PANTS LENGTH': return l10n.fieldPantsLength;
    case 'PANTS WAIST': return l10n.fieldPantsWaist;
    case 'FRONT NECK': return l10n.fieldFrontNeck;
    case 'BACK NECK': return l10n.fieldBackNeck;
    case 'CROSS BACK': return l10n.fieldCrossBack;
    case 'ARMHOLE':
    case 'ARM HOLE': return l10n.fieldArmhole;
    case 'FULL LENGTH': return l10n.fieldFullLength;
    case 'FLARE': return l10n.fieldFlare;
    case 'THIGH': return l10n.fieldThigh;
    case 'KNEE': return l10n.fieldKnee;
    case 'ANKLE': return l10n.fieldAnkle;
    case 'NECK': return l10n.fieldNeck;
    case 'SLIT': return l10n.fieldSlit;
    case 'BACK DEPTH': return l10n.fieldBackDepth;
    case 'FRONT DEPTH': return l10n.fieldFrontDepth;
    default: return field;
  }
}
String getLocalizedPriority(int index, AppLocalizations l10n) {
  switch (index) {
    case 0: return l10n.priorityNormal;
    case 1: return l10n.priorityHigh;
    case 2: return l10n.priorityUrgent;
    default: return l10n.priorityNormal;
  }
}

String getLocalizedPaymentMode(int index, AppLocalizations l10n) {
  switch (index) {
    case 0: return l10n.paymentCash;
    case 1: return l10n.paymentCard;
    case 2: return l10n.paymentOnline;
    case 3: return 'Not Specified';
    default: return 'Custom';
  }
}
