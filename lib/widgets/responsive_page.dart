import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.header,
    required this.child,
    this.footer,
  });
  final Widget header;
  final Widget child;
  final Widget? footer;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width < 600 ? 24 : 40,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: header,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
                if (footer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 20),
                    child: footer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
