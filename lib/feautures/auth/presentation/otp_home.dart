import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:secure_evoting_app/feautures/auth/presentation/scan_qr_screen.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/body_layout/presentation/body_layout.dart';
import 'package:secure_evoting_app/shared/const/api_endpoints.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'dart:convert';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCodeHome extends StatefulWidget {
  const QrCodeHome({super.key});

  @override
  State<QrCodeHome> createState() => _QrCodeHomeState();
}

class _QrCodeHomeState extends State<QrCodeHome> {
  OtpFieldController otpController = OtpFieldController();
  

  @override
  void initState() {
    super.initState();
    _sendOtp();
    otpController = OtpFieldController();
  }

  void _sendOtp() async {
    try {
      await performLoading<void>(
        _networkOtpAuthentication(),
        'Sending otp...',
        'OTP sent successfully!',
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  void _validateOtp(String otp) async {
    try {
      await performLoading<void>(
        _networkOtpValidation(otp),
        'Validate otp...',
        'OTP is valid !',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => const BodyLayoutWidget());
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<http.Response> _networkOtpAuthentication() async {
    String url = ApiEndPoints().otpAuthentication;
    Map<String, dynamic> jsonPayload = {'email': Auth().currentUser!.email!};
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonPayload),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'Failed to send OTP. Please try again later or contact support.');
    }
  }

  Future<http.Response> _networkOtpValidation(String otp) async {
    String url = ApiEndPoints().validateOtp;
    Map<String, dynamic> jsonPayload = {
      'email': Auth().currentUser!.email!,
      "otp": otp
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonPayload),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isVerified', true);
      return response;
    } else {
      throw Exception(
          'OTP expired. Please try again later or contact support.');
    }
  }

  void handleScannedValue(String? scannedValue) {
    Future.delayed(Duration.zero, () {
      if (scannedValue != null) {
        List<String> splitScannedValue = scannedValue.split('');
        otpController.set(splitScannedValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Otp Qr Code",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/qr-code.png'),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "We've successfully sent the OTP to your email address. Please scan the QR code to verify your identity.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 10,
                style: const TextStyle(fontSize: 17),
                onChanged: (pin) {
                  print("Changed: " + pin);
                },
                onCompleted: (pin) async {
                  _validateOtp(pin);
                  // verify(pin);
                  // otpController.clear();
                }),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              Get.to(
                () => ScanQrScreen(onScan: handleScannedValue),
                transition: Transition.downToUp,
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Scan Now !',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5.0,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Center(
                child: Text.rich(
              TextSpan(
                text: "Didn't receive the OTP?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
                children: <InlineSpan>[
                  WidgetSpan(
                    child: InkWell(
                      onTap: () async {
                        _sendOtp();
                      },
                      child: Text(
                        ' Resend OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
