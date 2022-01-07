import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:temperatua_flutter/controller/app_controller.dart';
import 'package:temperatua_flutter/core/utils/cores_aplicativo.dart';
import 'package:temperatua_flutter/view/widgets/error_app_widget.dart';
import 'package:temperatua_flutter/view/widgets/loading_widget.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late AppController appController;
  @override
  void initState() {
    appController = Get.put(AppController(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: CoresAplicativo().fundoLoading,
          body: Center(
            child: Obx(
              () => Visibility(
                visible: appController.isError.value,
                child: const ErrorAppWidget(),
                replacement: const LoadingWidget(),
              ),
            ),
          )),
    );
  }
}
