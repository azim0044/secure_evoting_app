class BaseUrl {
  static const String BASE_URL =
      "https://nqp82lpb-5050.asse.devtunnels.ms/api/";
}

class ApiEndPoints {
  final String checkReference = "${BaseUrl.BASE_URL}check-reference";
  final String otpAuthentication = "${BaseUrl.BASE_URL}otp-authentication";
  final String validateOtp = "${BaseUrl.BASE_URL}validate-otp";
  final String login = "${BaseUrl.BASE_URL}login";
  final String generateKey = "${BaseUrl.BASE_URL}generate-key";
  final String uploadReference = "${BaseUrl.BASE_URL}upload-reference";
  final String uploadPrivateKey = "${BaseUrl.BASE_URL}upload-private-key";
  final String faceRecognition = "${BaseUrl.BASE_URL}face-recognition";
}
