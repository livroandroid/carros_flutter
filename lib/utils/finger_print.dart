import 'package:local_auth/local_auth.dart';

class FingerPrint {

  static Future<bool>  canCheckBiometrics() async {
    var localAuth = new LocalAuthentication();

    bool b =
    await localAuth.canCheckBiometrics;

    return false;
  }

  static Future<bool> verify() async {
    var localAuth = new LocalAuthentication();

    bool didAuthenticate =
    await localAuth.authenticateWithBiometrics(
        localizedReason: 'Toque no sensor para autenticar com sua digital.');

    if (didAuthenticate) {
      print("didAuthenticate");

      return true;
    } else {
      print("didAuthenticate");
    }

    return false;
  }
}