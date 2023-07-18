import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/calendar/controller/get_price_controller.dart';
import 'package:gleeky_flutter/src/host/calendar/controller/manage_calendar_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class calander extends StatefulWidget {
  final String property_Id;
  final String property_Price;

  const calander({
    Key? key,
    required this.property_Id,
    required this.property_Price,
  }) : super(key: key);

  @override
  State<calander> createState() => _calanderState();
}

class _calanderState extends State<calander> {
  RxString selectedDays = ''.obs;
  final CalendarController _calendarController = CalendarController();
  @override
  void initState() {
    // TODO: implement initState
    log(widget.property_Id, name: 'PROPERTY ID');
    GetPriceController.to.get_property_calender_price_Api(
        params: {
          "property_id": widget.property_Id,
          "year": DateTime.now().year,
          "month": DateTime.now().month
        },
        error: (e) {
          loaderHide();
        },
        success: () {
          loaderHide();
        });
    super.initState();
  }

  final TextEditingController _startDate = TextEditingController();
  DateTime? _startDateTime;
  final TextEditingController _endDate = TextEditingController();
  DateTime? _endDateTime;
  final TextEditingController _price = TextEditingController();
  final TextEditingController _minStay = TextEditingController(text: '0');

  List Status = ['-- Please Select --', 'Available', 'Not available'];
  RxString statusValue = '-- Please Select --'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorFE6927,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        centerTitle: true,
        title: const Text('Calendar'),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.colorffffff)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return GetPriceController.to.get_property_calender_priceRes.isEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      /* Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.colorFE6927,
                        ),
                      ),
                      child: Theme(
                        data: ThemeData(
                            primaryColor: AppColors.colorFE6927,
                            unselectedWidgetColor: AppColors.colorFE6927,
                            primarySwatch: Colors.deepOrange),
                        child: SfDateRangePicker(
                          showActionButtons: true,
                          onSubmit: (value) {
                            if (value is PickerDateRange) {
                              selectedDays.value = (value.endDate!
                                          .difference(value.startDate!)
                                          .inDays +
                                      1)
                                  .toString();
                              Get.to(
                                () => PricingCalenderScreen(
                                  selectedDays: selectedDays.value,
                                  startDate: value.startDate!,
                                  endDate: value.endDate!,
                                  property_id: widget.property_Id,
                                ),
                              );
                            } else {
                              showSnackBar(
                                title: ApiConfig.error,
                                message: 'Select the date',
                              );
                            }
                          },
                          onCancel: () {
                            Get.back();
                          },
                          selectionColor: AppColors.colorFE6927,
                          todayHighlightColor: const Color(0xffFE6927),
                          enablePastDates: false,
                          initialDisplayDate: DateTime.now(),
                          monthViewSettings: const DateRangePickerMonthViewSettings(
                            blackoutDates: [
                              // DateTime(2022, 12, 29),
                              // DateTime(2023, 1, 2),
                              // DateTime(2023, 1, 3),
                            ],
                          ),
                          minDate: DateTime.now(),
                          rangeSelectionColor:
                              AppColors.colorFE6927.withOpacity(0.1),
                          endRangeSelectionColor: AppColors.colorFE6927,
                          startRangeSelectionColor: AppColors.colorFE6927,
                          selectionMode: DateRangePickerSelectionMode.range,
                        ),
                      ),
                    ),
                  ),*/
                      SizedBox(
                        height: 560,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              /* border: Border.all(
                                color: AppColors.colorFE6927,
                              ),*/
                              color: AppColors.colorffffff,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData(
                                primaryColor: AppColors.colorFE6927,
                                unselectedWidgetColor: AppColors.colorFE6927,
                                primarySwatch: Colors.deepOrange,
                              ),
                              child: SfCalendar(
                                view: CalendarView.month,
                                headerHeight: 60,
                                headerStyle: CalendarHeaderStyle(
                                  textAlign: TextAlign.center,
                                  textStyle: color00000s15w600,
                                ),
                                viewHeaderStyle: ViewHeaderStyle(
                                  backgroundColor:
                                      AppColors.colorFE6927.withOpacity(0.2),
                                  dayTextStyle: color00000s12w600,
                                ),
                                initialSelectedDate: DateTime.now(),
                                minDate: DateTime.now(),
                                maxDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 45),
                                onViewChanged: (viewChangedDetails) {
                                  loaderShow(context);

                                  GetPriceController.to
                                      .get_property_calender_price_Api(
                                          params: {
                                        "property_id": widget.property_Id,
                                        "year": viewChangedDetails
                                            .visibleDates.first.year,
                                        "month": viewChangedDetails
                                            .visibleDates.first.month
                                      },
                                          error: (e) {
                                            loaderHide();
                                          },
                                          success: () {
                                            loaderHide();
                                          });
                                },
                                cellBorderColor:
                                    AppColors.colorFE6927.withOpacity(0.5),
                                monthViewSettings: MonthViewSettings(
                                  showAgenda: false,
                                  showTrailingAndLeadingDates: false,
                                  dayFormat: 'EEE',
                                  monthCellStyle: MonthCellStyle(
                                    leadingDatesBackgroundColor:
                                        AppColors.color000000,
                                    trailingDatesBackgroundColor:
                                        AppColors.color000000,
                                  ),
                                ),
                                selectionDecoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.circular(7),
                                    /*  border: Border.all(
                                      color: AppColors.colorFE6927,
                                    ),
                                    shape: BoxShape.circle*/
                                    ),
                                monthCellBuilder: (BuildContext buildContext,
                                    MonthCellDetails details) {
                                  const Color backgroundColor = Colors.white;
                                  final Color defaultColor =
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black54
                                          : Colors.white;
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: defaultColor, width: 0.5)),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          StreamBuilder(
                                              stream: myIdBookingList.stream,
                                              builder: (context, snapshot) {
                                                return CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor:
                                                      myIdBookingList.isEmpty
                                                          ? Colors.white
                                                          : getColour(
                                                              details.date),
                                                  child: Text(
                                                    details.date.day.toString(),
                                                    style: TextStyle(
                                                        color: details.date.isBefore(DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .day)) ||
                                                                details.date.isAfter(DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                            .day +
                                                                        45))
                                                            ? Colors.black26
                                                            : Colors.black),
                                                  ),
                                                );
                                              }),
                                          StreamBuilder(
                                              stream: GetPriceController
                                                  .to
                                                  .get_property_calender_priceRes
                                                  .stream,
                                              builder: (context, snapshot) {
                                                return Text(
                                                  '₹ ${((GetPriceController.to.get_property_calender_priceRes.isEmpty) || (GetPriceController.to.get_property_calender_priceRes == null)) ? '0' : getPrice(details.date)}',
                                                  textAlign: TextAlign.center,
                                                  style: color000000s12w400.copyWith(
                                                      color: details.date.isBefore(DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day)) ||
                                                              details.date.isAfter(DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                          .day +
                                                                      45))
                                                          ? Colors.black26
                                                          : Colors.black,
                                                      fontSize: 12),
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: (calendarLongPressDetails) {
                                  log(calendarLongPressDetails.date.toString());
                                  _startDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarLongPressDetails.date!);
                                  _startDateTime =
                                      calendarLongPressDetails.date!;
                                  _endDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarLongPressDetails.date!);
                                  _endDateTime = calendarLongPressDetails.date!;

                                  _price.text = '0';

                                  GetPriceController
                                      .to.get_property_calender_priceRes['date']
                                      .forEach((element) {
                                    if (DateTime.parse(
                                            element['date'].toString()) ==
                                        calendarLongPressDetails.date!) {
                                      _price.text =
                                          (element['date_price'] ?? '0')
                                              .toString();
                                      statusValue.value =
                                          (element['date_status'] ??
                                              '-- Please Select --');
                                    }
                                  });

                                  longPressDialoge(context);
                                },
                                /*  onTap: (calendarTapDetails) {
                                  log(calendarTapDetails.date.toString());
                                  _startDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarTapDetails.date!);
                                  _startDateTime = calendarTapDetails.date!;
                                  _endDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarTapDetails.date!);
                                  _endDateTime = calendarTapDetails.date!;
                                  final Appointment appointment =
                                      calendarTapDetails.appointments?.first;

                                  _price.text =
                                      appointment.subject.replaceAll('₹ ', '');

                                  onTapDialoge(context, calendarTapDetails);
                                },*/
                                /*appointmentBuilder: (BuildContext context,
                                    CalendarAppointmentDetails
                                        calendarAppointmentDetails) {
                                  final Appointment appointment =
                                      calendarAppointmentDetails.appointments.first;
                                  return SizedBox(
                                      height: calendarAppointmentDetails.bounds.height,
                                      child: );
                                },*/
                                dataSource: _getCalendarDataSource(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          statusView(
                            color: AppColors.colorffc107,
                            status: 'Upcoming Bookings',
                          ),
                          statusView(
                            color: AppColors.colorFE6927,
                            status: 'Ongoing Bookings',
                          ),
                          statusView(
                            color: AppColors.color32BD01,
                            status: 'Completed Bookings',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton(
                          onPressed: () {
                            _startDateTime = DateTime.now();
                            _startDate.text = DateFormat('dd-MM-yyyy')
                                .format(_startDateTime!);
                            _endDateTime = DateTime.now();
                            _endDate.text =
                                DateFormat('dd-MM-yyyy').format(_endDateTime!);
                            _price.clear();
                            onTapDialoge(context);
                          },
                          width: MediaQuery.of(context).size.width / 2,
                          name: 'Manage Calendar',
                          padding: const EdgeInsets.symmetric(vertical: 15))
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      /* Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.colorFE6927,
                        ),
                      ),
                      child: Theme(
                        data: ThemeData(
                            primaryColor: AppColors.colorFE6927,
                            unselectedWidgetColor: AppColors.colorFE6927,
                            primarySwatch: Colors.deepOrange),
                        child: SfDateRangePicker(
                          showActionButtons: true,
                          onSubmit: (value) {
                            if (value is PickerDateRange) {
                              selectedDays.value = (value.endDate!
                                          .difference(value.startDate!)
                                          .inDays +
                                      1)
                                  .toString();
                              Get.to(
                                () => PricingCalenderScreen(
                                  selectedDays: selectedDays.value,
                                  startDate: value.startDate!,
                                  endDate: value.endDate!,
                                  property_id: widget.property_Id,
                                ),
                              );
                            } else {
                              showSnackBar(
                                title: ApiConfig.error,
                                message: 'Select the date',
                              );
                            }
                          },
                          onCancel: () {
                            Get.back();
                          },
                          selectionColor: AppColors.colorFE6927,
                          todayHighlightColor: const Color(0xffFE6927),
                          enablePastDates: false,
                          initialDisplayDate: DateTime.now(),
                          monthViewSettings: const DateRangePickerMonthViewSettings(
                            blackoutDates: [
                              // DateTime(2022, 12, 29),
                              // DateTime(2023, 1, 2),
                              // DateTime(2023, 1, 3),
                            ],
                          ),
                          minDate: DateTime.now(),
                          rangeSelectionColor:
                              AppColors.colorFE6927.withOpacity(0.1),
                          endRangeSelectionColor: AppColors.colorFE6927,
                          startRangeSelectionColor: AppColors.colorFE6927,
                          selectionMode: DateRangePickerSelectionMode.range,
                        ),
                      ),
                    ),
                  ),*/
                      SizedBox(
                        height: 560,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              /* border: Border.all(
                                color: AppColors.colorFE6927,
                              ),*/
                              color: AppColors.colorffffff,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData(
                                  primaryColor: AppColors.colorFE6927,
                                  unselectedWidgetColor: AppColors.colorFE6927,
                                  primarySwatch: Colors.deepOrange),
                              child: SfCalendar(
                                view: CalendarView.month,
                                headerHeight: 60,
                                headerStyle: CalendarHeaderStyle(
                                  textAlign: TextAlign.center,
                                  textStyle: color00000s15w600,
                                ),
                                viewHeaderStyle: ViewHeaderStyle(
                                  backgroundColor:
                                      AppColors.colorFE6927.withOpacity(0.2),
                                  dayTextStyle: color00000s12w600,
                                ),
                                initialSelectedDate: DateTime.now(),
                                minDate: DateTime.now(),
                                maxDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 45),
                                onViewChanged: (viewChangedDetails) {
                                  loaderShow(context);

                                  GetPriceController.to
                                      .get_property_calender_price_Api(
                                          params: {
                                        "property_id": widget.property_Id,
                                        "year": viewChangedDetails
                                            .visibleDates.first.year,
                                        "month": viewChangedDetails
                                            .visibleDates.first.month
                                      },
                                          error: (e) {
                                            loaderHide();
                                          },
                                          success: () {
                                            loaderHide();
                                          });
                                },
                                cellBorderColor:
                                    AppColors.colorFE6927.withOpacity(0.5),
                                monthViewSettings: MonthViewSettings(
                                  showAgenda: false,
                                  showTrailingAndLeadingDates: false,
                                  dayFormat: 'EEE',
                                  monthCellStyle: MonthCellStyle(
                                    leadingDatesBackgroundColor:
                                        AppColors.color000000,
                                    trailingDatesBackgroundColor:
                                        AppColors.color000000,
                                  ),
                                ),
                                selectionDecoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.circular(7),
                                    /*  border: Border.all(
                                      color: AppColors.colorFE6927,
                                    ),
                                    shape: BoxShape.circle*/
                                    ),
                                monthCellBuilder: (BuildContext buildContext,
                                    MonthCellDetails details) {
                                  const Color backgroundColor = Colors.white;
                                  final Color defaultColor =
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black54
                                          : Colors.white;
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: defaultColor, width: 0.5)),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          StreamBuilder(
                                              stream: myIdBookingList.stream,
                                              builder: (context, snapshot) {
                                                return CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      myIdBookingList.isEmpty
                                                          ? Colors.white
                                                          : getColour(
                                                              details.date),
                                                  child: Text(
                                                    details.date.day.toString(),
                                                    style: TextStyle(
                                                        color: details.date.isBefore(DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .day)) ||
                                                                details.date.isAfter(DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                            .day +
                                                                        45))
                                                            ? Colors.black26
                                                            : Colors.black),
                                                  ),
                                                );
                                              }),
                                          StreamBuilder(
                                              stream: GetPriceController
                                                  .to
                                                  .get_property_calender_priceRes
                                                  .stream,
                                              builder: (context, snapshot) {
                                                return Text(
                                                  '₹ ${((GetPriceController.to.get_property_calender_priceRes.isEmpty) || (GetPriceController.to.get_property_calender_priceRes == null)) ? '0' : getPrice(details.date)}',
                                                  textAlign: TextAlign.center,
                                                  style: color000000s12w400.copyWith(
                                                      color: details.date.isBefore(DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day)) ||
                                                              details.date.isAfter(DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                          .day +
                                                                      45))
                                                          ? Colors.black26
                                                          : Colors.black,
                                                      fontSize: 12),
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: (calendarLongPressDetails) {
                                  log(calendarLongPressDetails.date.toString());
                                  _startDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarLongPressDetails.date!);
                                  _startDateTime =
                                      calendarLongPressDetails.date!;
                                  _endDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarLongPressDetails.date!);
                                  _endDateTime = calendarLongPressDetails.date!;

                                  _price.text = '0';

                                  GetPriceController
                                      .to.get_property_calender_priceRes['date']
                                      .forEach((element) {
                                    if (DateTime.parse(
                                            element['date'].toString()) ==
                                        calendarLongPressDetails.date!) {
                                      _price.text =
                                          (element['date_price'] ?? '0')
                                              .toString();
                                      statusValue.value =
                                          (element['date_status'] ??
                                              '-- Please Select --');
                                    }
                                  });

                                  longPressDialoge(context);
                                },
                                /*  onTap: (calendarTapDetails) {
                                  log(calendarTapDetails.date.toString());
                                  _startDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarTapDetails.date!);
                                  _startDateTime = calendarTapDetails.date!;
                                  _endDate.text = DateFormat('dd-MM-yyyy')
                                      .format(calendarTapDetails.date!);
                                  _endDateTime = calendarTapDetails.date!;
                                  final Appointment appointment =
                                      calendarTapDetails.appointments?.first;

                                  _price.text =
                                      appointment.subject.replaceAll('₹ ', '');

                                  onTapDialoge(context, calendarTapDetails);
                                },*/
                                /*appointmentBuilder: (BuildContext context,
                                    CalendarAppointmentDetails
                                        calendarAppointmentDetails) {
                                  final Appointment appointment =
                                      calendarAppointmentDetails.appointments.first;
                                  return SizedBox(
                                      height: calendarAppointmentDetails.bounds.height,
                                      child: );
                                },*/
                                dataSource: _getCalendarDataSource(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: statusView(
                                color: AppColors.colorffc107,
                                status: 'Upcoming Bookings',
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              child: statusView(
                                color: AppColors.colorFE6927,
                                status: 'Ongoing Bookings',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: statusView(
                                color: AppColors.color32BD01,
                                status: 'Completed Bookings',
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              child: statusView(
                                color: AppColors.colorE31717,
                                status: 'Blocked Bookings',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CommonButton(
                          onPressed: () {
                            _startDateTime = DateTime.now();
                            _startDate.text = DateFormat('dd-MM-yyyy')
                                .format(_startDateTime!);
                            _endDateTime = DateTime.now();
                            _endDate.text =
                                DateFormat('dd-MM-yyyy').format(_endDateTime!);
                            _price.text = widget.property_Price;
                            onTapDialoge(context);
                          },
                          width: MediaQuery.of(context).size.width / 2,
                          name: 'Manage Calendar',
                          padding: const EdgeInsets.symmetric(vertical: 15))
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Future<dynamic> onTapDialoge(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Set price for particular dates',
                style: color00000s18w600,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Start Date',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: color00000s14w500,
                  controller: _startDate,
                  cursorColor: AppColors.colorFE6927,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    _startDateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime
                          .now(), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 45),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: AppColors.colorFE6927,
                            // accentColor: AppColors.colorFE6927,
                            colorScheme: ColorScheme.light(
                                primary: AppColors.colorFE6927),
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (_startDateTime != null) {
                      _startDate.text =
                          DateFormat('dd-MM-yyyy').format(_startDateTime!);
                      log(_startDateTime.toString(), name: 'PICKED DATE');
                    } else {
                      _startDateTime = DateTime.now();
                      log(_startDateTime.toString(), name: 'PICKED DATE');
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Start Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'End Date',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: color00000s14w500,
                  controller: _endDate,
                  cursorColor: AppColors.colorFE6927,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    _endDateTime = await showDatePicker(
                      context: context,
                      initialDate: _startDateTime!, //get today's date
                      firstDate:
                          _startDateTime!, //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 45),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: AppColors.colorFE6927,
                            // accentColor: AppColors.colorFE6927,
                            colorScheme: ColorScheme.light(
                                primary: AppColors.colorFE6927),
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (_endDateTime != null) {
                      _endDate.text =
                          DateFormat('dd-MM-yyyy').format(_endDateTime!);
                      log(_endDateTime.toString(), name: 'PICKED DATE');
                    } else {
                      _endDateTime = DateTime.now();
                      log(_endDateTime.toString(), name: 'PICKED DATE');
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'End Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : Text(
                              'Price',
                              style: color50perBlacks13w400,
                            );
                    }),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : const SizedBox(
                              height: 5,
                            );
                    }),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : TextFormField(
                              style: color00000s14w500,
                              controller: _price,
                              cursorColor: AppColors.colorFE6927,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Price',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Minimum Stay',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: color00000s14w500,
                  controller: _minStay,
                  cursorColor: AppColors.colorFE6927,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Status',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: statusValue.value,
                      borderRadius: BorderRadius.circular(6),
                      items: List.generate(
                          Status.length,
                          (index) => DropdownMenuItem(
                                value: Status[index],
                                child: Text(
                                  Status[index],
                                  style: color00000s14w500,
                                ),
                              )),
                      onChanged: (_) {
                        statusValue.value = _.toString();
                      },
                    ),
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: CommonButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: AppColors.colorEBEBEB,
                        style: colorfffffffs13w600.copyWith(
                            color: AppColors.color000000.withOpacity(0.7)),
                        name: 'Close',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: CommonButton(
                        onPressed: () {
                          if (_endDateTime!.isAfter(_startDateTime!) ||
                              _startDateTime! == _endDateTime!) {
                            if (statusValue.value != '-- Please Select --') {
                              if ((statusValue.value == 'Not available') ||
                                  (_price.text.isNotEmpty &&
                                      int.parse(_price.text) > 0)) {
                                loaderShow(context);

                                ManageCalendarContoller.to.set_price_dateApi(
                                    params: statusValue.value == 'Not available'
                                        ? {
                                            'property_id': widget.property_Id,
                                            'start_date': _startDate.text,
                                            'end_date': _endDate.text,
                                            'min_stay': _minStay.text,
                                            'status': statusValue.value,
                                          }
                                        : {
                                            'property_id': widget.property_Id,
                                            'start_date': _startDate.text,
                                            'end_date': _endDate.text,
                                            'price': _price.text,
                                            'min_stay': _minStay.text,
                                            'status': statusValue.value,
                                          },
                                    error: (e) {
                                      loaderHide();
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message: e.toString());
                                    },
                                    success: () {
                                      /* Get.back();*/
                                      Get.back();
                                      GetPriceController.to
                                          .get_property_calender_price_Api(
                                              params: {
                                            "property_id": widget.property_Id,
                                            "year": _startDateTime?.year,
                                            "month": _startDateTime?.month
                                          },
                                              error: (e) {
                                                loaderHide();
                                                showSnackBar(
                                                    title: ApiConfig.error,
                                                    message: e.toString());
                                              },
                                              success: () {
                                                loaderHide();
                                              });

                                      // loaderHide();
                                    });
                              } else {
                                showSnackBar(
                                    title: ApiConfig.error,
                                    message: 'Price Should not be 0');
                              }
                            } else {
                              showSnackBar(
                                title: ApiConfig.error,
                                message: 'Please Select Status',
                              );
                            }
                          } else {
                            showSnackBar(
                              title: ApiConfig.error,
                              message: 'EndDate Must be greater then StartDate',
                            );
                          }
                        },
                        name: 'Submit',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> longPressDialoge(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Set price for particular date',
                style: color00000s18w600,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Date',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: color00000s14w500,
                  controller: _startDate,
                  cursorColor: AppColors.colorFE6927,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : Text(
                              'Price',
                              style: color50perBlacks13w400,
                            );
                    }),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : const SizedBox(
                              height: 5,
                            );
                    }),
                StreamBuilder(
                    stream: statusValue.stream,
                    builder: (context, snapshot) {
                      return statusValue.value == 'Not available'
                          ? const SizedBox()
                          : TextFormField(
                              style: color00000s14w500,
                              controller: _price,
                              cursorColor: AppColors.colorFE6927,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Price',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Status',
                  style: color50perBlacks13w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.color000000.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: statusValue.value,
                      borderRadius: BorderRadius.circular(6),
                      items: List.generate(
                          Status.length,
                          (index) => DropdownMenuItem(
                                value: Status[index],
                                child: Text(
                                  Status[index],
                                  style: color00000s14w500,
                                ),
                              )),
                      onChanged: (_) {
                        statusValue.value = _.toString();
                      },
                    ),
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: CommonButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: AppColors.colorEBEBEB,
                        style: colorfffffffs13w600.copyWith(
                            color: AppColors.color000000.withOpacity(0.7)),
                        name: 'Close',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: CommonButton(
                        onPressed: () {
                          if (statusValue.value != '-- Please Select --') {
                            if (_price.text.isNotEmpty &&
                                int.parse(_price.text) > 0) {
                              loaderShow(context);

                              ManageCalendarContoller.to.set_price_dateApi(
                                  params: statusValue.value == 'Not available'
                                      ? {
                                          'property_id': widget.property_Id,
                                          'start_date': _startDate.text,
                                          'end_date': _endDate.text,
                                          'min_stay': _minStay.text,
                                          'status': statusValue.value,
                                        }
                                      : {
                                          'property_id': widget.property_Id,
                                          'start_date': _startDate.text,
                                          'end_date': _endDate.text,
                                          'price': _price.text,
                                          'min_stay': _minStay.text,
                                          'status': statusValue.value,
                                        },
                                  error: (e) {
                                    loaderHide();
                                  },
                                  success: () {
                                    /*Get.back();*/
                                    // Get.back();

                                    Get.back();
                                    GetPriceController.to
                                        .get_property_calender_price_Api(
                                            params: {
                                          "property_id": widget.property_Id,
                                          "year": _startDateTime?.year,
                                          "month": _startDateTime?.month
                                        },
                                            error: (e) {
                                              loaderHide();
                                            },
                                            success: () {
                                              loaderHide();
                                            });
                                    // loaderHide();
                                  });
                            } else {
                              showSnackBar(
                                  title: ApiConfig.error,
                                  message: 'Price Should not be 0');
                            }
                          } else {
                            showSnackBar(
                                title: ApiConfig.error,
                                message: 'Please Select Status');
                          }
                        },
                        name: 'Submit',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String getPrice(DateTime date) {
    String Price = '0';
    GetPriceController.to.get_property_calender_priceRes['date']
        .forEach((element) {
      if (DateTime.parse(element['date'].toString()) == date) {
        Price = (element['date_price'] ?? '0').toString();
      }
    });
    return Price;
  }

  Color getColour(DateTime date) {
    Color barColor = Colors.white;
    for (var element in myIdBookingList) {
      if (element.subject == 'Upcoming' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xffffc107);
      } else if (element.subject == 'Completed' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xff32BD01);
      } else if (element.subject == 'Ongoing' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xffFE6927);
      } else if (element.subject == 'Blocked' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xffE31717);
      } else {}
    }

    return barColor;
  }

  Padding statusView({required Color color, required String status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            status,
            style: color000000s12w400.copyWith(fontSize: 13),
          )
        ],
      ),
    );
  }
}

