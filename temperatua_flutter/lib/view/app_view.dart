import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/controller/app_controller.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late AppController appController;
  @override
  void initState() {
    appController = Get.put(AppController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          body: Center(
            child: SizedBox(
              height: 20.w,
              width: 20.w,
              child: const CircularProgressIndicator(),
            ),
          )),
    );
  }
}
