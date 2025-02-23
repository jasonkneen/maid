part of 'package:maid/main.dart';

class SharingDialog extends StatelessWidget {
  final AppSettings settings;
  final SharedMediaFile file;

  const SharingDialog({
    super.key,
    required this.settings,
    required this.file,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      'Content Shared',
      textAlign: TextAlign.center,
    ),
    content: buildImageShare(),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowAlignment: OverflowBarAlignment.center,
    actions: buildActions(context),
  );

  Widget buildImageShare() => ClipRRect(
    borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
    child: Image.file(
      File(file.path),
      height: 400,
      fit: BoxFit.cover,
    ),
  );

  List<Widget> buildActions(BuildContext context) => [
    TextButton(
      onPressed: () {
        settings.userImage = File(file.path);
        Navigator.of(context).pop();
      }, 
      child: Text('Set User Image')
    ),
    TextButton(
      onPressed: () {
        settings.assistantImage = File(file.path);
        Navigator.of(context).pop();
      }, 
      child: Text('Set Assistant Image')
    ),
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('Cancel'),
    ),
  ];
}