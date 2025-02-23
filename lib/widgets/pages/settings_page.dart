part of 'package:maid/main.dart';

class SettingsPage extends StatelessWidget {
  final ArtificialIntelligenceController aiController;
  final ChatController chatController;
  final AppSettings settings;
  
  const SettingsPage({
    super.key, 
    required this.aiController, 
    required this.chatController,
    required this.settings
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: buildBody(context),
    )
  );

  Widget buildBody(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ArtificialIntelligenceDropdown(aiController: aiController),
      ArtificialIntelligenceSettings(aiController: aiController),
      Divider(endIndent: 0, indent: 0, height: 32),
      OverrideView(aiController: aiController),
      Divider(endIndent: 0, indent: 0, height: 32),
      UserSettings(settings: settings),
      Divider(endIndent: 0, indent: 0, height: 32),
      AssistantSettings(settings: settings),
      Divider(endIndent: 0, indent: 0, height: 32),
      SystemSettings(settings: settings),
      Divider(endIndent: 0, indent: 0, height: 32),
      buildResetRow(context)
    ],
  );

  Widget buildResetRow(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    runAlignment: WrapAlignment.center,
    spacing: 16,
    runSpacing: 16,
    children: [
      ElevatedButton(
        onPressed: chatController.clearChats, 
        child: const Text('Clear Chats')
      ),
      ElevatedButton(
        onPressed: settings.clear, 
        child: const Text('Reset Settings')
      ),
      ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        }, 
        child: const Text('Clear Cache')
      )
    ],
  );
}