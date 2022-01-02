import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/controller/mapa_controller.dart';

class MapaView extends StatefulWidget {
  final double latitude;
  final double longitude;
  const MapaView({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  _MapaViewState createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  late MapaController mapaController;
  @override
  void initState() {
    mapaController = Get.put(MapaController(widget.latitude, widget.longitude));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: IgnorePointer(
          ignoring: mapaController.carregando.value,
          child: Scaffold(
            backgroundColor: Colors.grey.shade400,
            body: Stack(
              children: [
                Visibility(
                  visible: !mapaController.carregando.value,
                  child: GetBuilder<MapaController>(
                    id: 'mapa',
                    init: mapaController,
                    builder: (MapaController controller) {
                      return GoogleMap(
                          onTap: (LatLng position) =>
                              mapaController.onTapMap(position),
                          markers: mapaController.markers,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(widget.latitude, widget.longitude),
                              zoom: 15.0));
                    },
                  ),
                  replacement: Center(
                    child: SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.w, top: 2.h),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Center(
                      child: SizedBox(
                        height: 5.h,
                        width: 70.w,
                        child: ElevatedButton(
                          onPressed: mapaController.onPressedTemperatura,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.5)),
                          ),
                          child: Text(
                            "BUSCAR TEMPERATURA",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
