import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Numo — Finanzas personales simples'**
  String get appTagline;

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String appVersion(String version);

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @continueLabel.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueLabel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get undo;

  /// No description provided for @seeAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get seeAll;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @type.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @color.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @icon.
  ///
  /// In es, this message translates to:
  /// **'Icono'**
  String get icon;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get account;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get amount;

  /// No description provided for @note.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get note;

  /// No description provided for @noteOptional.
  ///
  /// In es, this message translates to:
  /// **'Nota (opcional)'**
  String get noteOptional;

  /// No description provided for @title.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get title;

  /// No description provided for @expense.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get income;

  /// No description provided for @transfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get transfer;

  /// No description provided for @expenses.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get expenses;

  /// No description provided for @incomes.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get incomes;

  /// No description provided for @transfers.
  ///
  /// In es, this message translates to:
  /// **'Transferencias'**
  String get transfers;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @balance.
  ///
  /// In es, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @available.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get available;

  /// No description provided for @debt.
  ///
  /// In es, this message translates to:
  /// **'Deuda'**
  String get debt;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In es, this message translates to:
  /// **'mañana'**
  String get tomorrow;

  /// No description provided for @todayLower.
  ///
  /// In es, this message translates to:
  /// **'hoy'**
  String get todayLower;

  /// No description provided for @inDays.
  ///
  /// In es, this message translates to:
  /// **'{days, plural, =1{en 1 día} other{en {days} días}}'**
  String inDays(int days);

  /// No description provided for @dayN.
  ///
  /// In es, this message translates to:
  /// **'Día {day}'**
  String dayN(int day);

  /// No description provided for @amountOf.
  ///
  /// In es, this message translates to:
  /// **'{part} de {total}'**
  String amountOf(String part, String total);

  /// No description provided for @amountMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un monto mayor a 0'**
  String get amountMustBePositive;

  /// No description provided for @selectCategory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una categoría'**
  String get selectCategory;

  /// No description provided for @selectAccount.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una cuenta'**
  String get selectAccount;

  /// No description provided for @writeName.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre'**
  String get writeName;

  /// No description provided for @greetingMorning.
  ///
  /// In es, this message translates to:
  /// **'Buenos días'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches'**
  String get greetingEvening;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get navTransactions;

  /// No description provided for @navAnalytics.
  ///
  /// In es, this message translates to:
  /// **'Analíticas'**
  String get navAnalytics;

  /// No description provided for @navAccounts.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get navAccounts;

  /// No description provided for @accountTypeCash.
  ///
  /// In es, this message translates to:
  /// **'Efectivo'**
  String get accountTypeCash;

  /// No description provided for @accountTypeBank.
  ///
  /// In es, this message translates to:
  /// **'Banco'**
  String get accountTypeBank;

  /// No description provided for @accountTypeCredit.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta de crédito'**
  String get accountTypeCredit;

  /// No description provided for @catFood.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get catTransport;

  /// No description provided for @catGroceries.
  ///
  /// In es, this message translates to:
  /// **'Mercado'**
  String get catGroceries;

  /// No description provided for @catHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get catHealth;

  /// No description provided for @catEntertainment.
  ///
  /// In es, this message translates to:
  /// **'Entretenimiento'**
  String get catEntertainment;

  /// No description provided for @catClothing.
  ///
  /// In es, this message translates to:
  /// **'Ropa'**
  String get catClothing;

  /// No description provided for @catEducation.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get catEducation;

  /// No description provided for @catHome.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get catHome;

  /// No description provided for @catUtilities.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get catUtilities;

  /// No description provided for @catTravel.
  ///
  /// In es, this message translates to:
  /// **'Viajes'**
  String get catTravel;

  /// No description provided for @catSubscriptions.
  ///
  /// In es, this message translates to:
  /// **'Suscripciones'**
  String get catSubscriptions;

  /// No description provided for @catOtherExpense.
  ///
  /// In es, this message translates to:
  /// **'Otros gastos'**
  String get catOtherExpense;

  /// No description provided for @catSalary.
  ///
  /// In es, this message translates to:
  /// **'Salario'**
  String get catSalary;

  /// No description provided for @catFreelance.
  ///
  /// In es, this message translates to:
  /// **'Freelance'**
  String get catFreelance;

  /// No description provided for @catInvestments.
  ///
  /// In es, this message translates to:
  /// **'Inversiones'**
  String get catInvestments;

  /// No description provided for @catOtherIncome.
  ///
  /// In es, this message translates to:
  /// **'Otros ingresos'**
  String get catOtherIncome;

  /// No description provided for @currencyCOP.
  ///
  /// In es, this message translates to:
  /// **'Peso colombiano'**
  String get currencyCOP;

  /// No description provided for @currencyUSD.
  ///
  /// In es, this message translates to:
  /// **'Dólar estadounidense'**
  String get currencyUSD;

  /// No description provided for @currencyEUR.
  ///
  /// In es, this message translates to:
  /// **'Euro'**
  String get currencyEUR;

  /// No description provided for @currencyMXN.
  ///
  /// In es, this message translates to:
  /// **'Peso mexicano'**
  String get currencyMXN;

  /// No description provided for @currencyARS.
  ///
  /// In es, this message translates to:
  /// **'Peso argentino'**
  String get currencyARS;

  /// No description provided for @currencyCLP.
  ///
  /// In es, this message translates to:
  /// **'Peso chileno'**
  String get currencyCLP;

  /// No description provided for @currencyPEN.
  ///
  /// In es, this message translates to:
  /// **'Sol peruano'**
  String get currencyPEN;

  /// No description provided for @currencyBRL.
  ///
  /// In es, this message translates to:
  /// **'Real brasileño'**
  String get currencyBRL;

  /// No description provided for @currencyGBP.
  ///
  /// In es, this message translates to:
  /// **'Libra esterlina'**
  String get currencyGBP;

  /// No description provided for @currencyCAD.
  ///
  /// In es, this message translates to:
  /// **'Dólar canadiense'**
  String get currencyCAD;

  /// No description provided for @languageSystem.
  ///
  /// In es, this message translates to:
  /// **'Automático (idioma del teléfono)'**
  String get languageSystem;

  /// No description provided for @languageEs.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @languageEn.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @unlockReason.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea Numo'**
  String get unlockReason;

  /// No description provided for @enterPin.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu PIN'**
  String get enterPin;

  /// No description provided for @wrongPin.
  ///
  /// In es, this message translates to:
  /// **'PIN incorrecto'**
  String get wrongPin;

  /// No description provided for @createPin.
  ///
  /// In es, this message translates to:
  /// **'Crea un PIN de 4 dígitos'**
  String get createPin;

  /// No description provided for @confirmPin.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu PIN'**
  String get confirmPin;

  /// No description provided for @confirmCurrentPin.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu PIN actual'**
  String get confirmCurrentPin;

  /// No description provided for @onbSkip.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get onbSkip;

  /// No description provided for @onbStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get onbStart;

  /// No description provided for @onbFinish.
  ///
  /// In es, this message translates to:
  /// **'¡Listo! Comenzar'**
  String get onbFinish;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus finanzas, por fin claras.'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In es, this message translates to:
  /// **'Registra gastos, controla presupuestos y ahorra hacia tus metas.'**
  String get onbWelcomeBody;

  /// No description provided for @onbLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get onbLanguage;

  /// No description provided for @onbFastTitle.
  ///
  /// In es, this message translates to:
  /// **'Registra en segundos'**
  String get onbFastTitle;

  /// No description provided for @onbFast1.
  ///
  /// In es, this message translates to:
  /// **'Teclado rápido: monto, categoría y listo'**
  String get onbFast1;

  /// No description provided for @onbFast2.
  ///
  /// In es, this message translates to:
  /// **'Movimientos recurrentes automáticos'**
  String get onbFast2;

  /// No description provided for @onbFast3.
  ///
  /// In es, this message translates to:
  /// **'Transferencias y pagos entre tus cuentas'**
  String get onbFast3;

  /// No description provided for @onbControlTitle.
  ///
  /// In es, this message translates to:
  /// **'Controla, ahorra y protege'**
  String get onbControlTitle;

  /// No description provided for @onbControl1.
  ///
  /// In es, this message translates to:
  /// **'Presupuestos con alertas al 80 %'**
  String get onbControl1;

  /// No description provided for @onbControl2.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas con cupo, corte y fecha de pago'**
  String get onbControl2;

  /// No description provided for @onbControl3.
  ///
  /// In es, this message translates to:
  /// **'Metas de ahorro con tu progreso'**
  String get onbControl3;

  /// No description provided for @onbControl4.
  ///
  /// In es, this message translates to:
  /// **'Todo queda en tu teléfono, con PIN o huella'**
  String get onbControl4;

  /// No description provided for @onbCurrencyTitle.
  ///
  /// In es, this message translates to:
  /// **'¿En qué moneda llevas tus finanzas?'**
  String get onbCurrencyTitle;

  /// No description provided for @onbCurrencyPreview.
  ///
  /// In es, this message translates to:
  /// **'Así se verán tus montos:'**
  String get onbCurrencyPreview;

  /// No description provided for @onbAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se llama tu primera cuenta?'**
  String get onbAccountTitle;

  /// No description provided for @onbAccountHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Mi billetera, Bancolombia'**
  String get onbAccountHint;

  /// No description provided for @onbAccountNameMissing.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre a tu primera cuenta'**
  String get onbAccountNameMissing;

  /// No description provided for @onbLimitOptional.
  ///
  /// In es, this message translates to:
  /// **'Cupo total (opcional)'**
  String get onbLimitOptional;

  /// No description provided for @onbDebtOptional.
  ///
  /// In es, this message translates to:
  /// **'Deuda actual (opcional)'**
  String get onbDebtOptional;

  /// No description provided for @onbDatesLater.
  ///
  /// In es, this message translates to:
  /// **'Las fechas de corte y pago se configuran luego en la cuenta'**
  String get onbDatesLater;

  /// No description provided for @onbBalanceOptional.
  ///
  /// In es, this message translates to:
  /// **'Balance inicial (opcional)'**
  String get onbBalanceOptional;

  /// No description provided for @dashBudgets.
  ///
  /// In es, this message translates to:
  /// **'Presupuestos'**
  String get dashBudgets;

  /// No description provided for @dashSavingsGoals.
  ///
  /// In es, this message translates to:
  /// **'Metas de ahorro'**
  String get dashSavingsGoals;

  /// No description provided for @dashRecent.
  ///
  /// In es, this message translates to:
  /// **'Últimos movimientos'**
  String get dashRecent;

  /// No description provided for @dashNoTransactions.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay movimientos'**
  String get dashNoTransactions;

  /// No description provided for @dashNetBalanceLine.
  ///
  /// In es, this message translates to:
  /// **'Balance neto: {amount}'**
  String dashNetBalanceLine(String amount);

  /// No description provided for @ovNetBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance neto'**
  String get ovNetBalance;

  /// No description provided for @ovMonthIncome.
  ///
  /// In es, this message translates to:
  /// **'ingresos del mes'**
  String get ovMonthIncome;

  /// No description provided for @ovMonthExpense.
  ///
  /// In es, this message translates to:
  /// **'gastos del mes'**
  String get ovMonthExpense;

  /// No description provided for @ovTotalMoney.
  ///
  /// In es, this message translates to:
  /// **'Dinero total'**
  String get ovTotalMoney;

  /// No description provided for @ovInAccounts.
  ///
  /// In es, this message translates to:
  /// **'en cuentas'**
  String get ovInAccounts;

  /// No description provided for @ovInGoals.
  ///
  /// In es, this message translates to:
  /// **'en metas'**
  String get ovInGoals;

  /// No description provided for @ovDebts.
  ///
  /// In es, this message translates to:
  /// **'Deudas'**
  String get ovDebts;

  /// No description provided for @ovNoCards.
  ///
  /// In es, this message translates to:
  /// **'No tienes tarjetas de crédito'**
  String get ovNoCards;

  /// No description provided for @ovAvailableCredit.
  ///
  /// In es, this message translates to:
  /// **'cupo disponible'**
  String get ovAvailableCredit;

  /// No description provided for @ovPaymentOf.
  ///
  /// In es, this message translates to:
  /// **'pago {card}'**
  String ovPaymentOf(String card);

  /// No description provided for @ovSavedInGoals.
  ///
  /// In es, this message translates to:
  /// **'Ahorrado en metas'**
  String get ovSavedInGoals;

  /// No description provided for @ovCreateFirstGoal.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera meta de ahorro'**
  String get ovCreateFirstGoal;

  /// No description provided for @ovGoalTarget.
  ///
  /// In es, this message translates to:
  /// **'objetivo, {percent} %'**
  String ovGoalTarget(String percent);

  /// No description provided for @ovCompleted.
  ///
  /// In es, this message translates to:
  /// **'completadas'**
  String get ovCompleted;

  /// No description provided for @txTitle.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get txTitle;

  /// No description provided for @txSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar…'**
  String get txSearch;

  /// No description provided for @txNoMatches.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos con esos filtros'**
  String get txNoMatches;

  /// No description provided for @txAddFirst.
  ///
  /// In es, this message translates to:
  /// **'Agregar el primero'**
  String get txAddFirst;

  /// No description provided for @txDeleted.
  ///
  /// In es, this message translates to:
  /// **'Movimiento eliminado'**
  String get txDeleted;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @dateRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de fechas'**
  String get dateRange;

  /// No description provided for @anyDate.
  ///
  /// In es, this message translates to:
  /// **'Cualquier fecha'**
  String get anyDate;

  /// No description provided for @removeRange.
  ///
  /// In es, this message translates to:
  /// **'Quitar rango'**
  String get removeRange;

  /// No description provided for @applyFilters.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get applyFilters;

  /// No description provided for @addTxNew.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get addTxNew;

  /// No description provided for @addTxEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar movimiento'**
  String get addTxEdit;

  /// No description provided for @addTxTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Almuerzo'**
  String get addTxTitleHint;

  /// No description provided for @addTxFromAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta origen'**
  String get addTxFromAccount;

  /// No description provided for @addTxToAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta destino'**
  String get addTxToAccount;

  /// No description provided for @addTxPickAccount.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una cuenta'**
  String get addTxPickAccount;

  /// No description provided for @addTxAvailableCredit.
  ///
  /// In es, this message translates to:
  /// **'Cupo disponible: {amount}'**
  String addTxAvailableCredit(String amount);

  /// No description provided for @addTxRecurring.
  ///
  /// In es, this message translates to:
  /// **'Recurrente'**
  String get addTxRecurring;

  /// No description provided for @freqDaily.
  ///
  /// In es, this message translates to:
  /// **'Diario'**
  String get freqDaily;

  /// No description provided for @freqWeekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get freqWeekly;

  /// No description provided for @freqMonthly.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get freqMonthly;

  /// No description provided for @freqYearly.
  ///
  /// In es, this message translates to:
  /// **'Anual'**
  String get freqYearly;

  /// No description provided for @addTxEndsOn.
  ///
  /// In es, this message translates to:
  /// **'Termina el'**
  String get addTxEndsOn;

  /// No description provided for @addTxNoEnd.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha de fin'**
  String get addTxNoEnd;

  /// No description provided for @addTxSaveExpense.
  ///
  /// In es, this message translates to:
  /// **'Guardar gasto'**
  String get addTxSaveExpense;

  /// No description provided for @addTxSaveIncome.
  ///
  /// In es, this message translates to:
  /// **'Guardar ingreso'**
  String get addTxSaveIncome;

  /// No description provided for @addTxDoTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferir'**
  String get addTxDoTransfer;

  /// No description provided for @addTxDifferentDestination.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una cuenta destino distinta'**
  String get addTxDifferentDestination;

  /// No description provided for @addTxWriteTitle.
  ///
  /// In es, this message translates to:
  /// **'Escribe un título'**
  String get addTxWriteTitle;

  /// No description provided for @addTxOverLimitTitle.
  ///
  /// In es, this message translates to:
  /// **'Supera el cupo'**
  String get addTxOverLimitTitle;

  /// No description provided for @addTxOverLimitBody.
  ///
  /// In es, this message translates to:
  /// **'Este gasto supera el cupo disponible de \"{account}\" ({amount}). ¿Guardarlo igual?'**
  String addTxOverLimitBody(String account, String amount);

  /// No description provided for @addTxSaveAnyway.
  ///
  /// In es, this message translates to:
  /// **'Guardar igual'**
  String get addTxSaveAnyway;

  /// No description provided for @addTxSavedExpense.
  ///
  /// In es, this message translates to:
  /// **'Gasto guardado'**
  String get addTxSavedExpense;

  /// No description provided for @addTxSavedIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingreso guardado'**
  String get addTxSavedIncome;

  /// No description provided for @addTxSavedTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia realizada'**
  String get addTxSavedTransfer;

  /// No description provided for @anTitle.
  ///
  /// In es, this message translates to:
  /// **'Analíticas'**
  String get anTitle;

  /// No description provided for @anByCategory.
  ///
  /// In es, this message translates to:
  /// **'Gastos por categoría'**
  String get anByCategory;

  /// No description provided for @anSeriesWeeks.
  ///
  /// In es, this message translates to:
  /// **'Ingresos y gastos (6 semanas)'**
  String get anSeriesWeeks;

  /// No description provided for @anSeriesMonths.
  ///
  /// In es, this message translates to:
  /// **'Ingresos y gastos (6 meses)'**
  String get anSeriesMonths;

  /// No description provided for @anRanking.
  ///
  /// In es, this message translates to:
  /// **'Ranking de categorías'**
  String get anRanking;

  /// No description provided for @anThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get anThisWeek;

  /// No description provided for @anThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Este mes'**
  String get anThisMonth;

  /// No description provided for @anThisYear.
  ///
  /// In es, this message translates to:
  /// **'Este año'**
  String get anThisYear;

  /// No description provided for @anCustom.
  ///
  /// In es, this message translates to:
  /// **'Personalizado'**
  String get anCustom;

  /// No description provided for @anNoExpenses.
  ///
  /// In es, this message translates to:
  /// **'Sin gastos en este período'**
  String get anNoExpenses;

  /// No description provided for @anTotal.
  ///
  /// In es, this message translates to:
  /// **'Total\n{amount}'**
  String anTotal(String amount);

  /// No description provided for @anNoChartData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos para el gráfico'**
  String get anNoChartData;

  /// No description provided for @accTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis cuentas'**
  String get accTitle;

  /// No description provided for @accAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar cuenta'**
  String get accAdd;

  /// No description provided for @accNone.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes cuentas'**
  String get accNone;

  /// No description provided for @accCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get accCreate;

  /// No description provided for @accNetTotal.
  ///
  /// In es, this message translates to:
  /// **'Balance neto total'**
  String get accNetTotal;

  /// No description provided for @accArchiveTitle.
  ///
  /// In es, this message translates to:
  /// **'Archivar cuenta'**
  String get accArchiveTitle;

  /// No description provided for @accArchiveBody.
  ///
  /// In es, this message translates to:
  /// **'La cuenta \"{name}\" se archivará. Su historial se conserva, pero ya no aparecerá en las listas.'**
  String accArchiveBody(String name);

  /// No description provided for @accArchive.
  ///
  /// In es, this message translates to:
  /// **'Archivar'**
  String get accArchive;

  /// No description provided for @accNotFound.
  ///
  /// In es, this message translates to:
  /// **'Cuenta no encontrada'**
  String get accNotFound;

  /// No description provided for @accEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar cuenta'**
  String get accEdit;

  /// No description provided for @accNoTransactions.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta no tiene movimientos'**
  String get accNoTransactions;

  /// No description provided for @accBalanceAvailable.
  ///
  /// In es, this message translates to:
  /// **'Saldo disponible'**
  String get accBalanceAvailable;

  /// No description provided for @accCreditAvailable.
  ///
  /// In es, this message translates to:
  /// **'Cupo disponible'**
  String get accCreditAvailable;

  /// No description provided for @accCurrentDebt.
  ///
  /// In es, this message translates to:
  /// **'Deuda actual'**
  String get accCurrentDebt;

  /// No description provided for @accCreditLimit.
  ///
  /// In es, this message translates to:
  /// **'Cupo total'**
  String get accCreditLimit;

  /// No description provided for @accStatementDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de corte'**
  String get accStatementDate;

  /// No description provided for @accPaymentDue.
  ///
  /// In es, this message translates to:
  /// **'Límite de pago'**
  String get accPaymentDue;

  /// No description provided for @accNotSet.
  ///
  /// In es, this message translates to:
  /// **'Sin configurar'**
  String get accNotSet;

  /// No description provided for @accCompleteHint.
  ///
  /// In es, this message translates to:
  /// **'Toca el lápiz de arriba para completar cupo y fechas.'**
  String get accCompleteHint;

  /// No description provided for @accPayCard.
  ///
  /// In es, this message translates to:
  /// **'Pagar tarjeta'**
  String get accPayCard;

  /// No description provided for @accDebtAmount.
  ///
  /// In es, this message translates to:
  /// **'Deuda {amount}'**
  String accDebtAmount(String amount);

  /// No description provided for @accLimitAmount.
  ///
  /// In es, this message translates to:
  /// **'Cupo {amount}'**
  String accLimitAmount(String amount);

  /// No description provided for @accNew.
  ///
  /// In es, this message translates to:
  /// **'Nueva cuenta'**
  String get accNew;

  /// No description provided for @accNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Bancolombia'**
  String get accNameHint;

  /// No description provided for @accLimitHelper.
  ///
  /// In es, this message translates to:
  /// **'El límite de crédito de la tarjeta'**
  String get accLimitHelper;

  /// No description provided for @accDebtHelper.
  ///
  /// In es, this message translates to:
  /// **'Lo que ya debes hoy. Los gastos la aumentan.'**
  String get accDebtHelper;

  /// No description provided for @accStatementDay.
  ///
  /// In es, this message translates to:
  /// **'Día de corte'**
  String get accStatementDay;

  /// No description provided for @accPaymentDay.
  ///
  /// In es, this message translates to:
  /// **'Día límite de pago'**
  String get accPaymentDay;

  /// No description provided for @accCurrentBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo actual'**
  String get accCurrentBalance;

  /// No description provided for @accInitialBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance inicial'**
  String get accInitialBalance;

  /// No description provided for @accSaveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get accSaveChanges;

  /// No description provided for @accNameMissing.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para la cuenta'**
  String get accNameMissing;

  /// No description provided for @accLimitMissing.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el cupo total de la tarjeta'**
  String get accLimitMissing;

  /// No description provided for @budTitle.
  ///
  /// In es, this message translates to:
  /// **'Presupuestos'**
  String get budTitle;

  /// No description provided for @budNone.
  ///
  /// In es, this message translates to:
  /// **'Sin presupuestos para este mes'**
  String get budNone;

  /// No description provided for @budCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear presupuesto'**
  String get budCreate;

  /// No description provided for @budTotal.
  ///
  /// In es, this message translates to:
  /// **'Total presupuestado'**
  String get budTotal;

  /// No description provided for @budSpent.
  ///
  /// In es, this message translates to:
  /// **'Gastado'**
  String get budSpent;

  /// No description provided for @budDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar presupuesto'**
  String get budDeleteTitle;

  /// No description provided for @budDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar el presupuesto de \"{name}\"?'**
  String budDeleteBody(String name);

  /// No description provided for @budNoCategoryExpenses.
  ///
  /// In es, this message translates to:
  /// **'Sin gastos en esta categoría'**
  String get budNoCategoryExpenses;

  /// No description provided for @budSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'{category}, {month}'**
  String budSheetTitle(String category, String month);

  /// No description provided for @budExceeded.
  ///
  /// In es, this message translates to:
  /// **'Excedido'**
  String get budExceeded;

  /// No description provided for @budNearLimit.
  ///
  /// In es, this message translates to:
  /// **'Cerca del límite'**
  String get budNearLimit;

  /// No description provided for @budSpentOf.
  ///
  /// In es, this message translates to:
  /// **'Gastado {spent} de {limit}'**
  String budSpentOf(String spent, String limit);

  /// No description provided for @budShort.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get budShort;

  /// No description provided for @budNew.
  ///
  /// In es, this message translates to:
  /// **'Nuevo presupuesto'**
  String get budNew;

  /// No description provided for @budLimit.
  ///
  /// In es, this message translates to:
  /// **'Monto límite'**
  String get budLimit;

  /// No description provided for @budMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get budMonth;

  /// No description provided for @budPickMonth.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un mes'**
  String get budPickMonth;

  /// No description provided for @budSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar presupuesto'**
  String get budSave;

  /// No description provided for @budExistsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ya existe un presupuesto'**
  String get budExistsTitle;

  /// No description provided for @budExistsBody.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes un presupuesto para \"{category}\" en {month}. ¿Reemplazarlo?'**
  String budExistsBody(String category, String month);

  /// No description provided for @budReplace.
  ///
  /// In es, this message translates to:
  /// **'Reemplazar'**
  String get budReplace;

  /// No description provided for @goalTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis metas'**
  String get goalTitle;

  /// No description provided for @goalNone.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes metas de ahorro'**
  String get goalNone;

  /// No description provided for @goalCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear meta'**
  String get goalCreate;

  /// No description provided for @goalCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get goalCompleted;

  /// No description provided for @goalSavedOf.
  ///
  /// In es, this message translates to:
  /// **'Ahorrado {saved} de {target}'**
  String goalSavedOf(String saved, String target);

  /// No description provided for @goalOverdue.
  ///
  /// In es, this message translates to:
  /// **'Fecha límite vencida'**
  String get goalOverdue;

  /// No description provided for @goalDueToday.
  ///
  /// In es, this message translates to:
  /// **'Vence hoy'**
  String get goalDueToday;

  /// No description provided for @goalDaysLeft.
  ///
  /// In es, this message translates to:
  /// **'{days, plural, =1{Queda 1 día} other{Quedan {days} días}}'**
  String goalDaysLeft(int days);

  /// No description provided for @goalContribute.
  ///
  /// In es, this message translates to:
  /// **'Aportar'**
  String get goalContribute;

  /// No description provided for @goalNew.
  ///
  /// In es, this message translates to:
  /// **'Nueva meta'**
  String get goalNew;

  /// No description provided for @goalNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Viaje a Cartagena'**
  String get goalNameHint;

  /// No description provided for @goalTarget.
  ///
  /// In es, this message translates to:
  /// **'Monto objetivo'**
  String get goalTarget;

  /// No description provided for @goalDeadlineOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha límite (opcional)'**
  String get goalDeadlineOptional;

  /// No description provided for @goalNoDate.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get goalNoDate;

  /// No description provided for @goalInitialOptional.
  ///
  /// In es, this message translates to:
  /// **'Monto ya ahorrado (opcional)'**
  String get goalInitialOptional;

  /// No description provided for @goalNameMissing.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para la meta'**
  String get goalNameMissing;

  /// No description provided for @goalTargetMissing.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un monto objetivo mayor a 0'**
  String get goalTargetMissing;

  /// No description provided for @goalContributeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto quieres aportar a \"{name}\"?'**
  String goalContributeQuestion(String name);

  /// No description provided for @setTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get setTitle;

  /// No description provided for @setSecurity.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get setSecurity;

  /// No description provided for @setPin.
  ///
  /// In es, this message translates to:
  /// **'PIN de acceso'**
  String get setPin;

  /// No description provided for @setChangePin.
  ///
  /// In es, this message translates to:
  /// **'Cambiar PIN'**
  String get setChangePin;

  /// No description provided for @setBiometric.
  ///
  /// In es, this message translates to:
  /// **'Huella dactilar'**
  String get setBiometric;

  /// No description provided for @setBiometricNeedsPin.
  ///
  /// In es, this message translates to:
  /// **'Requiere un PIN activo'**
  String get setBiometricNeedsPin;

  /// No description provided for @setAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get setAppearance;

  /// No description provided for @setThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get setThemeLight;

  /// No description provided for @setThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get setThemeDark;

  /// No description provided for @setThemeAuto.
  ///
  /// In es, this message translates to:
  /// **'Auto'**
  String get setThemeAuto;

  /// No description provided for @setLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get setLanguage;

  /// No description provided for @setFinance.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get setFinance;

  /// No description provided for @setCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get setCurrency;

  /// No description provided for @setMonthStart.
  ///
  /// In es, this message translates to:
  /// **'Primer día del mes'**
  String get setMonthStart;

  /// No description provided for @setManageCategories.
  ///
  /// In es, this message translates to:
  /// **'Administrar categorías'**
  String get setManageCategories;

  /// No description provided for @setData.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get setData;

  /// No description provided for @setExport.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis datos'**
  String get setExport;

  /// No description provided for @setExportSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Genera un CSV con todos tus movimientos'**
  String get setExportSubtitle;

  /// No description provided for @setExportFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo exportar: {error}'**
  String setExportFailed(String error);

  /// No description provided for @setDeleteAll.
  ///
  /// In es, this message translates to:
  /// **'Borrar todos los datos'**
  String get setDeleteAll;

  /// No description provided for @setDeleteAllBody.
  ///
  /// In es, this message translates to:
  /// **'Esto eliminará todas tus cuentas, movimientos, presupuestos y metas. Esta acción no se puede deshacer.'**
  String get setDeleteAllBody;

  /// No description provided for @setFinalConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmación final'**
  String get setFinalConfirm;

  /// No description provided for @setTypeToConfirm.
  ///
  /// In es, this message translates to:
  /// **'Escribe {word} para confirmar:'**
  String setTypeToConfirm(String word);

  /// No description provided for @setConfirmWord.
  ///
  /// In es, this message translates to:
  /// **'BORRAR'**
  String get setConfirmWord;

  /// No description provided for @setDeleteEverything.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get setDeleteEverything;

  /// No description provided for @setAllDeleted.
  ///
  /// In es, this message translates to:
  /// **'Todos los datos fueron borrados'**
  String get setAllDeleted;

  /// No description provided for @setAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get setAbout;

  /// No description provided for @catCustom.
  ///
  /// In es, this message translates to:
  /// **'Personalizada'**
  String get catCustom;

  /// No description provided for @catPredefined.
  ///
  /// In es, this message translates to:
  /// **'Predefinida'**
  String get catPredefined;

  /// No description provided for @catCannotDelete.
  ///
  /// In es, this message translates to:
  /// **'Las categorías predefinidas no se pueden borrar'**
  String get catCannotDelete;

  /// No description provided for @catNew.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get catNew;

  /// No description provided for @catCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear categoría'**
  String get catCreate;

  /// No description provided for @exportSubject.
  ///
  /// In es, this message translates to:
  /// **'Exportación de Numo'**
  String get exportSubject;

  /// No description provided for @exportText.
  ///
  /// In es, this message translates to:
  /// **'Mis movimientos de Numo'**
  String get exportText;

  /// No description provided for @exportDestAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta destino'**
  String get exportDestAccount;

  /// No description provided for @ovNetFormula.
  ///
  /// In es, this message translates to:
  /// **'Cuentas − deudas'**
  String get ovNetFormula;

  /// No description provided for @ovIncomeArrow.
  ///
  /// In es, this message translates to:
  /// **'↑ {amount} ingresos'**
  String ovIncomeArrow(String amount);

  /// No description provided for @ovExpenseArrow.
  ///
  /// In es, this message translates to:
  /// **'↓ {amount} gastos'**
  String ovExpenseArrow(String amount);

  /// No description provided for @ovMoneySub.
  ///
  /// In es, this message translates to:
  /// **'{accounts} en cuentas y {goals} en metas'**
  String ovMoneySub(String accounts, String goals);

  /// No description provided for @ovDebtNext.
  ///
  /// In es, this message translates to:
  /// **'{card} se paga el {date}'**
  String ovDebtNext(String card, String date);

  /// No description provided for @ovGoalsSub.
  ///
  /// In es, this message translates to:
  /// **'{percent} % de {target}'**
  String ovGoalsSub(String percent, String target);

  /// No description provided for @dashHideAmounts.
  ///
  /// In es, this message translates to:
  /// **'Ocultar montos'**
  String get dashHideAmounts;

  /// No description provided for @dashShowAmounts.
  ///
  /// In es, this message translates to:
  /// **'Mostrar montos'**
  String get dashShowAmounts;

  /// No description provided for @actPay.
  ///
  /// In es, this message translates to:
  /// **'Pagar'**
  String get actPay;

  /// No description provided for @dashCreateBudget.
  ///
  /// In es, this message translates to:
  /// **'Crear un presupuesto'**
  String get dashCreateBudget;

  /// No description provided for @addTxHowMuchExpense.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto gastaste?'**
  String get addTxHowMuchExpense;

  /// No description provided for @addTxHowMuchIncome.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto recibiste?'**
  String get addTxHowMuchIncome;

  /// No description provided for @addTxHowMuchTransfer.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto vas a mover?'**
  String get addTxHowMuchTransfer;

  /// No description provided for @addTxRepeat.
  ///
  /// In es, this message translates to:
  /// **'Repetir'**
  String get addTxRepeat;

  /// No description provided for @addTxRepeatNever.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get addTxRepeatNever;

  /// No description provided for @addTxFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get addTxFrom;

  /// No description provided for @addTxTo.
  ///
  /// In es, this message translates to:
  /// **'Hacia'**
  String get addTxTo;

  /// No description provided for @addTxAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get addTxAdd;

  /// No description provided for @addTxRepeatUntil.
  ///
  /// In es, this message translates to:
  /// **'{frequency}, hasta el {date}'**
  String addTxRepeatUntil(String frequency, String date);

  /// No description provided for @accBalanceShort.
  ///
  /// In es, this message translates to:
  /// **'Saldo {amount}'**
  String accBalanceShort(String amount);

  /// No description provided for @svTitle.
  ///
  /// In es, this message translates to:
  /// **'Ahorros'**
  String get svTitle;

  /// No description provided for @svTotalSetAside.
  ///
  /// In es, this message translates to:
  /// **'Total apartado'**
  String get svTotalSetAside;

  /// No description provided for @svOfTotal.
  ///
  /// In es, this message translates to:
  /// **'de {target} entre {count, plural, =1{tu grupo} other{tus {count} grupos}}'**
  String svOfTotal(String target, int count);

  /// No description provided for @svGroups.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get svGroups;

  /// No description provided for @svTapGroup.
  ///
  /// In es, this message translates to:
  /// **'Toca uno para ver sus bolsillos'**
  String get svTapGroup;

  /// No description provided for @svCreateGroup.
  ///
  /// In es, this message translates to:
  /// **'Crear grupo'**
  String get svCreateGroup;

  /// No description provided for @svEmpty.
  ///
  /// In es, this message translates to:
  /// **'Separa tu dinero por propósitos: el carro, un viaje, emergencias.'**
  String get svEmpty;

  /// No description provided for @svPocketCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin bolsillos} =1{1 bolsillo} other{{count} bolsillos}}'**
  String svPocketCount(int count);

  /// No description provided for @svDueHint.
  ///
  /// In es, this message translates to:
  /// **'{pocket} vence el {date}: te faltan {amount}'**
  String svDueHint(String pocket, String date, String amount);

  /// No description provided for @svAllDone.
  ///
  /// In es, this message translates to:
  /// **'Todo completo'**
  String get svAllDone;

  /// No description provided for @svSetAside.
  ///
  /// In es, this message translates to:
  /// **'Apartado'**
  String get svSetAside;

  /// No description provided for @svOfPockets.
  ///
  /// In es, this message translates to:
  /// **'de {target} sumando {count, plural, =1{su bolsillo} other{sus {count} bolsillos}}'**
  String svOfPockets(String target, int count);

  /// No description provided for @svDistribute.
  ///
  /// In es, this message translates to:
  /// **'Repartir aporte'**
  String get svDistribute;

  /// No description provided for @svSectionMonthly.
  ///
  /// In es, this message translates to:
  /// **'Cada mes'**
  String get svSectionMonthly;

  /// No description provided for @svSectionYearly.
  ///
  /// In es, this message translates to:
  /// **'Una vez al año'**
  String get svSectionYearly;

  /// No description provided for @svSectionGoals.
  ///
  /// In es, this message translates to:
  /// **'Metas'**
  String get svSectionGoals;

  /// No description provided for @svMonthlyNote.
  ///
  /// In es, this message translates to:
  /// **'Se recargan el día 1. Lo que no gastes pasa al mes siguiente.'**
  String get svMonthlyNote;

  /// No description provided for @svAddPocket.
  ///
  /// In es, this message translates to:
  /// **'Agregar bolsillo'**
  String get svAddPocket;

  /// No description provided for @svDueOn.
  ///
  /// In es, this message translates to:
  /// **'Vence el {date}'**
  String svDueOn(String date);

  /// No description provided for @svDueSuggest.
  ///
  /// In es, this message translates to:
  /// **'Vence el {date}. Aparta {amount} al mes'**
  String svDueSuggest(String date, String amount);

  /// No description provided for @svSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Bolsillos sugeridos'**
  String get svSuggestions;

  /// No description provided for @svNewGroup.
  ///
  /// In es, this message translates to:
  /// **'Nuevo grupo'**
  String get svNewGroup;

  /// No description provided for @svEditGroup.
  ///
  /// In es, this message translates to:
  /// **'Editar grupo'**
  String get svEditGroup;

  /// No description provided for @svDeleteGroup.
  ///
  /// In es, this message translates to:
  /// **'Eliminar grupo'**
  String get svDeleteGroup;

  /// No description provided for @svDeleteGroupBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán sus bolsillos. Lo apartado vuelve a estar disponible en tus cuentas.'**
  String get svDeleteGroupBody;

  /// No description provided for @svTemplates.
  ///
  /// In es, this message translates to:
  /// **'Empieza con una plantilla'**
  String get svTemplates;

  /// No description provided for @tplCar.
  ///
  /// In es, this message translates to:
  /// **'Carro'**
  String get tplCar;

  /// No description provided for @tplHome.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get tplHome;

  /// No description provided for @tplTrip.
  ///
  /// In es, this message translates to:
  /// **'Viaje'**
  String get tplTrip;

  /// No description provided for @tplEmergency.
  ///
  /// In es, this message translates to:
  /// **'Fondo de emergencia'**
  String get tplEmergency;

  /// No description provided for @tplCustom.
  ///
  /// In es, this message translates to:
  /// **'Personalizado'**
  String get tplCustom;

  /// No description provided for @tplFuel.
  ///
  /// In es, this message translates to:
  /// **'Gasolina'**
  String get tplFuel;

  /// No description provided for @tplParking.
  ///
  /// In es, this message translates to:
  /// **'Parqueaderos'**
  String get tplParking;

  /// No description provided for @tplTolls.
  ///
  /// In es, this message translates to:
  /// **'Peajes'**
  String get tplTolls;

  /// No description provided for @tplInsurance.
  ///
  /// In es, this message translates to:
  /// **'SOAT'**
  String get tplInsurance;

  /// No description provided for @tplInspection.
  ///
  /// In es, this message translates to:
  /// **'Técnico-mecánica'**
  String get tplInspection;

  /// No description provided for @tplVehicleTax.
  ///
  /// In es, this message translates to:
  /// **'Impuesto vehicular'**
  String get tplVehicleTax;

  /// No description provided for @tplRent.
  ///
  /// In es, this message translates to:
  /// **'Arriendo'**
  String get tplRent;

  /// No description provided for @tplUtilities.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get tplUtilities;

  /// No description provided for @tplMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get tplMaintenance;

  /// No description provided for @tplPropertyTax.
  ///
  /// In es, this message translates to:
  /// **'Impuesto predial'**
  String get tplPropertyTax;

  /// No description provided for @tplFlights.
  ///
  /// In es, this message translates to:
  /// **'Tiquetes'**
  String get tplFlights;

  /// No description provided for @tplLodging.
  ///
  /// In es, this message translates to:
  /// **'Hospedaje'**
  String get tplLodging;

  /// No description provided for @tplTripSpending.
  ///
  /// In es, this message translates to:
  /// **'Gastos del viaje'**
  String get tplTripSpending;

  /// No description provided for @tplEmergencyPocket.
  ///
  /// In es, this message translates to:
  /// **'Fondo'**
  String get tplEmergencyPocket;

  /// No description provided for @svNewPocket.
  ///
  /// In es, this message translates to:
  /// **'Nuevo bolsillo'**
  String get svNewPocket;

  /// No description provided for @svEditPocket.
  ///
  /// In es, this message translates to:
  /// **'Editar bolsillo'**
  String get svEditPocket;

  /// No description provided for @svDeletePocket.
  ///
  /// In es, this message translates to:
  /// **'Eliminar bolsillo'**
  String get svDeletePocket;

  /// No description provided for @svDeletePocketBody.
  ///
  /// In es, this message translates to:
  /// **'Lo apartado ({amount}) vuelve a estar disponible en tu cuenta.'**
  String svDeletePocketBody(String amount);

  /// No description provided for @svKindGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta'**
  String get svKindGoal;

  /// No description provided for @svKindMonthly.
  ///
  /// In es, this message translates to:
  /// **'Cada mes'**
  String get svKindMonthly;

  /// No description provided for @svKindYearly.
  ///
  /// In es, this message translates to:
  /// **'Cada año'**
  String get svKindYearly;

  /// No description provided for @svAmountMonthly.
  ///
  /// In es, this message translates to:
  /// **'Monto por mes'**
  String get svAmountMonthly;

  /// No description provided for @svAmountYearly.
  ///
  /// In es, this message translates to:
  /// **'Monto anual'**
  String get svAmountYearly;

  /// No description provided for @svNextDue.
  ///
  /// In es, this message translates to:
  /// **'Próximo vencimiento'**
  String get svNextDue;

  /// No description provided for @svPickDate.
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get svPickDate;

  /// No description provided for @svDueRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la fecha de vencimiento'**
  String get svDueRequired;

  /// No description provided for @svFromAccount.
  ///
  /// In es, this message translates to:
  /// **'Apartar desde'**
  String get svFromAccount;

  /// No description provided for @svNoAccount.
  ///
  /// In es, this message translates to:
  /// **'Sin cuenta'**
  String get svNoAccount;

  /// No description provided for @svContributeTo.
  ///
  /// In es, this message translates to:
  /// **'Aportar a {pocket}'**
  String svContributeTo(String pocket);

  /// No description provided for @svProgress.
  ///
  /// In es, this message translates to:
  /// **'Llevas {saved} de {target}'**
  String svProgress(String saved, String target);

  /// No description provided for @svSuggested.
  ///
  /// In es, this message translates to:
  /// **'Sugerido {amount}'**
  String svSuggested(String amount);

  /// No description provided for @svFill.
  ///
  /// In es, this message translates to:
  /// **'Completar {amount}'**
  String svFill(String amount);

  /// No description provided for @svSetAsideNote.
  ///
  /// In es, this message translates to:
  /// **'El dinero sigue en {account}, pero deja de contar como disponible para gastar.'**
  String svSetAsideNote(String account);

  /// No description provided for @svContributeButton.
  ///
  /// In es, this message translates to:
  /// **'Aportar {amount}'**
  String svContributeButton(String amount);

  /// No description provided for @svWithdraw.
  ///
  /// In es, this message translates to:
  /// **'Retirar'**
  String get svWithdraw;

  /// No description provided for @svWithdrawTitle.
  ///
  /// In es, this message translates to:
  /// **'Retirar de {pocket}'**
  String svWithdrawTitle(String pocket);

  /// No description provided for @svWithdrawButton.
  ///
  /// In es, this message translates to:
  /// **'Retirar {amount}'**
  String svWithdrawButton(String amount);

  /// No description provided for @svWithdrawNote.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a estar disponible en tu cuenta.'**
  String get svWithdrawNote;

  /// No description provided for @svDistributeTitle.
  ///
  /// In es, this message translates to:
  /// **'Repartir en {group}'**
  String svDistributeTitle(String group);

  /// No description provided for @svDistributeNote.
  ///
  /// In es, this message translates to:
  /// **'Se reparte según lo que le falta a cada bolsillo.'**
  String get svDistributeNote;

  /// No description provided for @svPayFromPocket.
  ///
  /// In es, this message translates to:
  /// **'Pagar con bolsillo'**
  String get svPayFromPocket;

  /// No description provided for @svNoneOption.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get svNoneOption;

  /// No description provided for @svPocketBalance.
  ///
  /// In es, this message translates to:
  /// **'Apartado {amount}'**
  String svPocketBalance(String amount);

  /// No description provided for @svFromPocket.
  ///
  /// In es, this message translates to:
  /// **'desde {pocket}'**
  String svFromPocket(String pocket);

  /// No description provided for @svCreateFirst.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primer grupo de ahorro'**
  String get svCreateFirst;

  /// No description provided for @svRefills.
  ///
  /// In es, this message translates to:
  /// **'Se recarga el 1 de cada mes'**
  String get svRefills;

  /// No description provided for @accSetAside.
  ///
  /// In es, this message translates to:
  /// **'Apartado en bolsillos'**
  String get accSetAside;

  /// No description provided for @accSpendable.
  ///
  /// In es, this message translates to:
  /// **'Disponible para gastar'**
  String get accSpendable;

  /// No description provided for @ovMoneySetAside.
  ///
  /// In es, this message translates to:
  /// **'De eso, {amount} está apartado en bolsillos'**
  String ovMoneySetAside(String amount);

  /// No description provided for @ovSavings.
  ///
  /// In es, this message translates to:
  /// **'Ahorros'**
  String get ovSavings;

  /// No description provided for @svOfAmount.
  ///
  /// In es, this message translates to:
  /// **'de {amount}'**
  String svOfAmount(String amount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
