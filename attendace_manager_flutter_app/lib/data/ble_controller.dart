import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:flutter/services.dart';

class BleController extends GetxController{
  FlutterBlue ble=FlutterBlue.instance;

  Future scanDevices() async
  {
    if(kIsWeb)
      {
        throw new Exception("Running on Web");
      }
    enableBluetooth();
    if(await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        // while(!await ble.isOn)
        //   {
        //     openBluetoothSettings();
        //     await Future.delayed(Duration(seconds: 1));
        //   }
        print("BLE 1 is Scanning");
        ble.startScan(timeout: const Duration(microseconds: 1));
        ble.stopScan();

        print("BLE 2 is Scanning");
        ble.startScan(timeout: const Duration(minutes: 5));
        ble.stopScan();
      }
    }
  }
  // Future<void> requestDiscoverable() async {
  //   try {
  //     await MethodChannel('plugins.flutter.io/intent').invokeMethod(
  //       'startActivity',
  //       <String, dynamic>{
  //         'action': 'android.bluetooth.adapter.action.REQUEST_DISCOVERABLE',
  //         'extra': <String, dynamic>{'android.bluetooth.adapter.extra.DISCOVERABLE_DURATION': 300},
  //       },
  //     );
  //   } on PlatformException catch (e) {
  //     print("Error requesting discoverable: $e");
  //   }
  // }

  Future<void> makeDeviceDiscoverable() async {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.bluetooth.adapter.action.REQUEST_DISCOVERABLE',
      arguments: <String, dynamic>{
        'android.bluetooth.adapter.extra.DISCOVERABLE_DURATION': 3600
      },
    );
    await intent.launch();
  }
  Future<void> openBluetoothSettings() async {
    if (!await ble.isOn){
      final intent = AndroidIntent(
        action: 'android.settings.BLUETOOTH_SETTINGS',
        package: 'com.android.settings',
        componentName: 'com.android.settings.bluetooth.BluetoothSettings',
        flags: <int>[
          Flag.FLAG_ACTIVITY_NEW_TASK,
          Flag.FLAG_ACTIVITY_CLEAR_TASK,
        ],
      );
      await intent.launch();
    }
  }
  Future<void> enableBluetooth() async {
    final status = await Permission.bluetooth.status;
    while (!status.isGranted) {
      await Permission.bluetooth.request();
    }
  }
  Stream<List<ScanResult>> get scanResult=> ble.scanResults;
}