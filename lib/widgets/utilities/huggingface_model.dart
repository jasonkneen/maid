part of 'package:maid/main.dart';

class HuggingfaceModel extends StatefulWidget {
  final String name;
  final String repo;
  final String branch;
  final String fileName;
  final double size;
  final double parameters; // Billions of parameters

  const HuggingfaceModel({
    super.key, 
    required this.name, 
    required this.repo,
    this.branch = 'main',
    required this.fileName,
    required this.size, 
    required this.parameters
  });

  @override
  State<HuggingfaceModel> createState() => HuggingfaceModelState();
}

class HuggingfaceModelState extends State<HuggingfaceModel> {
  double progress = 0;

  Future<String> getFilePath() async {
    final cache = await getApplicationCacheDirectory();
    return '${cache.path}/${widget.fileName}';
  }

  void downloadModel() async {
    setState(() => progress = 0);

    final filePath = await getFilePath();

    await Dio().download(
      "https://huggingface.co/${widget.repo}/resolve/${widget.branch}/${widget.fileName}?download=true",
      filePath,
      onReceiveProgress: (received, total) {
        if (total == -1) return;
        setState(() => progress = received / total);
      },
    );
  }

  void deleteModel() async {
    final filePath = await getFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      setState(() => progress = 0);
    }
  }

  void navigateRepo() async {
    final url = Uri.parse('https://huggingface.co/${widget.repo}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceBright,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: buildColumn(context),
  );

  Widget buildColumn(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTitle(context),
      Text(
        '${AppLocalizations.of(context)!.size}: ${widget.size.toString()} GB',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      Text(
        '${AppLocalizations.of(context)!.parameters}: ${widget.parameters.toString()} B',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      buildProgressIndicator(context),
      progress == 1
        ? buildActionsRow(context)
        : buildDownloadButton(context),
    ],
  );

  Widget buildDownloadButton(BuildContext context) => Center(
    child: TextButton.icon(
      onPressed: progress == 0 ? downloadModel : null,
      label: Text(
        AppLocalizations.of(context)!.downloadModel,
        style: progress == 0
          ? Theme.of(context).textTheme.labelMedium
          : Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
      ),
      icon: Icon(
        Icons.download,
        color: progress == 0
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.outline,
      ),
    )
  );

  Widget buildActionsRow(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      TextButton.icon(
        onPressed: deleteModel,
        label: Text(
          AppLocalizations.of(context)!.delete,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      )
    ],
  );

  Widget buildProgressIndicator(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: LinearProgressIndicator(
      value: progress,
      minHeight: 5,
      borderRadius: BorderRadius.circular(5),
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.outline,
    )
  );

  Widget buildTitle(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: navigateRepo,
          iconSize: 20,
          icon: Icon(
            Icons.launch,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        )
      ],
    )
  );
}