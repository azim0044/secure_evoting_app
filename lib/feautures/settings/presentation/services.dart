import 'dart:convert';
import 'dart:io';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

import 'package:path_provider/path_provider.dart';

class EncryptData {
  static String encrypt_file(String path, String secureKey) {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword(secureKey);
    String encFilepath = '';
    try {
      encFilepath = crypt.encryptFileSync(path);
    } catch (e) {
      if (e == AesCryptExceptionType.destFileExists) {
      } else {
        return 'ERROR';
      }
    }
    return encFilepath;
  }

  static Future<String> encrypt_data(
      Map<String, dynamic> data, String secureKey) async {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword(secureKey);
    String encFilepath = '';
    try {
      String dataString = jsonEncode(data);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      encFilepath = await crypt.encryptTextToFile(
          dataString, '$tempPath/${data['userId']}.aes');
    } catch (e) {
      print(e.toString());

      if (e == AesCryptExceptionType.destFileExists) {
        print(e.toString());
        // Handle the case where the destination file already exists
      } else {
        return 'ERROR';
      }
    }
    return encFilepath;
  }
}
