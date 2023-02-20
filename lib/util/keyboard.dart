import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class KeyBoardFunctions {
  static hideKeyBoard(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static KeyboardActionsConfig keyBoardDoneAction(
      BuildContext context, FocusNode _focusNodeOfTextView) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.white,
        nextFocus: true,
        actions: [KeyboardActionsItem(focusNode: _focusNodeOfTextView)]);
  }
}
