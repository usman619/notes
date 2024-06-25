import 'package:flutter/material.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialogBuilder(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: context.loc.logout_button,
      content: context.loc.logout_dialog_prompt,
      optionBuilder: () => {
            context.loc.cancel: false,
            context.loc.logout_button: true,
          }).then((value) => value ?? false);
}
