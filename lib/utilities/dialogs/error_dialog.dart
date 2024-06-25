import 'package:flutter/material.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
      context: context,
      title: context.loc.generic_error_prompt,
      content: text,
      optionBuilder: () => {
            context.loc.ok: null,
          });
}
