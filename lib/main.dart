import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;
import 'package:bonsoir/bonsoir.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:maid/locale/app_localizations.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:dio/dio.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:llama_sdk/llama_sdk.dart'
    if (dart.library.html) 'package:llama_sdk/llama_sdk.web.dart' as llama;
import 'package:ollama_dart/ollama_dart.dart' as ollama;
import 'package:openai_dart/openai_dart.dart' as open_ai;
import 'package:mistralai_dart/mistralai_dart.dart' as mistral;
import 'package:url_launcher/url_launcher.dart';

part 'controllers/app_settings.dart';
part 'controllers/artificial_intelligence_controller.dart';
part 'controllers/chat_controller.dart';

part 'utilities/chat_messages_extension.dart';
part 'utilities/chat_messages.dart';
part 'utilities/huggingface_manager.dart';
part 'utilities/maid_service.dart';
part 'utilities/target_platform_extension.dart';
part 'utilities/string_extension.dart';
part 'utilities/theme_mode_extension.dart';

part 'widgets/buttons/load_model_button.dart';
part 'widgets/buttons/menu_button.dart';

part 'widgets/chat/chat_tile.dart';
part 'widgets/chat/chat_view.dart';

part 'widgets/dialogs/error_dialog.dart';
part 'widgets/dialogs/nsfw_warning_dialog.dart';
part 'widgets/dialogs/sharing_dialog.dart';

part 'widgets/dropdowns/artificial_intelligence_dropdown.dart';
part 'widgets/dropdowns/locale_dropdown.dart';
part 'widgets/dropdowns/remote_model_dropdown.dart';
part 'widgets/dropdowns/theme_mode_dropdown.dart';

part 'widgets/message/message_view.dart';
part 'widgets/message/message.dart';

part 'widgets/parameter/parameter_view.dart';
part 'widgets/parameter/parameter.dart';

part 'widgets/pages/about_page.dart';
part 'widgets/pages/debug_page.dart';
part 'widgets/pages/home_page.dart';
part 'widgets/pages/huggingface_page.dart';
part 'widgets/pages/settings_page.dart';

part 'widgets/settings/artificial_intelligence_settings.dart';
part 'widgets/settings/assistant_settings.dart';
part 'widgets/settings/system_settings.dart';
part 'widgets/settings/user_settings.dart';

part 'widgets/text_fields/api_key_text_field.dart';
part 'widgets/text_fields/base_url_text_field.dart';
part 'widgets/text_fields/listenable_text_field.dart';
part 'widgets/text_fields/prompt_field.dart';
part 'widgets/text_fields/remote_model_text_field.dart';

part 'widgets/utilities/code_box.dart';
part 'widgets/utilities/huggingface_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Maid());
}

class Maid extends StatefulWidget {
  const Maid({super.key});

  @override
  State<Maid> createState() => MaidState();
}

class MaidState extends State<Maid> {
  @override
  void initState() {
    super.initState();
    
    AIController.load();
  }

  static ThemeData getTheme(ColorScheme colorScheme) {
    final appBarTheme = AppBarTheme(
      elevation: 0.0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent, 
    );

    final inputDecorationTheme = InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0, 
        vertical: 15.0
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: appBarTheme,
      inputDecorationTheme: inputDecorationTheme
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AppSettings.instance,
    builder: buildApp
  );

  Widget buildApp(BuildContext context, Widget? child) => MaterialApp(
    title: 'Maid',
    theme: getTheme(ColorScheme.fromSeed(seedColor: AppSettings.instance.seedColor, brightness: Brightness.light)),
    darkTheme: getTheme(ColorScheme.fromSeed(seedColor: AppSettings.instance.seedColor, brightness: Brightness.dark)),
    themeMode: AppSettings.instance.themeMode,
    home: HomePage(),
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    routes: {
      '/settings': (context) => SettingsPage(),
      '/chat': (context) => HomePage(),
      '/about': (context) => const AboutPage(),
      '/huggingface': (context) => HuggingFacePage(),
      if (kDebugMode) '/debug': (context) => DebugPage(),
    },
    supportedLocales: AppLocalizations.supportedLocales,
    locale: AppSettings.instance.locale,
    debugShowCheckedModeBanner: false,
  );
}