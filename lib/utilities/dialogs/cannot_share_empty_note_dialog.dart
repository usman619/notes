import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> CannotShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
