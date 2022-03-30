import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/widgets/push_page_transition.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class TermPoliciesScreen extends StatefulWidget {
  const TermPoliciesScreen({Key? key}) : super(key: key);

  @override
  _TermPoliciesScreenState createState() => _TermPoliciesScreenState();
}

class _TermPoliciesScreenState extends State<TermPoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF032D54),
                  Color(0xFF305679),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Positioned(
                  top: 45,
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 80,
                      child: const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Icon(
                          Icons.navigate_before,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        S.h(25.0),
                        Text(
                          "Term&Policy".tr(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontFamily: 'prompt',
                          ),
                        ),
                        S.h(20.0),
                        TextContent("readTermPolicy".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_1".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_2".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Name".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Dateofbirth".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Address".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_PhoneNumber".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_permission_1".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_permission_2".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_permission_3".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_info".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_info_1".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_3".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_4".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_5".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_Security".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Security_1".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_Enforcement".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Enforcement_1".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_Information".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Information_1".tr()),
                        S.h(20.0),
                        TextContent("TermPolicy_Contract".tr()),
                        S.h(12.0),
                        TextContent("TermPolicy_Contract_1".tr()),
                        S.h(35.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "accept_agreement".tr(),
                  style: const TextStyle(fontFamily: 'prompt', fontSize: 16),
                ),
                InkWell(
                  onTap: () => PushPageTran.push(context, const IndexScreen()),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xFF4D7CA7),
                    ),
                    child: Center(
                      child: Text(
                        "confirm".tr(),
                        style: const TextStyle(
                            fontFamily: 'prompt',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                S.h(0.5),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget TextContent(text) {
    return AutoSizeText(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'prompt',
      ),
    );
  }
}
