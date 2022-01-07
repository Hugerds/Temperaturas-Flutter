import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'lib/core/assets/gifs/loadingGif2.gif',
        fit: BoxFit.fill,
      ),
    );
  }
}
