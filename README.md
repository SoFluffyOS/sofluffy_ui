# sofluffy_ui

[![pub package](https://img.shields.io/pub/v/sofluffy_ui.svg)](https://pub.dev/packages/sofluffy_ui) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Powered by SoFluffy](https://img.shields.io/badge/Powered%20by-SoFluffy-orange)](https://sofluffy.io)

<img width="895" height="783" alt="image" src="https://github.com/user-attachments/assets/24704588-3b5c-4076-a57a-bc4f0e0b5318" />

A fluffy, responsive, and customizable UI package for Flutter applications across platforms.

## Features

- 🎨 **Adaptive Theming**: Built-in light and dark themes with configurable palettes and typography.
- 🧩 **Comprehensive Components**: Buttons, switches, checkboxes, sliders, tooltips, dialogs, dropdowns, and more.
- 📱 **Cross-Platform Ready**: Designed for desktop (macOS, Windows, Linux), mobile (iOS, Android), and web.

## Getting started

Add `sofluffy_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  sofluffy_ui: ^1.0.0
```

## Usage

Wrap your application or screen with `FluffyTheme`:

```dart
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  runApp(
    FluffyTheme(
      data: FluffyThemeData.fallback(),
      child: const MyApp(),
    ),
  );
}
```

Use `sofluffy_ui` components anywhere within the theme scope:

```dart
Button(
  variant: .primary,
  label: 'Click me',
  onPressed: () {},
)
```

## Apps Using sofluffy_ui

- [Lumide](https://lumide.dev) – A modern desktop IDE and code editor built with Flutter, featuring language server intelligence, an interactive Git client, AI assistance, and flexible split-pane workspaces.
- [Media Converter Pro: Ultimate](https://play.google.com/store/apps/details?id=com.github.khangnt.mcp) – An offline audio and video converter and media processing toolkit for Android powered by FFmpeg.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [SoFluffy](https://sofluffy.io).

## Happy Coding 🦊
