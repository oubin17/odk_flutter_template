import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      // 获取Android设备信息
      var androidInfo = await _deviceInfo.androidInfo;
      _deviceData = {
        "机型": androidInfo.model,
        "系统版本": androidInfo.version.release,
        "设备ID": androidInfo.id,
        "品牌": androidInfo.brand,
      };
    } else if (Platform.isIOS) {
      // 获取iOS设备信息
      var iosInfo = await _deviceInfo.iosInfo;
      _deviceData = {
        "机型": iosInfo.utsname.machine,
        "系统版本": iosInfo.systemVersion,
        "设备UUID": iosInfo.identifierForVendor,
        "系统名称": iosInfo.systemName,
      };
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设备信息")),
      body: _deviceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _deviceData.entries.map((e) {
                return ListTile(title: Text("${e.key}：${e.value}"));
              }).toList(),
            ),
    );
  }
}
