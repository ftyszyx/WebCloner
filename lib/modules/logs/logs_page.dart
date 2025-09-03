import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/services/logger.dart';
import 'package:web_cloner/l10n/app_localizations.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.logs)),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: Log.debugLogs.length,
          itemBuilder: (context, index) {
            final item = Log.debugLogs[index];
            return ListTile(
              dense: true,
              title: Text(
                item.content,
                style: TextStyle(color: item.color ?? Colors.white),
              ),
              subtitle: Text(
                item.datetime.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
