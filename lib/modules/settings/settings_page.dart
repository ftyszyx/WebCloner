import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/modules/settings/settings_controller.dart';
import 'package:web_cloner/l10n/app_localizations.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.language,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: controller.locale.value,
              items: const [
                DropdownMenuItem(value: 'zh', child: Text('中文')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (v) {
                if (v == null) return;
                controller.setLocale(v);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.outputDir,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: controller.outputDir.value,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () => controller.chooseOutputDir(),
                  tooltip: l10n.chooseDir,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
