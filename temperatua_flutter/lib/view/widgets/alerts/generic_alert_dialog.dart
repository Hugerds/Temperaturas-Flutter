import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/core/utils/cores_aplicativo.dart';

class GenericAlertDialog extends StatefulWidget {
  final String titulo;
  final String descricao;
  final Color? color;
  final void Function()? onPressed;
  const GenericAlertDialog(
      {Key? key,
      required this.titulo,
      required this.descricao,
      this.color,
      this.onPressed})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<GenericAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.descricao,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 2.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: widget.color ?? CoresAplicativo().fundoLoading),
              onPressed: widget.onPressed ??
                  () {
                    Get.back();
                  },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
