import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

extension Loc on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
