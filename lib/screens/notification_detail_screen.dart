// import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:aicp/themes/app_colors.dart';
// import 'package:aicp/widgets/sizebox_widgets.dart';
//
// class NotificationDetailScreen extends StatefulWidget {
//   final linkImage;
//   final title;
//   final detail;
//   final date;
//
//   NotificationDetailScreen(this.linkImage, this.title, this.detail, this.date);
//
//   @override
//   _NotificationDetailScreenState createState() =>
//       _NotificationDetailScreenState(
//           this.linkImage, this.title, this.detail, this.date);
// }
//
// class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
//   _NotificationDetailScreenState(
//       this.linkImage, this.title, this.detail, this.date);
//
//   String? linkImage;
//   String? title;
//   String? detail;
//   String? date;
//   late DateTime currentBackPressTime;
//   var formatter = DateFormat('dd MMMM yyyy');
//   var timeformatter = DateFormat.jm();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF9AABBB),
//                 Color(0xFFFFFFFF),
//               ],
//               begin: Alignment.bottomRight,
//               end: Alignment.topLeft,
//             ),
//           ),
//           child: ListView(
//             children: [
//               S.h(10.0),
//               getDateNow(),
//               S.h(10.0),
//               Padding(
//                 padding: const EdgeInsets.only(left: 24, right: 24),
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: linkImage.toString(),
//                   placeholder: (context, url) =>
//                       const Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//               S.h(15.0),
//               Padding(
//                 padding: const EdgeInsets.only(left: 24, right: 24),
//                 child: AutoSizeText(
//                   title!,
//                   style: const TextStyle(fontSize: 20),
//                   maxLines: 3,
//                 ),
//               ),
//               S.h(10.0),
//               Padding(
//                 padding: const EdgeInsets.only(left: 24, right: 24),
//                 child: AutoSizeText(
//                   detail!,
//                   style: TextStyle(
//                       fontSize: 14, color: Colors.black.withOpacity(0.8)),
//                   maxLines: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getDateNow() {
//     DateTime dateTime = DateTime.parse(date.toString());
//     return Padding(
//       padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             timeformatter.format(dateTime).toString() +
//                 ' . ' +
//                 formatter.format(dateTime).toString(),
//             style: TextStyle(
//                 color: AppColors.indigoPrimary.withOpacity(0.50),
//                 fontFamily: 'Prompt',
//                 fontSize: 16),
//           ),
//           MaterialButton(
//             onPressed: () => Navigator.pop(context),
//             minWidth: 30.0,
//             height: 30.0,
//             color: Colors.white,
//             child: const Icon(
//               Icons.close,
//               size: 25.0,
//             ),
//             padding: const EdgeInsets.all(10.0),
//             shape: const CircleBorder(),
//           ),
//         ],
//       ),
//     );
//   }
// }
