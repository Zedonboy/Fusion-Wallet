/// Copyright (C) 2025 Fusion Wallet
///
/// This file is part of Fusion Wallet.
///
/// Fusion Wallet is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Fusion Wallet is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
library;

import 'package:flutter/material.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class UpdateChecker {
  // GitHub API endpoint for releases

  /// Checks if there's a new version available
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      if (!version.startsWith("git")) {
        return;
      }

      final versionCode = version.split("-")[1];
      final currentVersion = Version.parse(versionCode);

      // Fetch latest release from GitHub
      final response =
          await WalletContext.createHttpService().getLatestRelease();
      print("latest ${response.tagName}");

      final latestVersion =
          Version.parse(response.tagName.replaceFirst("v", ""));

      print("latest ${response.tagName}");
      // Compare versions
      if (latestVersion > currentVersion) {
        // Show update dialog if not in a dialog already
        if (context.mounted) {
          showUpdateDialog(
            context,
            currentVersion: currentVersion.toString(),
            newVersion: latestVersion.toString(),
            releaseUrl: response.htmlUrl,
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  /// Shows the update dialog
  static void showUpdateDialog(
    BuildContext context, {
    required String currentVersion,
    required String newVersion,
    required String releaseUrl,
  }) {
    showDialog(
      context: context,
      builder: (context) => UpdateDialog(
        currentVersion: currentVersion,
        newVersion: newVersion,
        releaseUrl: releaseUrl,
      ),
    );
  }
}

class UpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String newVersion;
  final String releaseUrl;

  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.newVersion,
    required this.releaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Available'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A new version is available!'),
          const SizedBox(height: 8),
          Text(
            'Current version: $currentVersion\nNew version: $newVersion',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Later'),
        ),
        FilledButton(
          onPressed: () async {
            final url = Uri.parse(releaseUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
