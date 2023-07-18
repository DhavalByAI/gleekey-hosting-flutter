import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/services/firebase_pushNotification_service.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/shared_Preference/preferences_helper.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/getUserController.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // @override
  // Widget build(BuildContext context) {
  //   return EasySplashScreen(
  //     showLoader: false,
  //     logoWidth: MediaQuery.of(context).size.width * 0.7,
  //     logo: Image.asset(
  //       "assets/images/spalsh.png",
  //       width: MediaQuery.of(context).size.width * 0.7,
  //     ),
  //     backgroundColor: kmatblack,
  //     navigator:
  //     durationInSeconds: 3,
  //   );
  // }
  Future getToken() async {
    PrefController.to.token.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.Token) ??
        '-';
    PrefController.to.user_id.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.user_id) ??
        '-';
    print('STORED TOKEN ${PrefController.to.token.value}');
    print('STORED USER ID ${PrefController.to.user_id.value}');

    if ((PrefController.to.token.value != '' &&
        PrefController.to.token.value != '-')) {
      await GetUserController.to.getUserApi();
      PushNotificationService().setUpInterractedMassage();
    }
  }

  @override
  initState() {
    getToken().then(
      (value) => Timer(
        const Duration(seconds: 3),
        () {
          Get.offAll(
            () => (PrefController.to.token.value != '' &&
                    PrefController.to.token.value != '-')
                ? (((user_model?.data?.userAgent ?? 0) != 1) ||
                        ((user_model?.data?.userHost ?? 0) != 0))
                    ? MainScreen()
                    : AgentMainScreen()
                : const Login(),
          );
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kmatblack,
      body: Center(
        child: Image.asset(
          "assets/images/spalsh.png",
          width: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}
