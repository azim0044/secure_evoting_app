// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/body_layout/presentation/body_layout.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/services.dart';
import 'package:secure_evoting_app/shared/const/api_endpoints.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'package:http/http.dart' as http;

class FaceAuthenticationWidgetScreen extends StatefulWidget {
  const FaceAuthenticationWidgetScreen({
    Key? key,
    required this.fromWidget,
    this.electionId,
    this.candidateId,
    this.candidateName,
  }) : super(key: key);

  final String fromWidget;
  final String? electionId;
  final String? candidateId;
  final String? candidateName;

  @override
  _FaceAuthenticationWidgetScreenState createState() =>
      _FaceAuthenticationWidgetScreenState();
}

class _FaceAuthenticationWidgetScreenState
    extends State<FaceAuthenticationWidgetScreen> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  void _startProccess(
      {required File image,
      required String pendingMessage,
      required String successMessage}) async {
    try {
      await performLoading<void>(
        _encryptReference(image),
        pendingMessage,
        successMessage,
      );
    } catch (e) {
      EasyLoading.showError(
          e is Exception ? e.toString().split('Exception: ')[1] : e.toString());
    }
  }

  Future<bool> _encryptReference(File image) async {
    try {
      String? secureKey = await storage.read(key: 'secureKey');
      String encryptedFilePath =
          EncryptData.encrypt_file(image.path, secureKey!);

      http.Response? response;

      if (widget.fromWidget == 'Upload Reference') {
        response = await _networkUploadReference(encryptedFilePath);
      } else {
        response = await _networkFaceAuthentication(encryptedFilePath);
      }
      if (encryptedFilePath != null && response.statusCode == 200) {
        return true;
      } else {
        if (widget.fromWidget == 'Upload Reference') {
          throw Exception('Failed to upload reference!');
        } else {
          throw Exception('Face authentication failed!');
        }
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to upload reference!');
    }
  }

  Future<http.Response> _networkUploadReference(
      String encryptedImagePath) async {
    String url = ApiEndPoints().uploadReference;
    String? token = await storage.read(key: 'token');

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    request.fields['userId'] = Auth().currentUser!.uid;
    request.files
        .add(await http.MultipartFile.fromPath('image', encryptedImagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return http.Response(responseBody, response.statusCode);
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<http.Response> _networkFaceAuthentication(
      String encryptedImagePath) async {
    String url = ApiEndPoints().faceRecognition;
    String? token = await storage.read(key: 'token');

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    request.fields['userId'] = Auth().currentUser!.uid;
    request.fields['electionId'] = widget.electionId!;
    request.fields['candidateId'] = widget.candidateId!;
    request.files
        .add(await http.MultipartFile.fromPath('image', encryptedImagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return http.Response(responseBody, response.statusCode);
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.fromWidget,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: SmartFaceCamera(
            autoCapture: true,
            enableAudio: false,
            showControls: false,
            showCaptureControl: false,
            showFlashControl: false,
            showCameraLensControl: false,
            defaultCameraLens: CameraLens.front,
            onCapture: (File? image) async {
              if (image != null) {
                if (widget.fromWidget == 'Upload Reference') {
                  _startProccess(
                      image: image,
                      pendingMessage: 'Uploading reference...',
                      successMessage: 'Reference uploaded successfully');
                  Get.back();
                } else {
                  _startProccess(
                      image: image,
                      pendingMessage: 'Authenticating face...',
                      successMessage:
                          'Your face has been authenticated and successfully vote for ${widget.candidateName} !');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAll(() => const BodyLayoutWidget());
                  });
                }
              }
            },
            messageBuilder: (context, face) {
              if (face == null) {
                return _message('Place your face in the camera');
              }
              if (!face.wellPositioned) {
                return _message('Center your face in the square');
              }
              return const SizedBox.shrink();
            }));
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.red)),
      );
}
