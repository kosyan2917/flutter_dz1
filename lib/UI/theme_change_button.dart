import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme.dart';

class ThemeChangeButton extends ConsumerWidget {
  const ThemeChangeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return TextButton(
      onPressed: themeState.themeData.brightness == Brightness.light
          ? themeState.toggleDark
          : themeState.toggleLight,
      child: Icon(
        Icons.brightness_6,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
