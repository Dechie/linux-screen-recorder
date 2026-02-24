import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/settings_model.dart';
import 'recorder_controller.dart';
import 'recorder_service.dart';
import 'recorder_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize settings model
  final settings = SettingsModel();
  await settings.ready;
  final recorderService = RecorderService();
  final detectedAudioDevice = await recorderService.getRecommendedAudioDevice();
  await settings.updateAudioDevice(detectedAudioDevice);
  final displayResolution = await recorderService.getDisplayResolution();
  settings.updateDisplayResolution(
    displayResolution['width'] ?? 1920,
    displayResolution['height'] ?? 1080,
  );

  // Set up default save path
  final videosDir = Directory(
    '${Platform.environment['HOME']}/Videos/ScreenRecordings',
  );

  // Check if directory exists, if not, we'll handle it in the app
  final bool dirExists = await videosDir.exists();
  if (dirExists) {
    await settings.updateSavePath(videosDir.path);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(
          create: (_) => RecorderController(recorderService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RecorderApp(
          initialPathCheck: true,
          initialPath:
              '${Platform.environment['HOME']}/Videos/ScreenRecordings',
        ),
      ),
    ),
  );
}
