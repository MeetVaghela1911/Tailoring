import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';

class UpiQrDialog extends StatefulWidget {
  final double amount;
  final String orderId;
  final String? customerName;

  const UpiQrDialog({
    super.key,
    required this.amount,
    required this.orderId,
    this.customerName,
  });

  @override
  State<UpiQrDialog> createState() => _UpiQrDialogState();
}

class _UpiQrDialogState extends State<UpiQrDialog> {
  late TextEditingController _upiIdController;
  late String _shopName;

  @override
  void initState() {
    super.initState();
    String defaultUpi = 'tailor@upi';
    String sName = 'Tailor Store';

    try {
      if (getIt.isRegistered<AuthBloc>()) {
        final state = getIt<AuthBloc>().state;
        if (state is AuthAuthenticated && state.user.shop != null) {
          if (state.user.shop!.name.isNotEmpty) {
            sName = state.user.shop!.name;
          }
        }
      }
    } catch (_) {}

    _shopName = sName;
    _upiIdController = TextEditingController(text: defaultUpi);
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  String get _upiUri {
    final upi = _upiIdController.text.trim();
    final amt = widget.amount.toStringAsFixed(2);
    final shortOrderId = widget.orderId.length > 8
        ? widget.orderId.substring(0, 8).toUpperCase()
        : widget.orderId.toUpperCase();
    final nameEncoded = Uri.encodeComponent(_shopName);

    return 'upi://pay?pa=$upi&pn=$nameEncoded&am=$amt&cu=INR&tn=Order%20$shortOrderId';
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shortId = widget.orderId.length > 8
        ? widget.orderId.substring(0, 8).toUpperCase()
        : widget.orderId.toUpperCase();

    return Dialog(
      backgroundColor: isDark ? c.cardDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: c.colorPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.qr_code_2, color: c.colorPrimary, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Scan to Pay (UPI)',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: c.gray),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount Display Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.colorPrimary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    'BALANCE AMOUNT DUE',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: c.gray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${widget.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: c.colorPrimary,
                    ),
                  ),
                  Text(
                    'Order #$shortId ${widget.customerName != null ? "• ${widget.customerName}" : ""}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: c.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic QR Code Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: _upiUri,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/e/e1/UPI-Logo-vector.svg',
                  height: 18,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.account_balance_wallet, size: 18, color: c.gray),
                ),
                const SizedBox(width: 8),
                Text(
                  'GPay • PhonePe • Paytm • BHIM',
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: c.gray),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Editable Shop UPI VPA Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _upiIdController,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: c.textDark),
                    decoration: InputDecoration(
                      labelText: 'Shop UPI ID (VPA)',
                      labelStyle: GoogleFonts.poppins(fontSize: 11, color: c.gray),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _upiIdController.text));
                    showAppSnackBar(context, message: 'UPI ID copied!');
                  },
                  icon: Icon(Icons.copy, color: c.colorPrimary, size: 20),
                  tooltip: 'Copy UPI ID',
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
