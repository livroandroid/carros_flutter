import 'dart:async';

import 'package:local_auth/local_auth.dart';

class FingerPrint {

  static Future<bool>  canCheckBiometrics() async {
    var localAuth = new LocalAuthentication();

    bool b =
    await localAuth.canCheckBiometrics;

    return b;
  }

  static Future<bool> verify() async {
    var localAuth = new LocalAuthentication();

    bool ok =
    await localAuth.authenticateWithBiometrics(
        localizedReason: 'Toque no sensor para autenticar com sua digital.');

    return ok;
  }
}