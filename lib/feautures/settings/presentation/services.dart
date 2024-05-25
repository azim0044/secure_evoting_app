import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

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
}
