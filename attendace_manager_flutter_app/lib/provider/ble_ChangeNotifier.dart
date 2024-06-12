import 'package:attendace_manager_flutter_app/data/ble_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_ble/universal_ble.dart';

class BleChangeNotifier extends ChangeNotifier
{
  BleController bleController=BleController();

  void BleScan() {
    bleController.scanDevices();
    bleController.scanResult.listen((List<ScanResult> scanResults) {
      for (ScanResult sr in scanResults) {
        print("Scan device: ${sr.device.name}");
      }
    }, onError: (e) {
      print("ble_error: ${e.toString()}");
    });
  }
  void enableBluetooth()
  {
    bleController.enableBluetooth();
  }
  void enableBluetoothVisibility() async
  {
    await bleController.makeDeviceDiscoverable();
  }
  void UniversalBleScan() async
  {
    if(!kIsWeb)
      {
        UniversalBle.enableBluetooth();
        if(await Permission.bluetoothScan.request().isGranted)
          {
            if(await Permission.bluetoothConnect.request().isGranted)
              {
                if (await UniversalBle.getBluetoothAvailabilityState() == AvailabilityState.poweredOn) {
                  await bleController.ble.stopScan();
                  await bleController.ble.startScan(allowDuplicates: true);
                  await bleController.ble.stopScan();
                  await bleController.ble.startScan(timeout: const Duration(minutes: 2),scanMode: ScanMode.lowLatency);


                  // await UniversalBle.stopScan();
                  // await UniversalBle.startScan();
                  // UniversalBle.onScanResult=(BleScanResult scanResult) async
                  // {
                  //   print("scanning");
                  //   print(scanResult.name);
                  //   await Future.delayed(Duration(minutes: 5));
                  //   UniversalBle.stopScan();
                  // };
                }
              }
          }
      }
  }
  void printScanResult()
  {
    print("\n\nCALL FOR PRINT\n\n");
    bleController.ble.scanResults.listen(
            (scanResults) {
              List noDup = scanResults.toSet().toList();
              print("\n\n!!!!!!!!!!!!!!!!!!!!!!!!!NEW PRINT!!!!!!!!!!!!!!!!!!!!!!!\n\n");
              for (ScanResult sr in noDup) {
                print(
                    "\n-----------------------------------------------------------------------\n");
                print("Scan_result name: " + sr.device.name );
                print("Scan_result id: " + sr.device.id.toString());
                print("Scan_result type: " + sr.device.type.toString());
                print(
                    "\n-----------------------------------------------------------------------\n");
              }
            }
    );
  }
}