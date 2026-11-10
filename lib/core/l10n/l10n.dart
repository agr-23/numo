import 'package:flutter/widgets.dart';

import '../../data/models/account.dart';
import '../../data/models/category.dart';
import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Idiomas que ofrece Numo. El primero es el de respaldo.
const kSupportedLocales = [Locale('es'), Locale('en')];

extension L10nContext on BuildContext {
  /// Textos traducidos: `context.l10n.save`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Nombre visible de una categoría: las predefinidas se traducen por su
/// clave; las personalizadas muestran el nombre que escribió el usuario.
String categoryLabel(Category? c, AppLocalizations l10n) {
  if (c == null) return '';
  switch (c.key) {
    case 'food':
      return l10n.catFood;
    case 'transport':
      return l10n.catTransport;
    case 'groceries':
      return l10n.catGroceries;
    case 'health':
      return l10n.catHealth;
    case 'entertainment':
      return l10n.catEntertainment;
    case 'clothing':
      return l10n.catClothing;
    case 'education':
      return l10n.catEducation;
    case 'home':
      return l10n.catHome;
    case 'utilities':
      return l10n.catUtilities;
    case 'travel':
      return l10n.catTravel;
    case 'subscriptions':
      return l10n.catSubscriptions;
    case 'otherExpense':
      return l10n.catOtherExpense;
    case 'salary':
      return l10n.catSalary;
    case 'freelance':
      return l10n.catFreelance;
    case 'investments':
      return l10n.catInvestments;
    case 'otherIncome':
      return l10n.catOtherIncome;
    default:
      return c.name;
  }
}

/// Nombre de una moneda por su código ISO.
String currencyName(String code, AppLocalizations l10n) {
  switch (code) {
    case 'COP':
      return l10n.currencyCOP;
    case 'USD':
      return l10n.currencyUSD;
    case 'EUR':
      return l10n.currencyEUR;
    case 'MXN':
      return l10n.currencyMXN;
    case 'ARS':
      return l10n.currencyARS;
    case 'CLP':
      return l10n.currencyCLP;
    case 'PEN':
      return l10n.currencyPEN;
    case 'BRL':
      return l10n.currencyBRL;
    case 'GBP':
      return l10n.currencyGBP;
    case 'CAD':
      return l10n.currencyCAD;
    default:
      return code;
  }
}

String accountTypeLabel(AccountType type, AppLocalizations l10n) {
  switch (type) {
    case AccountType.cash:
      return l10n.accountTypeCash;
    case AccountType.bank:
      return l10n.accountTypeBank;
    case AccountType.credit:
      return l10n.accountTypeCredit;
  }
}
