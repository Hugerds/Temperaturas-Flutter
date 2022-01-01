import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/controller/initial_controller.dart';

class InitialView extends StatefulWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  late InitialController initialController;
  @override
  void initState() {
    initialController = Get.put(InitialController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        child: SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: initialController.position != null,
                    child: Text(
                      initialController.txtPosition.value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (initialController.txtTemperatura.trim().isNotEmpty)
                    Text(initialController.txtTemperatura.value + " °C"),
                  if (initialController.txtAmanhecer.trim().isNotEmpty)
                    Text("Amanhecer: " + initialController.txtAmanhecer.value),
                  if (initialController.txtAnoitecer.trim().isNotEmpty)
                    Text("Anoitecer: " + initialController.txtAnoitecer.value),
                  ElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) {
                        await initialController.getAddressFromLatLng();
                      }
                    },
                    child: const Text("Apertar"),
                  ),
                  if (initialController.txtTemperatura.trim().isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              initialController.temperatura?.forecast?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Column(
                                children: [
                                  Text("Dia: " +
                                      initialController
                                          .temperatura!.forecast![index].date),
                                  Text("Mínima: " +
                                      initialController
                                          .temperatura!.forecast![index].min
                                          .toString() +
                                      " °C" +
                                      " | " +
                                      "Máxima: " +
                                      initialController
                                          .temperatura!.forecast![index].max
                                          .toString() +
                                      " °C"),
                                  const Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