RxList<Appointment> myIdBookingList = <Appointment>[].obs;
_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.clear();
  for (var element in GetPriceController.to.OngoingReservation) {
    /*if (element['status'] == 'Pending') {*/
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /*'${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Ongoing',
      color: AppColors.colorFE6927.withOpacity(0),
    ));
    /*  }*/
  }

  for (var element in GetPriceController.to.UpcomingReservation) {
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /* '${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Upcoming',
      color: AppColors.colorffc107.withOpacity(0),
    ));
  }
  for (var element in GetPriceController.to.CompletedReservation) {
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /*'${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Completed',
      color: AppColors.color32BD01.withOpacity(0),
    ));
  }

  if (GetPriceController.to.get_property_calender_priceRes.isNotEmpty) {
    GetPriceController.to.get_property_calender_priceRes['date']
        .forEach((element) {
      if (element['date_status'] == 'Not available') {
        appointments.add(Appointment(
          startTime: DateTime.parse((element['date']).toString()),
          endTime: DateTime.parse((element['date']).toString()),
          id: element['date_currency_price'],
          subject:
              /* '${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Blocked',
          color: AppColors.colorffc107.withOpacity(0),
        ));
      }
    });
  }

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    /* source.forEach((element) {
      if (source.contains(element)) {
        log(element.subject, name: 'CONTAINS');
        source.remove(element);
      }
    });*/

    appointments = source.toSet().toList();

    myIdBookingList.value = source.toSet().toList();
    log(myIdBookingList.toString(), name: 'Calender mybookingList');
  }
}
