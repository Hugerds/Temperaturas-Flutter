import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/controller/temperatura_view_widget_controller.dart';
import 'package:temperatua_flutter/model/temperatura.dart';

class TemperaturaViewWidget extends StatefulWidget {
  final Temperatura temperatura;
  final Placemark place;
  final Color backgroundColor;
  final Color fontColor;
  const TemperaturaViewWidget(
      {Key? key,
      required this.temperatura,
      required this.place,
      required this.backgroundColor,
      required this.fontColor})
      : super(key: key);

  @override
  _TemperaturaViewWidgetState createState() => _TemperaturaViewWidgetState();
}

class _TemperaturaViewWidgetState extends State<TemperaturaViewWidget> {
  late TemperaturaViewWidgetController initialController;
  @override
  void initState() {
    initialController = Get.put(
        TemperaturaViewWidgetController(widget.temperatura, widget.place));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              Container(
                color: widget.backgroundColor,
                height: 60.h,
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "ATUALMENTE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23.sp,
                                      color: widget.fontColor),
                                ),
                                Text(initialController.txtPosition.value,
                                    style: TextStyle(color: widget.fontColor)),
                              ],
                            ),
                            Icon(
                              initialController.temperatura.iconCondition,
                              color: Colors.white,
                              size: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.thermostat,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      initialController.txtTemperatura.value +
                                          " °C",
                                      style: TextStyle(
                                          color: widget.fontColor,
                                          fontSize: 17.sp),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.wind,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text(
                                        initialController
                                            .txtVelocidadeVento.value,
                                        style: TextStyle(
                                            color: widget.fontColor,
                                            fontSize: 17.sp))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: initialController.temperatura.forecast?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: index % 2 == 1
                            ? Colors.grey.shade300
                            : Colors.white,
                        title: Padding(
                          padding: EdgeInsets.only(left: 2.w, right: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Icon(
                                      initialController.temperatura
                                          .forecast![index].iconCondition,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        initialController.temperatura
                                                .forecast![index].dayWeek +
                                            " - " +
                                            initialController.temperatura
                                                .forecast![index].date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                        initialController.temperatura
                                                .forecast![index].max
                                                .toString() +
                                            " °" +
                                            " / " +
                                            initialController.temperatura
                                                .forecast![index].min
                                                .toString() +
                                            " °",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800]))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
            backgroundColor: widget.backgroundColor,
            onPressed: initialController.onPressedBtnPesquisar,
            child: const Icon(FontAwesomeIcons.search)),
      ),
    );
  }
}
