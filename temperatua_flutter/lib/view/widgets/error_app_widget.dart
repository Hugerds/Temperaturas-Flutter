import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../app_view.dart';
import 'botao_padrao_widget.dart';

class ErrorAppWidget extends StatelessWidget {
  const ErrorAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            "Algo deu errado!\nTente novamente!",
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
            height: 30.w,
            width: 30.w,
            child: Image.asset(
              'lib/core/assets/images/iconError.png',
              fit: BoxFit.fill,
              color: Colors.white,
            )),
        SizedBox(height: 2.h),
        BotaoPadraoWidget(
          textoBotao: "RECARREGAR",
          height: 6.h,
          onPressed: () => Get.offAll(const AppView()),
        )
      ],
    );
  }
}
