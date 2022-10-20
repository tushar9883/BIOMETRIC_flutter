import 'package:biometric_fingerprint/biometric_fingerprint.dart';
import 'package:biometric_fingerprint/biometric_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = 'Unknown';
  bool _isAuthenticating = false;
  String _key = "";
  final _biometricFingerprintPlugin = BiometricFingerprint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _biometricFingerprintPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  _success() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Yey, success to authenticate data key: ${_key}',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            content: Text('is authentication: ${_isAuthenticating}',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          fontSize: 13))),
              TextButton(
                onPressed: () {
                  print(_isAuthenticating);
                  Navigator.pop(context);
                },
                child: Text('OK',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              )
            ],
          );
        });
  }

  _error() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('OOps, error to authenticate data key: ${_key}',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            content: Text('is authentication: ${_isAuthenticating}',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          fontSize: 13))),
              TextButton(
                onPressed: () {
                  print(_isAuthenticating);
                  Navigator.pop(context);
                },
                child: Text('OK',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              )
            ],
          );
        });
  }

  Future<void> CallFingerPrint() async {
    setState(() {
      _isAuthenticating = false;
    });
    BiometricResult result =
        await _biometricFingerprintPlugin.initAuthentication(
      biometricKey: 'example',
      message: 'Tushar',
      title: 'Tushar Demo',
      subtitle: 'Check data',
      description: 'Scan fingerprint.',
      negativeButtonText: 'CANCEL',
      confirmationRequired: true,
    );

    if (kDebugMode) {
      print(result.isSuccess);
    } // success
    if (kDebugMode) {
      print(result.isCanceled);
    } // cancel
    if (kDebugMode) {
      print(result.isFailed);
    } // failed

    if (result.isSuccess && result.hasData) {
      final key = result.data!;
      setState(() {
        _isAuthenticating = true;
        _key = key;
      });
      _success();
      return;
    }

    if (result.isFailed) {
      _error();
      setState(() {
        _key = result.errorMsg;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BIOMETRIC Demo For Tushar',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'poppins',
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 13),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 180,
            ),
            Center(
              child: IconButton(
                iconSize: 80,
                color: Colors.blue,
                icon: Icon(Icons.fingerprint),
                tooltip: _isAuthenticating
                    ? 'Login with fingerprint'
                    : 'Authenticating....',
                onPressed: () {
                  CallFingerPrint();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Try to press the icon fingerprint: $_platformVersion\n',
              style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'OS version: $_platformVersion\n',
              style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
