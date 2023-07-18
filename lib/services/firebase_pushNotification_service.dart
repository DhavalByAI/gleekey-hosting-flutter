import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/agent/agent_menu/agent_transaction_screen.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/all_reservation_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/src/host/setting/transaction_history.dart';

import '../src/host/menu/view/all_listing/all_listing_screen.dart';

class PushNotificationService {
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // Get.to(() => TransactionHistoryScreen());
    // });
    enableIOSNotifications();
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/app_logo');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings initSettings = const InitializationSettings(
        android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        log('${details.payload}', name: 'NOTIFICATION TAP');
        log(PrefController.to.token.value, name: 'NOTIFICATION TAP');
        if (PrefController.to.token.value != '-' &&
            PrefController.to.token.value != '') {
          if ((details.payload ?? '').contains('kyc')) {
            Get.to(() => KycScreen());
          } else if ((details.payload ?? '').contains('Transaction')) {
            Get.to(() => (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? const TransactionHistoryScreen()
                : const AgentTransactionScreen());
          } else if ((details.payload ?? '').contains('Property')) {
            log('Condition true');

            (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? Get.to(() => AllListingScreen(
                      type: 'All',
                    ))
                : agentSelectedBottom.value =
                    1 /*Get.to(() => const AgentProperties())*/;
          } else if ((details.payload ?? '').contains('Booking')) {
            log('Condition true');

            (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? Get.to(() => const AllreservationScreen())
                : agentSelectedBottom.value =
                    2 /* Get.to(() => const AgentUserBookingScreen())*/;
          }
        }
      },
      /*    onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse details) {
        log('${jsonDecode(details.toString())}', name: 'NOTIFICATION BG TAP');
        //
        // if (PrefController.to.token.value != '-' &&
        //     PrefController.to.token.value != '') {
        */ /*if ((details.payload ?? '').contains('kyc')) {
        Get.to(() => const KycScreen());
      } else if ((details.payload ?? '').contains('Transaction')) {
        Get.to(() => const TransactionHistoryScreen());
      }*/ /*
        // }
      },*/
    );

// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage? message) {
        // homeController.getHomeData(
        //   withLoading: false,
        // );

        log(message.toString(), name: 'onMessage');
        final RemoteNotification? notification = message!.notification;
        final AndroidNotification? android = message.notification?.android;
        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            payload: notification.title ?? '',
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> setUpInterractedMassage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log('initial message ${initialMessage.data['title'].toString()}',
          name: 'onMessageOpenedApp MSG');
      if ((PrefController.to.token.value != '' &&
          PrefController.to.token.value != '-')) {
        if (initialMessage.data.containsKey('title') &&
            initialMessage.data['title'].toString().contains('kyc')) {
          Get.to(() => KycScreen());
        } else if (initialMessage.data.containsKey('title') &&
            initialMessage.data['title'].toString().contains('Transaction')) {
          Get.to(() => (((user_model?.data?.userAgent ?? 0) != 1) ||
                  ((user_model?.data?.userHost ?? 0) != 0))
              ? const TransactionHistoryScreen()
              : const AgentTransactionScreen());
        } else if (initialMessage.data.containsKey('title') &&
            initialMessage.data['title'].toString().contains('Property')) {
          log('condition true');

          (((user_model?.data?.userAgent ?? 0) != 1) ||
                  ((user_model?.data?.userHost ?? 0) != 0))
              ? Get.to(() => AllListingScreen(
                    type: 'All',
                  ))
              : agentSelectedBottom.value =
                  1 /*Get.to(() => const AgentProperties())*/;
        } else if (initialMessage.data.containsKey('title') &&
            initialMessage.data['title'].toString().contains('Booking')) {
          log('condition true');

          (((user_model?.data?.userAgent ?? 0) != 1) ||
                  ((user_model?.data?.userHost ?? 0) != 0))
              ? Get.to(() => const AllreservationScreen())
              : agentSelectedBottom.value =
                  2 /* Get.to(() => const AgentUserBookingScreen())*/;
        }
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        log('initial message ${event.data['title'].toString()}',
            name: 'onMessageOpenedApp MSG');
        if ((PrefController.to.token.value != '' &&
            PrefController.to.token.value != '-')) {
          if (event.data.containsKey('title') &&
              event.data['title'].toString().contains('kyc')) {
            Get.to(() => KycScreen());
          } else if (event.data.containsKey('title') &&
              event.data['title'].toString().contains('Transaction')) {
            Get.to(() => (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? const TransactionHistoryScreen()
                : const AgentTransactionScreen());
          } else if (event.data.containsKey('title') &&
              event.data['title'].toString().contains('Property')) {
            log('condition true');

            (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? Get.to(() => AllListingScreen(
                      type: 'All',
                    ))
                : agentSelectedBottom.value =
                    1 /*Get.to(() => const AgentProperties())*/;
          } else if (event.data.containsKey('title') &&
              event.data['title'].toString().contains('Booking')) {
            log('condition true');

            (((user_model?.data?.userAgent ?? 0) != 1) ||
                    ((user_model?.data?.userHost ?? 0) != 0))
                ? Get.to(() => const AllreservationScreen())
                : agentSelectedBottom.value =
                    2 /* Get.to(() => const AgentUserBookingScreen())*/;
          }
        }
      },
    );
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
}
