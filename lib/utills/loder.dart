import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'style/constants.dart';

// class Loder extends StatelessWidget {
//   Widget child;
//   Loder({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return LoaderOverlay(
//       useDefaultLoading: true,
//       overlayColor: Colors.black26,
//       overlayWidget: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           height: 50,
//           width: 50,
//           child: const Center(
//             child: SpinKitCircle(
//               color: kOrange,
//               size: 30,
//             ),
//           ),
//         ),
//       ),
//       child: child,
//     );
//   }
// }

void loaderShow(context) {
  return Loader.show(
    context,
    isSafeAreaOverlay: true,
    isBottomBarOverlay: true,
    overlayColor: Colors.black26,
    progressIndicator: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        width: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SpinKitCircle(
              color: kOrange,
              size: 30,
            ),
          ],
        )),
  );
}

void loaderHide() {
  return Loader.hide();
}
