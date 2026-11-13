// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Numo — Finanzas personales simples';

  @override
  String appVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get seeAll => 'Ver todos';

  @override
  String get name => 'Nombre';

  @override
  String get type => 'Tipo';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icono';

  @override
  String get category => 'Categoría';

  @override
  String get categories => 'Categorías';

  @override
  String get account => 'Cuenta';

  @override
  String get date => 'Fecha';

  @override
  String get amount => 'Monto';

  @override
  String get note => 'Nota';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get title => 'Título';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get transfer => 'Transferencia';

  @override
  String get expenses => 'Gastos';

  @override
  String get incomes => 'Ingresos';

  @override
  String get transfers => 'Transferencias';

  @override
  String get all => 'Todos';

  @override
  String get balance => 'Balance';

  @override
  String get available => 'Disponible';

  @override
  String get debt => 'Deuda';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get tomorrow => 'mañana';

  @override
  String get todayLower => 'hoy';

  @override
  String inDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'en $days días',
      one: 'en 1 día',
    );
    return '$_temp0';
  }

  @override
  String dayN(int day) {
    return 'Día $day';
  }

  @override
  String amountOf(String part, String total) {
    return '$part de $total';
  }

  @override
  String get amountMustBePositive => 'Ingresa un monto mayor a 0';

  @override
  String get selectCategory => 'Selecciona una categoría';

  @override
  String get selectAccount => 'Selecciona una cuenta';

  @override
  String get writeName => 'Escribe un nombre';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get navHome => 'Inicio';

  @override
  String get navTransactions => 'Movimientos';

  @override
  String get navAnalytics => 'Analíticas';

  @override
  String get navAccounts => 'Cuentas';

  @override
  String get accountTypeCash => 'Efectivo';

  @override
  String get accountTypeBank => 'Banco';

  @override
  String get accountTypeCredit => 'Tarjeta de crédito';

  @override
  String get catFood => 'Comida';

  @override
  String get catTransport => 'Transporte';

  @override
  String get catGroceries => 'Mercado';

  @override
  String get catHealth => 'Salud';

  @override
  String get catEntertainment => 'Entretenimiento';

  @override
  String get catClothing => 'Ropa';

  @override
  String get catEducation => 'Educación';

  @override
  String get catHome => 'Hogar';

  @override
  String get catUtilities => 'Servicios';

  @override
  String get catTravel => 'Viajes';

  @override
  String get catSubscriptions => 'Suscripciones';

  @override
  String get catOtherExpense => 'Otros gastos';

  @override
  String get catSalary => 'Salario';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catInvestments => 'Inversiones';

  @override
  String get catOtherIncome => 'Otros ingresos';

  @override
  String get currencyCOP => 'Peso colombiano';

  @override
  String get currencyUSD => 'Dólar estadounidense';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyMXN => 'Peso mexicano';

  @override
  String get currencyARS => 'Peso argentino';

  @override
  String get currencyCLP => 'Peso chileno';

  @override
  String get currencyPEN => 'Sol peruano';

  @override
  String get currencyBRL => 'Real brasileño';

  @override
  String get currencyGBP => 'Libra esterlina';

  @override
  String get currencyCAD => 'Dólar canadiense';

  @override
  String get languageSystem => 'Automático (idioma del teléfono)';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'English';

  @override
  String get unlockReason => 'Desbloquea Numo';

  @override
  String get enterPin => 'Ingresa tu PIN';

  @override
  String get wrongPin => 'PIN incorrecto';

  @override
  String get createPin => 'Crea un PIN de 4 dígitos';

  @override
  String get confirmPin => 'Confirma tu PIN';

  @override
  String get confirmCurrentPin => 'Confirma tu PIN actual';

  @override
  String get onbSkip => 'Saltar';

  @override
  String get onbStart => 'Empezar';

  @override
  String get onbFinish => '¡Listo! Comenzar';

  @override
  String get onbWelcomeTitle => 'Tus finanzas, por fin claras.';

  @override
  String get onbWelcomeBody =>
      'Registra gastos, controla presupuestos y ahorra hacia tus metas.';

  @override
  String get onbLanguage => 'Idioma';

  @override
  String get onbFastTitle => 'Registra en segundos';

  @override
  String get onbFast1 => 'Teclado rápido: monto, categoría y listo';

  @override
  String get onbFast2 => 'Movimientos recurrentes automáticos';

  @override
  String get onbFast3 => 'Transferencias y pagos entre tus cuentas';

  @override
  String get onbControlTitle => 'Controla, ahorra y protege';

  @override
  String get onbControl1 => 'Presupuestos con alertas al 80 %';

  @override
  String get onbControl2 => 'Tarjetas con cupo, corte y fecha de pago';

  @override
  String get onbControl3 => 'Metas de ahorro con tu progreso';

  @override
  String get onbControl4 => 'Todo queda en tu teléfono, con PIN o huella';

  @override
  String get onbCurrencyTitle => '¿En qué moneda llevas tus finanzas?';

  @override
  String get onbCurrencyPreview => 'Así se verán tus montos:';

  @override
  String get onbAccountTitle => '¿Cómo se llama tu primera cuenta?';

  @override
  String get onbAccountHint => 'Ej: Mi billetera, Bancolombia';

  @override
  String get onbAccountNameMissing => 'Ponle un nombre a tu primera cuenta';

  @override
  String get onbLimitOptional => 'Cupo total (opcional)';

  @override
  String get onbDebtOptional => 'Deuda actual (opcional)';

  @override
  String get onbDatesLater =>
      'Las fechas de corte y pago se configuran luego en la cuenta';

  @override
  String get onbBalanceOptional => 'Balance inicial (opcional)';

  @override
  String get dashBudgets => 'Presupuestos';

  @override
  String get dashSavingsGoals => 'Metas de ahorro';

  @override
  String get dashRecent => 'Últimos movimientos';

  @override
  String get dashNoTransactions => 'Aún no hay movimientos';

  @override
  String dashNetBalanceLine(String amount) {
    return 'Balance neto: $amount';
  }

  @override
  String get ovNetBalance => 'Balance neto';

  @override
  String get ovMonthIncome => 'ingresos del mes';

  @override
  String get ovMonthExpense => 'gastos del mes';

  @override
  String get ovTotalMoney => 'Dinero total';

  @override
  String get ovInAccounts => 'en cuentas';

  @override
  String get ovInGoals => 'en metas';

  @override
  String get ovDebts => 'Deudas';

  @override
  String get ovNoCards => 'No tienes tarjetas de crédito';

  @override
  String get ovAvailableCredit => 'cupo disponible';

  @override
  String ovPaymentOf(String card) {
    return 'pago $card';
  }

  @override
  String get ovSavedInGoals => 'Ahorrado en metas';

  @override
  String get ovCreateFirstGoal => 'Crea tu primera meta de ahorro';

  @override
  String ovGoalTarget(String percent) {
    return 'objetivo, $percent %';
  }

  @override
  String get ovCompleted => 'completadas';

  @override
  String get txTitle => 'Movimientos';

  @override
  String get txSearch => 'Buscar…';

  @override
  String get txNoMatches => 'No hay movimientos con esos filtros';

  @override
  String get txAddFirst => 'Agregar el primero';

  @override
  String get txDeleted => 'Movimiento eliminado';

  @override
  String get filters => 'Filtros';

  @override
  String get clear => 'Limpiar';

  @override
  String get dateRange => 'Rango de fechas';

  @override
  String get anyDate => 'Cualquier fecha';

  @override
  String get removeRange => 'Quitar rango';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get addTxNew => 'Nuevo movimiento';

  @override
  String get addTxEdit => 'Editar movimiento';

  @override
  String get addTxTitleHint => 'Ej: Almuerzo';

  @override
  String get addTxFromAccount => 'Cuenta origen';

  @override
  String get addTxToAccount => 'Cuenta destino';

  @override
  String get addTxPickAccount => 'Selecciona una cuenta';

  @override
  String addTxAvailableCredit(String amount) {
    return 'Cupo disponible: $amount';
  }

  @override
  String get addTxRecurring => 'Recurrente';

  @override
  String get freqDaily => 'Diario';

  @override
  String get freqWeekly => 'Semanal';

  @override
  String get freqMonthly => 'Mensual';

  @override
  String get freqYearly => 'Anual';

  @override
  String get addTxEndsOn => 'Termina el';

  @override
  String get addTxNoEnd => 'Sin fecha de fin';

  @override
  String get addTxSaveExpense => 'Guardar gasto';

  @override
  String get addTxSaveIncome => 'Guardar ingreso';

  @override
  String get addTxDoTransfer => 'Transferir';

  @override
  String get addTxDifferentDestination =>
      'Selecciona una cuenta destino distinta';

  @override
  String get addTxWriteTitle => 'Escribe un título';

  @override
  String get addTxOverLimitTitle => 'Supera el cupo';

  @override
  String addTxOverLimitBody(String account, String amount) {
    return 'Este gasto supera el cupo disponible de \"$account\" ($amount). ¿Guardarlo igual?';
  }

  @override
  String get addTxSaveAnyway => 'Guardar igual';

  @override
  String get addTxSavedExpense => 'Gasto guardado';

  @override
  String get addTxSavedIncome => 'Ingreso guardado';

  @override
  String get addTxSavedTransfer => 'Transferencia realizada';

  @override
  String get anTitle => 'Analíticas';

  @override
  String get anByCategory => 'Gastos por categoría';

  @override
  String get anSeriesWeeks => 'Ingresos y gastos (6 semanas)';

  @override
  String get anSeriesMonths => 'Ingresos y gastos (6 meses)';

  @override
  String get anRanking => 'Ranking de categorías';

  @override
  String get anThisWeek => 'Esta semana';

  @override
  String get anThisMonth => 'Este mes';

  @override
  String get anThisYear => 'Este año';

  @override
  String get anCustom => 'Personalizado';

  @override
  String get anNoExpenses => 'Sin gastos en este período';

  @override
  String anTotal(String amount) {
    return 'Total\n$amount';
  }

  @override
  String get anNoChartData => 'Sin datos para el gráfico';

  @override
  String get accTitle => 'Mis cuentas';

  @override
  String get accAdd => 'Agregar cuenta';

  @override
  String get accNone => 'Aún no tienes cuentas';

  @override
  String get accCreate => 'Crear cuenta';

  @override
  String get accNetTotal => 'Balance neto total';

  @override
  String get accArchiveTitle => 'Archivar cuenta';

  @override
  String accArchiveBody(String name) {
    return 'La cuenta \"$name\" se archivará. Su historial se conserva, pero ya no aparecerá en las listas.';
  }

  @override
  String get accArchive => 'Archivar';

  @override
  String get accNotFound => 'Cuenta no encontrada';

  @override
  String get accEdit => 'Editar cuenta';

  @override
  String get accNoTransactions => 'Esta cuenta no tiene movimientos';

  @override
  String get accBalanceAvailable => 'Saldo disponible';

  @override
  String get accCreditAvailable => 'Cupo disponible';

  @override
  String get accCurrentDebt => 'Deuda actual';

  @override
  String get accCreditLimit => 'Cupo total';

  @override
  String get accStatementDate => 'Fecha de corte';

  @override
  String get accPaymentDue => 'Límite de pago';

  @override
  String get accNotSet => 'Sin configurar';

  @override
  String get accCompleteHint =>
      'Toca el lápiz de arriba para completar cupo y fechas.';

  @override
  String get accPayCard => 'Pagar tarjeta';

  @override
  String accDebtAmount(String amount) {
    return 'Deuda $amount';
  }

  @override
  String accLimitAmount(String amount) {
    return 'Cupo $amount';
  }

  @override
  String get accNew => 'Nueva cuenta';

  @override
  String get accNameHint => 'Ej: Bancolombia';

  @override
  String get accLimitHelper => 'El límite de crédito de la tarjeta';

  @override
  String get accDebtHelper => 'Lo que ya debes hoy. Los gastos la aumentan.';

  @override
  String get accStatementDay => 'Día de corte';

  @override
  String get accPaymentDay => 'Día límite de pago';

  @override
  String get accCurrentBalance => 'Saldo actual';

  @override
  String get accInitialBalance => 'Balance inicial';

  @override
  String get accSaveChanges => 'Guardar cambios';

  @override
  String get accNameMissing => 'Escribe un nombre para la cuenta';

  @override
  String get accLimitMissing => 'Ingresa el cupo total de la tarjeta';

  @override
  String get budTitle => 'Presupuestos';

  @override
  String get budNone => 'Sin presupuestos para este mes';

  @override
  String get budCreate => 'Crear presupuesto';

  @override
  String get budTotal => 'Total presupuestado';

  @override
  String get budSpent => 'Gastado';

  @override
  String get budDeleteTitle => 'Eliminar presupuesto';

  @override
  String budDeleteBody(String name) {
    return '¿Eliminar el presupuesto de \"$name\"?';
  }

  @override
  String get budNoCategoryExpenses => 'Sin gastos en esta categoría';

  @override
  String budSheetTitle(String category, String month) {
    return '$category, $month';
  }

  @override
  String get budExceeded => 'Excedido';

  @override
  String get budNearLimit => 'Cerca del límite';

  @override
  String budSpentOf(String spent, String limit) {
    return 'Gastado $spent de $limit';
  }

  @override
  String get budShort => 'Presupuesto';

  @override
  String get budNew => 'Nuevo presupuesto';

  @override
  String get budLimit => 'Monto límite';

  @override
  String get budMonth => 'Mes';

  @override
  String get budPickMonth => 'Selecciona un mes';

  @override
  String get budSave => 'Guardar presupuesto';

  @override
  String get budExistsTitle => 'Ya existe un presupuesto';

  @override
  String budExistsBody(String category, String month) {
    return 'Ya tienes un presupuesto para \"$category\" en $month. ¿Reemplazarlo?';
  }

  @override
  String get budReplace => 'Reemplazar';

  @override
  String get goalTitle => 'Mis metas';

  @override
  String get goalNone => 'Aún no tienes metas de ahorro';

  @override
  String get goalCreate => 'Crear meta';

  @override
  String get goalCompleted => 'Completada';

  @override
  String goalSavedOf(String saved, String target) {
    return 'Ahorrado $saved de $target';
  }

  @override
  String get goalOverdue => 'Fecha límite vencida';

  @override
  String get goalDueToday => 'Vence hoy';

  @override
  String goalDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $days días',
      one: 'Queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String get goalContribute => 'Aportar';

  @override
  String get goalNew => 'Nueva meta';

  @override
  String get goalNameHint => 'Ej: Viaje a Cartagena';

  @override
  String get goalTarget => 'Monto objetivo';

  @override
  String get goalDeadlineOptional => 'Fecha límite (opcional)';

  @override
  String get goalNoDate => 'Sin fecha';

  @override
  String get goalInitialOptional => 'Monto ya ahorrado (opcional)';

  @override
  String get goalNameMissing => 'Escribe un nombre para la meta';

  @override
  String get goalTargetMissing => 'Ingresa un monto objetivo mayor a 0';

  @override
  String goalContributeQuestion(String name) {
    return '¿Cuánto quieres aportar a \"$name\"?';
  }

  @override
  String get setTitle => 'Ajustes';

  @override
  String get setSecurity => 'Seguridad';

  @override
  String get setPin => 'PIN de acceso';

  @override
  String get setChangePin => 'Cambiar PIN';

  @override
  String get setBiometric => 'Huella dactilar';

  @override
  String get setBiometricNeedsPin => 'Requiere un PIN activo';

  @override
  String get setAppearance => 'Apariencia';

  @override
  String get setThemeLight => 'Claro';

  @override
  String get setThemeDark => 'Oscuro';

  @override
  String get setThemeAuto => 'Auto';

  @override
  String get setLanguage => 'Idioma';

  @override
  String get setFinance => 'Finanzas';

  @override
  String get setCurrency => 'Moneda';

  @override
  String get setMonthStart => 'Primer día del mes';

  @override
  String get setManageCategories => 'Administrar categorías';

  @override
  String get setData => 'Datos';

  @override
  String get setExport => 'Exportar mis datos';

  @override
  String get setExportSubtitle => 'Genera un CSV con todos tus movimientos';

  @override
  String setExportFailed(String error) {
    return 'No se pudo exportar: $error';
  }

  @override
  String get setDeleteAll => 'Borrar todos los datos';

  @override
  String get setDeleteAllBody =>
      'Esto eliminará todas tus cuentas, movimientos, presupuestos y metas. Esta acción no se puede deshacer.';

  @override
  String get setFinalConfirm => 'Confirmación final';

  @override
  String setTypeToConfirm(String word) {
    return 'Escribe $word para confirmar:';
  }

  @override
  String get setConfirmWord => 'BORRAR';

  @override
  String get setDeleteEverything => 'Borrar todo';

  @override
  String get setAllDeleted => 'Todos los datos fueron borrados';

  @override
  String get setAbout => 'Acerca de';

  @override
  String get catCustom => 'Personalizada';

  @override
  String get catPredefined => 'Predefinida';

  @override
  String get catCannotDelete =>
      'Las categorías predefinidas no se pueden borrar';

  @override
  String get catNew => 'Nueva categoría';

  @override
  String get catCreate => 'Crear categoría';

  @override
  String get exportSubject => 'Exportación de Numo';

  @override
  String get exportText => 'Mis movimientos de Numo';

  @override
  String get exportDestAccount => 'Cuenta destino';

  @override
  String get ovNetFormula => 'Cuentas − deudas';

  @override
  String ovIncomeArrow(String amount) {
    return '↑ $amount ingresos';
  }

  @override
  String ovExpenseArrow(String amount) {
    return '↓ $amount gastos';
  }

  @override
  String ovMoneySub(String accounts, String goals) {
    return '$accounts en cuentas y $goals en metas';
  }

  @override
  String ovDebtNext(String card, String date) {
    return '$card se paga el $date';
  }

  @override
  String ovGoalsSub(String percent, String target) {
    return '$percent % de $target';
  }

  @override
  String get dashHideAmounts => 'Ocultar montos';

  @override
  String get dashShowAmounts => 'Mostrar montos';

  @override
  String get actPay => 'Pagar';

  @override
  String get dashCreateBudget => 'Crear un presupuesto';

  @override
  String get addTxHowMuchExpense => '¿Cuánto gastaste?';

  @override
  String get addTxHowMuchIncome => '¿Cuánto recibiste?';

  @override
  String get addTxHowMuchTransfer => '¿Cuánto vas a mover?';

  @override
  String get addTxRepeat => 'Repetir';

  @override
  String get addTxRepeatNever => 'No';

  @override
  String get addTxFrom => 'Desde';

  @override
  String get addTxTo => 'Hacia';

  @override
  String get addTxAdd => 'Agregar';

  @override
  String addTxRepeatUntil(String frequency, String date) {
    return '$frequency, hasta el $date';
  }

  @override
  String accBalanceShort(String amount) {
    return 'Saldo $amount';
  }

  @override
  String get svTitle => 'Ahorros';

  @override
  String get svTotalSetAside => 'Total apartado';

  @override
  String svOfTotal(String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tus $count grupos',
      one: 'tu grupo',
    );
    return 'de $target entre $_temp0';
  }

  @override
  String get svGroups => 'Grupos';

  @override
  String get svTapGroup => 'Toca uno para ver sus bolsillos';

  @override
  String get svCreateGroup => 'Crear grupo';

  @override
  String get svEmpty =>
      'Separa tu dinero por propósitos: el carro, un viaje, emergencias.';

  @override
  String svPocketCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bolsillos',
      one: '1 bolsillo',
      zero: 'Sin bolsillos',
    );
    return '$_temp0';
  }

  @override
  String svDueHint(String pocket, String date, String amount) {
    return '$pocket vence el $date: te faltan $amount';
  }

  @override
  String get svAllDone => 'Todo completo';

  @override
  String get svSetAside => 'Apartado';

  @override
  String svOfPockets(String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sus $count bolsillos',
      one: 'su bolsillo',
    );
    return 'de $target sumando $_temp0';
  }

  @override
  String get svDistribute => 'Repartir aporte';

  @override
  String get svSectionMonthly => 'Cada mes';

  @override
  String get svSectionYearly => 'Una vez al año';

  @override
  String get svSectionGoals => 'Metas';

  @override
  String get svMonthlyNote =>
      'Se recargan el día 1. Lo que no gastes pasa al mes siguiente.';

  @override
  String get svAddPocket => 'Agregar bolsillo';

  @override
  String svDueOn(String date) {
    return 'Vence el $date';
  }

  @override
  String svDueSuggest(String date, String amount) {
    return 'Vence el $date. Aparta $amount al mes';
  }

  @override
  String get svSuggestions => 'Bolsillos sugeridos';

  @override
  String get svNewGroup => 'Nuevo grupo';

  @override
  String get svEditGroup => 'Editar grupo';

  @override
  String get svDeleteGroup => 'Eliminar grupo';

  @override
  String get svDeleteGroupBody =>
      'Se eliminarán sus bolsillos. Lo apartado vuelve a estar disponible en tus cuentas.';

  @override
  String get svTemplates => 'Empieza con una plantilla';

  @override
  String get tplCar => 'Carro';

  @override
  String get tplHome => 'Hogar';

  @override
  String get tplTrip => 'Viaje';

  @override
  String get tplEmergency => 'Fondo de emergencia';

  @override
  String get tplCustom => 'Personalizado';

  @override
  String get tplFuel => 'Gasolina';

  @override
  String get tplParking => 'Parqueaderos';

  @override
  String get tplTolls => 'Peajes';

  @override
  String get tplInsurance => 'SOAT';

  @override
  String get tplInspection => 'Técnico-mecánica';

  @override
  String get tplVehicleTax => 'Impuesto vehicular';

  @override
  String get tplRent => 'Arriendo';

  @override
  String get tplUtilities => 'Servicios';

  @override
  String get tplMaintenance => 'Mantenimiento';

  @override
  String get tplPropertyTax => 'Impuesto predial';

  @override
  String get tplFlights => 'Tiquetes';

  @override
  String get tplLodging => 'Hospedaje';

  @override
  String get tplTripSpending => 'Gastos del viaje';

  @override
  String get tplEmergencyPocket => 'Fondo';

  @override
  String get svNewPocket => 'Nuevo bolsillo';

  @override
  String get svEditPocket => 'Editar bolsillo';

  @override
  String get svDeletePocket => 'Eliminar bolsillo';

  @override
  String svDeletePocketBody(String amount) {
    return 'Lo apartado ($amount) vuelve a estar disponible en tu cuenta.';
  }

  @override
  String get svKindGoal => 'Meta';

  @override
  String get svKindMonthly => 'Cada mes';

  @override
  String get svKindYearly => 'Cada año';

  @override
  String get svAmountMonthly => 'Monto por mes';

  @override
  String get svAmountYearly => 'Monto anual';

  @override
  String get svNextDue => 'Próximo vencimiento';

  @override
  String get svPickDate => 'Elegir fecha';

  @override
  String get svDueRequired => 'Elige la fecha de vencimiento';

  @override
  String get svFromAccount => 'Apartar desde';

  @override
  String get svNoAccount => 'Sin cuenta';

  @override
  String svContributeTo(String pocket) {
    return 'Aportar a $pocket';
  }

  @override
  String svProgress(String saved, String target) {
    return 'Llevas $saved de $target';
  }

  @override
  String svSuggested(String amount) {
    return 'Sugerido $amount';
  }

  @override
  String svFill(String amount) {
    return 'Completar $amount';
  }

  @override
  String svSetAsideNote(String account) {
    return 'El dinero sigue en $account, pero deja de contar como disponible para gastar.';
  }

  @override
  String svContributeButton(String amount) {
    return 'Aportar $amount';
  }

  @override
  String get svWithdraw => 'Retirar';

  @override
  String svWithdrawTitle(String pocket) {
    return 'Retirar de $pocket';
  }

  @override
  String svWithdrawButton(String amount) {
    return 'Retirar $amount';
  }

  @override
  String get svWithdrawNote => 'Vuelve a estar disponible en tu cuenta.';

  @override
  String svDistributeTitle(String group) {
    return 'Repartir en $group';
  }

  @override
  String get svDistributeNote =>
      'Se reparte según lo que le falta a cada bolsillo.';

  @override
  String get svPayFromPocket => 'Pagar con bolsillo';

  @override
  String get svNoneOption => 'Ninguno';

  @override
  String svPocketBalance(String amount) {
    return 'Apartado $amount';
  }

  @override
  String svFromPocket(String pocket) {
    return 'desde $pocket';
  }

  @override
  String get svCreateFirst => 'Crea tu primer grupo de ahorro';

  @override
  String get svRefills => 'Se recarga el 1 de cada mes';

  @override
  String get accSetAside => 'Apartado en bolsillos';

  @override
  String get accSpendable => 'Disponible para gastar';

  @override
  String ovMoneySetAside(String amount) {
    return 'De eso, $amount está apartado en bolsillos';
  }

  @override
  String get ovSavings => 'Ahorros';

  @override
  String svOfAmount(String amount) {
    return 'de $amount';
  }

  @override
  String get amTitle => 'Movimientos automáticos';

  @override
  String get amSettingsSubtitle =>
      'Detectar compras desde los avisos del banco';

  @override
  String get amIntro =>
      'Numo puede leer los avisos de las apps de tu banco para detectar compras y transferencias. En esta versión solo los guarda para conocer su formato: todavía no registra movimientos.';

  @override
  String get amPrivacyTitle => 'Tu privacidad';

  @override
  String get amPrivacyApps =>
      'Solo lee las apps que tú elijas. Las demás se ignoran sin leerlas.';

  @override
  String get amPrivacyCodes =>
      'Descarta siempre los avisos con códigos de verificación o claves.';

  @override
  String get amPrivacyOffline =>
      'Todo queda en el teléfono: Numo no tiene acceso a internet.';

  @override
  String get amPrivacyRetention =>
      'Los avisos guardados se borran solos a los 7 días y no van a la copia en la nube.';

  @override
  String get amAccess => 'Acceso a notificaciones';

  @override
  String get amAccessOn => 'Activado';

  @override
  String get amAccessOff => 'Desactivado';

  @override
  String get amAccessEnable => 'Activar';

  @override
  String get amAccessManage => 'Gestionar';

  @override
  String get amAccessDialogTitle => 'Antes de continuar';

  @override
  String get amAccessDialogBody =>
      'Android te mostrará un aviso que dice que Numo podrá leer todas tus notificaciones. Es el texto estándar del sistema: Numo solo leerá las apps que elijas aquí.\n\nBusca Numo en la lista y actívalo.';

  @override
  String get amSetup => 'Configuración';

  @override
  String get amAppsChoose => 'Elegir apps';

  @override
  String get amAppsNone => 'Ninguna. Numo no lee nada.';

  @override
  String get amAppsSearch => 'Buscar app';

  @override
  String get amAppsHint => 'Elige solo las apps de tus bancos o billeteras.';

  @override
  String get amNotices => 'Mensajes detectados';

  @override
  String amNoticesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensajes',
      one: '1 mensaje',
      zero: 'Ninguno todavía',
    );
    return '$_temp0';
  }

  @override
  String get amNoticesEmpty =>
      'Aún no hay mensajes. Cuando una de las apps elegidas te envíe una notificación, aparecerá aquí.';

  @override
  String get amNoticesShareWarning =>
      'Antes de compartir un mensaje, cambia tu nombre, tu cédula y los números de cuenta.';

  @override
  String get amCopy => 'Copiar';

  @override
  String get amCopied => 'Copiado';

  @override
  String get amClearAll => 'Borrar todo';

  @override
  String get amClearAllBody => 'Se borrarán todos los mensajes detectados.';
}
