import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/quickalert.dart';

dynamic quickAlert(
    {required BuildContext context,
    required String title,
    String? message,
    required QuickAlertType type}) {
  return QuickAlert.show(
    context: context,
    text: message,
    animType: QuickAlertAnimType.slideInDown,
    type: type,
    confirmBtnColor: Constant.blue2Color,
    title: title,
    confirmBtnText: "OK",
    autoCloseDuration: const Duration(seconds: 2),
    showConfirmBtn: true,
  );
}
