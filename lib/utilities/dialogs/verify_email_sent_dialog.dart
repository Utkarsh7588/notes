import 'package:flutter/cupertino.dart';

import 'generic_dialog.dart';

Future<void> showVerifictionEmailSentDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Email Verification',
    content:
        'We have sent a verifiction email . Please check your email for more information and click restart once you verify and log in',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
