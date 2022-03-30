import 'package:aicp/component/appBar.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF345776).withOpacity(0.6),
                    Color(0xFFF0F3F5).withOpacity(0.1),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment(1.2, -1.25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerAppBar(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                        child: Text(
                      "Choose to sign in with",
                      style: TextStyle(color: Color(0xFF707070), fontSize: 16),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginButton(context, Icons.phone_iphone, "Mobile",
                          defultColorMobile),
                      loginButton(context, Icons.person, "Username",
                          defultColorUsername),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.75, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  inputLoging(
                      context, "ชื่อผู้ใช้", Icons.person_outline, userName),
                  inputLoging(
                      context, "รหัสผ่าน", Icons.phonelink_lock, passWord),
                  loginButtonSubmit(context),
                  registerButton(context),
                  SizedBox(height: 10),
                  pictureFooterScreen(),
                  SizedBox(height: 40),
                ],
              )),
        ),
      ),
    );
  }

  Color defultColorMobile = Color(0xFF163E63);
  Color defultColorUsername = Color(0xFF163E63);
  final TextEditingController userName = TextEditingController();
  final TextEditingController passWord = TextEditingController();

  loginButton(context, IconData icon, String type, Color defultColor) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border(
      //   bottom: BorderSide(width: , color: Color(0xFFFE0000)),
      // )),
      child: TextButton(
          onPressed: () {
            if (type == "Mobile") {
              setState(() => defultColorMobile = Color(0xFFFE0000));
              setState(() => defultColorUsername = Color(0xFF163E63));
            } else {
              setState(() => defultColorUsername = Color(0xFFFE0000));
              setState(() => defultColorMobile = Color(0xFF163E63));
            }
          },
          child: Row(
            children: [
              Icon(
                icon,
                color: defultColor,
                size: MediaQuery.of(context).size.width * 0.065,
              ),
              Text(
                type,
                style: TextStyle(
                    color: defultColor,
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              )
            ],
          )),
    );
  }

  inputLoging(
          context, String topic, IconData icon, TextEditingController input) =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: topic,
            hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.040,
                fontWeight: FontWeight.bold),
            border: InputBorder.none,
            prefixIcon: Icon(icon),
          ),
          controller: input,
        ),
      );

  Widget loginButtonSubmit(context) => Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF022D54),
                      spreadRadius: 1,
                      blurRadius: 1.1,
                      offset: Offset(-1, 3),
                    )
                  ]),
              child: TextButton(
                onPressed: () {},
                child: Expanded(
                    child: Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ],
        ),
      );

  Widget registerButton(context) => Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.75, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("คุณยังไม่ได้สมัครสมาชิกใช่มั้ย ?",
                  style: TextStyle(color: Color(0xFF707070), fontSize: 15)),
              TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return registerScreen();
                  // }));
                },
                child: Text("สมัครใช้งาน",
                    style: TextStyle(
                        color: Color(0xFF1C466E),
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      );
}

pictureFooterScreen() => Container(
      height: 130,
      child: const ClipRRect(
        child: Image(
          image: AssetImage(ImagesThemes.footerLogin),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
