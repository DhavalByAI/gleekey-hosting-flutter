import 'dart:io';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_app_file/open_app_file.dart';

class PdfApi {
  static Future<File> saveDocument(
      {required String name, required Document doc}) async {
    final bytes = await doc.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    print("FILE PATH ${file.path}");
    return file;
  }

  static Future openDocument({required File file}) async {
    final urlPath = file.path;
    await OpenFile.open(urlPath);
  }
}

class PdfController {
  static Future<File> generate(
      Map data, List dateWithPrice, double subtotal) async {
    // var myTheme = ThemeData.withFont(
    //   base: Font.ttf(
    //       await rootBundle.load("assets/fonts/HankenGrotesk-Regular.ttf")),
    //   bold: Font.ttf(
    //       await rootBundle.load("assets/fonts/HankenGrotesk-Bold.ttf")),
    // );
    final pdf = Document(
        //   theme: myTheme,
        );
    final applogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/app_logo.png'))
          .buffer
          .asUint8List(),
    );
    final approved = pw.MemoryImage(
      (await rootBundle.load('assets/images/approved.png'))
          .buffer
          .asUint8List(),
    );

    final netImage = pw.MemoryImage(
      (await NetworkAssetBundle(Uri.parse(data['properties']['cover_photo']))
              .load(data['properties']['cover_photo']))
          .buffer
          .asUint8List(),
    );
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.symmetric(
          horizontal: 0.5 * PdfPageFormat.cm,
          vertical: 0.6 * PdfPageFormat.cm,
        ),
        build: (context) => [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey),
              borderRadius: BorderRadius.circular(0.3 * PdfPageFormat.cm),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 0.3 * PdfPageFormat.cm,
                vertical: 0.3 * PdfPageFormat.cm),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 0.3 * PdfPageFormat.cm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(applogo,
                      height: 5 * PdfPageFormat.cm,
                      width: 8 * PdfPageFormat.cm),
                  pw.Image(approved,
                      height: 3 * PdfPageFormat.cm,
                      width: 3 * PdfPageFormat.cm),
                ],
              ),
              SizedBox(height: 0.8 * PdfPageFormat.cm),
              buildTitle(data),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              data['properties']?['name'] ?? '-',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        /*  Row(
                          children: [
                            Flexible(
                              child: Text(
                                'STATIC ADDRESS',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xffD9D9D9)),
                              ),
                            ),
                          ],
                        ),*/
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Row(
                          children: [
                            Text(
                              'Hosted By: ',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              data['properties']?['host_name'] ?? '-',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    verticalRadius: 6,
                    horizontalRadius: 6,
                    child: Image(netImage,
                        height: 4 * PdfPageFormat.cm,
                        width: 4 * PdfPageFormat.cm),
                  ),
                ],
              ),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Text(
                'Booking Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['total_night'] ?? '-'} Nights',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          data['accepted_at'] == null ||
                                  data['accepted_at'] == ''
                              ? 'Booked on --'
                              : 'Booked on ${DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(data['accepted_at']),
                                )}',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 0.2 * PdfPageFormat.cm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHECK-IN',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          data['start_date'] == null || data['start_date'] == ''
                              ? '--'
                              : DateFormat.yMMMEd()
                                  .format(DateTime.parse(data['start_date'])),
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 0.2 * PdfPageFormat.cm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHECK-OUT',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          data['end_date'] == null || data['end_date'] == ''
                              ? '--'
                              : DateFormat.yMMMEd()
                                  .format(DateTime.parse(data['end_date']))
                                  .toString(),
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GUEST(s)',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          'Adult(s) | Children | Infant(s)',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 0.2 * PdfPageFormat.cm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Guests',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          '${data['guest'] ?? '-'} Guests',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                        SizedBox(height: 0.6 * PdfPageFormat.cm),
                        Text(
                          'PHONE NO',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          '${data['users']?['formatted_phone'] ?? '-'}',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 0.2 * PdfPageFormat.cm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIMARY GUEST',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          '${data['users']?['first_name'] ?? '-'} ${data['users']?['last_name'] ?? '-'}',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                        SizedBox(height: 0.6 * PdfPageFormat.cm),
                        Text(
                          'EMAIL ID',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          '${data['users']?['email'] ?? '-'}',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 0.2 * PdfPageFormat.cm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOKED BY',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 0.2 * PdfPageFormat.cm),
                        Text(
                          '${data['booking_first_name'] ?? '-'} ${data['booking_last_name'] ?? '-'} ',
                          style: const TextStyle(
                              fontSize: 12, color: PdfColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Text(
                'Price Breakup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              Column(
                children: List.generate(dateWithPrice.length, (i) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          (dateWithPrice[i]?["date"] ?? '-').toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        'Rs ${dateWithPrice[i]['price'].toString()}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sub Total for ${data['total_night'] ?? '-'} Nights',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    'Rs ${subtotal.round()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 0.3 * PdfPageFormat.cm),
              data['couponcode_amount'] == 0 ||
                      data['couponcode_amount'] == null ||
                      data['couponcode_amount'] == ""
                  ? SizedBox()
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Discount',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          '- \u{20B9} ${data['couponcode_amount']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
              data['couponcode_amount'] == 0 ||
                      data['couponcode_amount'] == null ||
                      data['couponcode_amount'] == ""
                  ? SizedBox()
                  : SizedBox(height: 0.3 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'GST',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    'Rs ${((subtotal - (int.parse(data['couponcode_amount'] ?? 0))) * 0.18).round()}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sub Total',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    'Rs ${((subtotal) + (subtotal * 0.18)).round()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: PdfColor.fromInt(0xffFE6927),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.2 * PdfPageFormat.cm),
              Divider(
                color: PdfColor.fromHex('#D9D9D9'),
              ),
              SizedBox(height: 0.3 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total Price',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Rs ${(((subtotal) - (int.parse(data['couponcode_amount'] ?? 0))) + (subtotal * 0.18)).round()}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 0.3 * PdfPageFormat.cm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'AMOUNT PAID',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    'Rs ${(((subtotal) - (int.parse(data['couponcode_amount'] ?? 0))) + (subtotal * 0.18)).round()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey),
              borderRadius: BorderRadius.circular(0.3 * PdfPageFormat.cm),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 0.3 * PdfPageFormat.cm,
                vertical: 0.4 * PdfPageFormat.cm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note :',
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: 0.35 * PdfPageFormat.cm),
                Text(
                  '1.  At the time of check-in, details entered below should match as per govt. issued ID proofs for all the guests. Entry might be restricted in case of non-availability or mismacth of ID Proofs.',
                  style: const TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                Text(
                  '2.  Complete Property details will be shared to you before 5 days of check-in date.',
                  style: const TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                Text(
                  '3.  Final Invoice will be shared on registered email id or you can check into my-trips before 5 days of check-id date on website.',
                  style: const TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                Text(
                  '4.  On arrival please produce the booking invoice for check-in.',
                  style: const TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
              ],
            ),
          ),
          Row(children: [
            SizedBox(height: 0.5 * PdfPageFormat.cm),
          ]),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey),
              borderRadius: BorderRadius.circular(0.3 * PdfPageFormat.cm),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 0.3 * PdfPageFormat.cm,
              vertical: 0.4 * PdfPageFormat.cm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GleeKey Support :',
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: 0.3 * PdfPageFormat.cm),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'For any queries in regards to booking, kindly reach us at  ',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'queries@gleekey.in',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromInt(0xffFE6927),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return PdfApi.saveDocument(name: 'Gleekey_${data['code']}.pdf', doc: pdf)
        .then((value) {
      OpenAppFile.open(value.path);
      return value;
    });
  }

  static Widget buildTitle(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Voucher',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.2 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Booking ID : ',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              data['code'] ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        Divider(
          color: PdfColor.fromHex('#D9D9D9'),
        ),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
      ],
    );
  }
}
