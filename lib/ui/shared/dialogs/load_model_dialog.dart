import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maid/classes/providers/large_language_models/llama_cpp_model.dart';
import 'package:maid/ui/shared/dialogs/loading_dialog.dart';
import 'package:maid/ui/shared/dialogs/storage_operation_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadModelDialog extends StatefulWidget {
  const LoadModelDialog({super.key});

  @override
  State<StatefulWidget> createState() => _LoadModelDialogState();
}

class _LoadModelDialogState extends State<LoadModelDialog> {
  Future<String>? loadingFuture;
  Map<String, String>? importedModels;
  String? selected;
  bool dropdownOpen = false;

  Future<Map<String, String>> get previouslyLoadedModels async {
    final prefs = await SharedPreferences.getInstance();

    final models = prefs.getString("imported_models") ?? "{}";

    return json.decode(models);
  }

  @override
  void dispose() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("imported_models", json.encode(importedModels ?? {}));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFuture != null) {
      return StorageOperationDialog(
        future: loadingFuture!,
        onComplete: (_) {
          importedModels ??= {};

          final key = LlamaCppModel.of(context).name;

          if (importedModels![key] != null) {
            File(importedModels![key]!).delete();
          }

          importedModels![key] = LlamaCppModel.of(context).uri;
        },
      );
    }
    else {
      return FutureBuilder<Map<String, String>>(
        future: previouslyLoadedModels,
        builder: buildDialog,
      );
    }
  }

  Widget buildDialog(BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      importedModels = snapshot.data;

      return AlertDialog(
        title: const Text(
          "LlamaCPP Models",
          textAlign: TextAlign.center
        ),
        content: buildDropdown(),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              loadingFuture = LlamaCppModel.of(context).loadModel();
              Navigator.of(context).pop();
            },
            child: Text(
              "Import",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          if (selected != null) ...importedOptions,
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      );
    } 
    else {
      return const LoadingDialog(title: "Loading Models");
    }
  }

  List<Widget> get importedOptions {
    return [
      FilledButton(
        onPressed: () {
          LlamaCppModel.of(context).name = selected!;
          LlamaCppModel.of(context).uri = importedModels![selected!]!;
          Navigator.of(context).pop();
        },
        child: Text(
          "Select",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      FilledButton(
        onPressed: () {
          File(importedModels![selected!]!).delete();
          Navigator.of(context).pop();
        },
        child: Text(
          "Delete",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    ];
  }

  Widget buildDropdown() {
    return Row(
      children: [
        Text(selected ?? "Select Model"),
        PopupMenuButton(
          tooltip: "Select Model",
          icon: Icon(
            dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          offset: const Offset(0, 40),
          itemBuilder: itemBuilder,
          onOpened: () => setState(() => dropdownOpen = true),
          onCanceled: () => setState(() => dropdownOpen = false),
          onSelected: (_) => setState(() => dropdownOpen = false)
        ),
      ],
    );
  }

  List<PopupMenuEntry<dynamic>> itemBuilder(BuildContext context) {
    return importedModels!.entries.map((entry) {
      return PopupMenuItem(
        value: entry.key,
        child: Text(entry.key),
        onTap: () => setState(() => selected = entry.key),
      );
    }).toList();
  }
}