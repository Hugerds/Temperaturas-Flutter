import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/core/utils/cores_aplicativo.dart';

class BotaoPadraoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final String textoBotao;
  const BotaoPadraoWidget(
      {Key? key,
      this.height,
      this.width,
      this.onPressed,
      this.backgroundColor,
      required this.textoBotao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? 5.h,
        width: width ?? 70.w,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? CoresAplicativo().pretoOpacidade),
          ),
          child: Text(
            textoBotao,
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
