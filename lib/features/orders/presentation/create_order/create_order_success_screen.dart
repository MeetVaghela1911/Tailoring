import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../../routes/app_router.dart';
import '../../domain/entities/order_entity.dart';

class CreateOrderSuccessScreen extends StatelessWidget {
  final OrderEntity? order;
  const CreateOrderSuccessScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Same gradient as all other create-order screens
    final topGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(AppRoutes.home);
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: Stack(
        children: [
          // ── Same fade gradient as every other screen ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    topGradient,
                    midGradient,
                    c.background.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Decorative scattered dots — matching the image
                _dot(
                  context,
                  top: 120,
                  left: 30,
                  color: const Color(0xFFFF7B7B),
                  size: 10,
                ),
                _dot(
                  context,
                  top: 160,
                  right: 50,
                  color: const Color(0xFFFFD166),
                  size: 11,
                ),
                _dot(
                  context,
                  top: 230,
                  left: 55,
                  color: const Color(0xFF6C63FF),
                  size: 8,
                ),
                _dot(
                  context,
                  top: 260,
                  right: 30,
                  color: const Color(0xFFFFD166),
                  size: 9,
                ),
                _dot(
                  context,
                  top: 310,
                  right: 85,
                  color: const Color(0xFF6C63FF),
                  size: 6,
                ),
                _dot(
                  context,
                  top: 100,
                  right: 90,
                  color: const Color(0xFF45A8FF),
                  size: 7,
                  isRect: true,
                ),
                _dot(
                  context,
                  top: 330,
                  left: 30,
                  color: const Color(0xFFFF7B7B),
                  size: 7,
                  isRect: true,
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Close button aligned top-right
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: GestureDetector(
                            onTap: () => context.go(AppRoutes.home),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.close,
                                color: isDark ? Colors.white70 : Colors.black54,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Large glowing circle with checkmark
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring (translucent)
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(
                                alpha: isDark ? 0.1 : 0.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // White middle ring
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          // Green checkmark circle
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF4CAF50),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // Title
                      Text(
                        AppLocalizations.of(context).orderCreatedSuccessfully,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A0A4A),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        AppLocalizations.of(context).orderCreatedSubtext,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF1A0A4A).withValues(alpha: 0.55),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Order Reference Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).orderReferenceCap,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: c.colorPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              order != null 
                                  ? '#${order!.id.substring(0, 8).toUpperCase()}' 
                                  : '#ORD-2024-0234',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A0A4A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Tip Card for settings
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.colorPrimary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: c.colorPrimary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: c.colorPrimary, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).orderSuccessTip,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white70 : const Color(0xFF1A0A4A).withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),


                      // Create Another Order
                      _buildButton(
                        label: AppLocalizations.of(context).createAnotherOrder,
                        icon: Icons.add_circle_outline,
                        color: c.colorPrimary,
                        onTap: () => context.go(AppRoutes.createOrder),
                      ),
                      const SizedBox(height: 20),

                      // View Order Details
                      GestureDetector(
                        onTap: () {
                          if (order != null) {
                            context.go(AppRoutes.orderDetail, extra: order);
                          } else {
                            context.go(AppRoutes.home);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            AppLocalizations.of(context).viewOrderDetails,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white60
                                  : const Color(
                                      0xFF1A0A4A,
                                    ).withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ], // outer Stack children
      ), // outer Stack
    )
    );
  }

  Widget _dot(
    BuildContext context, {
    double? top,
    double? left,
    double? right,
    double? bottom,
    required Color color,
    required double size,
    bool isRect = false,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: isRect ? size * 0.5 : size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: isRect
              ? BorderRadius.circular(2)
              : BorderRadius.circular(size / 2),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
