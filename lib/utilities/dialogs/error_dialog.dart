import 'package:flutter/cupertino.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
