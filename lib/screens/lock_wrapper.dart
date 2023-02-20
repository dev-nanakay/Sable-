import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sac_wallet/screens/pin/constants.dart';
import 'package:sac_wallet/screens/pin/verify_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class PinLockWrapper extends StatefulWidget {
  final Widget child;

  const PinLockWrapper({required this.child});

  @override
  _PinLockWrapperState createState() => _PinLockWrapperState();
}

class _PinLockWrapperState extends State<PinLockWrapper>
    with WidgetsBindingObserver {
  final pinLockMillis = PinConstants
      .PIN_LOCK_DURATION; // 2 seconds (if more than 2 seconds in background, then lock the app.

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _resumed();
        break;
      case AppLifecycleState.paused:
        _paused();
        break;
      case AppLifecycleState.inactive:
        _inactive();
        break;
      default:
        break;
    }
  }

  final lastKnownStateKey = 'lastKnownStateKey';

  Future _paused() async {
    final sp = await SharedPreferences.getInstance();
    sp.setInt(lastKnownStateKey, AppLifecycleState.paused.index);
  }

  final backgroundedTimeKey = 'backgroundedTimeKey';

  Future _inactive() async {
    final sp = await SharedPreferences.getInstance();
    final prevState = sp.getInt(lastKnownStateKey);
    final prevStateIsNotPaused = prevState != null &&
        AppLifecycleState.values[prevState] != AppLifecycleState.paused;
    if (prevStateIsNotPaused) {
      // save App backgrounded time to Shared preferences
      sp.setInt(backgroundedTimeKey, DateTime.now().millisecondsSinceEpoch);
    }
// update previous state as inactive
    sp.setInt(lastKnownStateKey, AppLifecycleState.inactive.index);
  }

  Future _resumed() async {
    final sp = await SharedPreferences.getInstance();
    final bgTime = sp.getInt(backgroundedTimeKey) ?? 0;
    final allowedBackgroundTime = bgTime + pinLockMillis;

    final shouldShowPIN =
        DateTime.now().millisecondsSinceEpoch > allowedBackgroundTime;
    if (shouldShowPIN) {
      // show PIN screen
      String result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => VerifyPin(
                  onDone: "RETURN",
                )),
      );
      if (result != "true") {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }

    sp.remove(backgroundedTimeKey); // clean
    sp.setInt(
        lastKnownStateKey, AppLifecycleState.resumed.index); // previous state
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
