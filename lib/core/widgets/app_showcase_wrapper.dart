import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

/// [AppShowcaseWrapper] initializes [ShowcaseView] with a stable, fixed scope
/// across MaterialApp rebuilds.
///
/// This resolves exceptions where deprecated ShowCaseWidget generates a dynamic
/// widget.hashCode scope and unregisters it on rebuild, breaking active
/// Showcase widgets in retained subtrees (like ListView or IndexedStack).
class AppShowcaseWrapper extends StatefulWidget {
  final Widget child;

  const AppShowcaseWrapper({super.key, required this.child});

  @override
  State<AppShowcaseWrapper> createState() => _AppShowcaseWrapperState();
}

class _AppShowcaseWrapperState extends State<AppShowcaseWrapper> {
  @override
  void initState() {
    super.initState();
    ShowcaseView.register();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
