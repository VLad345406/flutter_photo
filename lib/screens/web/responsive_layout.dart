import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget webScaffold;

  const ResponsiveLayout({
    super.key,
    required this.mobileScaffold,
    required this.webScaffold,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300 || constraints.maxHeight < 300) {
          return Scaffold(
            body: Center(
              child: Text('That window too small!'),
            ),
          );
        }
        else if (constraints.maxWidth <= 850) {
          return mobileScaffold;
        }
        else {
          return webScaffold;
        }
      },
    );
  }
}
