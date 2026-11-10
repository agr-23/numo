// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Numo — Simple personal finance';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get continueLabel => 'Continue';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get seeAll => 'See all';

  @override
  String get name => 'Name';

  @override
  String get type => 'Type';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icon';

  @override
  String get category => 'Category';

  @override
  String get categories => 'Categories';

  @override
  String get account => 'Account';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get note => 'Note';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get title => 'Title';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get transfer => 'Transfer';

  @override
  String get expenses => 'Expenses';

  @override
  String get incomes => 'Income';

  @override
  String get transfers => 'Transfers';

  @override
  String get all => 'All';

  @override
  String get balance => 'Balance';

  @override
  String get available => 'Available';

  @override
  String get debt => 'Debt';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'tomorrow';

  @override
  String get todayLower => 'today';

  @override
  String inDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String dayN(int day) {
    return 'Day $day';
  }

  @override
  String amountOf(String part, String total) {
    return '$part of $total';
  }

  @override
  String get amountMustBePositive => 'Enter an amount greater than 0';

  @override
  String get selectCategory => 'Choose a category';

  @override
  String get selectAccount => 'Choose an account';

  @override
  String get writeName => 'Enter a name';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Activity';

  @override
  String get navAnalytics => 'Insights';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCredit => 'Credit card';

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catHealth => 'Health';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catClothing => 'Clothing';

  @override
  String get catEducation => 'Education';

  @override
  String get catHome => 'Home';

  @override
  String get catUtilities => 'Utilities';

  @override
  String get catTravel => 'Travel';

  @override
  String get catSubscriptions => 'Subscriptions';

  @override
  String get catOtherExpense => 'Other expenses';

  @override
  String get catSalary => 'Salary';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catInvestments => 'Investments';

  @override
  String get catOtherIncome => 'Other income';

  @override
  String get currencyCOP => 'Colombian peso';

  @override
  String get currencyUSD => 'US dollar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyMXN => 'Mexican peso';

  @override
  String get currencyARS => 'Argentine peso';

  @override
  String get currencyCLP => 'Chilean peso';

  @override
  String get currencyPEN => 'Peruvian sol';

  @override
  String get currencyBRL => 'Brazilian real';

  @override
  String get currencyGBP => 'British pound';

  @override
  String get currencyCAD => 'Canadian dollar';

  @override
  String get languageSystem => 'Automatic (phone language)';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'English';

  @override
  String get unlockReason => 'Unlock Numo';

  @override
  String get enterPin => 'Enter your PIN';

  @override
  String get wrongPin => 'Wrong PIN';

  @override
  String get createPin => 'Create a 4-digit PIN';

  @override
  String get confirmPin => 'Confirm your PIN';

  @override
  String get confirmCurrentPin => 'Confirm your current PIN';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbStart => 'Get started';

  @override
  String get onbFinish => 'Done, let\'s go';

  @override
  String get onbWelcomeTitle => 'Your money, finally clear.';

  @override
  String get onbWelcomeBody =>
      'Track spending, stay on budget and save toward your goals.';

  @override
  String get onbLanguage => 'Language';

  @override
  String get onbFastTitle => 'Log it in seconds';

  @override
  String get onbFast1 => 'Quick keypad: amount, category, done';

  @override
  String get onbFast2 => 'Automatic recurring transactions';

  @override
  String get onbFast3 => 'Transfers and payments between your accounts';

  @override
  String get onbControlTitle => 'Control, save and protect';

  @override
  String get onbControl1 => 'Budgets that warn you at 80%';

  @override
  String get onbControl2 => 'Credit cards with limit, statement and due dates';

  @override
  String get onbControl3 => 'Savings goals that show your progress';

  @override
  String get onbControl4 =>
      'Everything stays on your phone, behind a PIN or fingerprint';

  @override
  String get onbCurrencyTitle => 'Which currency do you use?';

  @override
  String get onbCurrencyPreview => 'Your amounts will look like this:';

  @override
  String get onbAccountTitle => 'What\'s your first account called?';

  @override
  String get onbAccountHint => 'E.g. My wallet, Chase checking';

  @override
  String get onbAccountNameMissing => 'Give your first account a name';

  @override
  String get onbLimitOptional => 'Credit limit (optional)';

  @override
  String get onbDebtOptional => 'Current balance owed (optional)';

  @override
  String get onbDatesLater =>
      'You can set statement and due dates later in the account';

  @override
  String get onbBalanceOptional => 'Starting balance (optional)';

  @override
  String get dashBudgets => 'Budgets';

  @override
  String get dashSavingsGoals => 'Savings goals';

  @override
  String get dashRecent => 'Recent activity';

  @override
  String get dashNoTransactions => 'No transactions yet';

  @override
  String dashNetBalanceLine(String amount) {
    return 'Net balance: $amount';
  }

  @override
  String get ovNetBalance => 'Net balance';

  @override
  String get ovMonthIncome => 'income this month';

  @override
  String get ovMonthExpense => 'spent this month';

  @override
  String get ovTotalMoney => 'Total money';

  @override
  String get ovInAccounts => 'in accounts';

  @override
  String get ovInGoals => 'in goals';

  @override
  String get ovDebts => 'Debt';

  @override
  String get ovNoCards => 'You have no credit cards';

  @override
  String get ovAvailableCredit => 'credit available';

  @override
  String ovPaymentOf(String card) {
    return '$card payment';
  }

  @override
  String get ovSavedInGoals => 'Saved in goals';

  @override
  String get ovCreateFirstGoal => 'Create your first savings goal';

  @override
  String ovGoalTarget(String percent) {
    return 'target, $percent%';
  }

  @override
  String get ovCompleted => 'completed';

  @override
  String get txTitle => 'Activity';

  @override
  String get txSearch => 'Search…';

  @override
  String get txNoMatches => 'No transactions match these filters';

  @override
  String get txAddFirst => 'Add your first one';

  @override
  String get txDeleted => 'Transaction deleted';

  @override
  String get filters => 'Filters';

  @override
  String get clear => 'Clear';

  @override
  String get dateRange => 'Date range';

  @override
  String get anyDate => 'Any date';

  @override
  String get removeRange => 'Remove range';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get addTxNew => 'New transaction';

  @override
  String get addTxEdit => 'Edit transaction';

  @override
  String get addTxTitleHint => 'E.g. Lunch';

  @override
  String get addTxFromAccount => 'From account';

  @override
  String get addTxToAccount => 'To account';

  @override
  String get addTxPickAccount => 'Choose an account';

  @override
  String addTxAvailableCredit(String amount) {
    return 'Credit available: $amount';
  }

  @override
  String get addTxRecurring => 'Recurring';

  @override
  String get freqDaily => 'Daily';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get freqYearly => 'Yearly';

  @override
  String get addTxEndsOn => 'Ends on';

  @override
  String get addTxNoEnd => 'No end date';

  @override
  String get addTxSaveExpense => 'Save expense';

  @override
  String get addTxSaveIncome => 'Save income';

  @override
  String get addTxDoTransfer => 'Transfer';

  @override
  String get addTxDifferentDestination =>
      'Choose a different destination account';

  @override
  String get addTxWriteTitle => 'Enter a title';

  @override
  String get addTxOverLimitTitle => 'Over your credit limit';

  @override
  String addTxOverLimitBody(String account, String amount) {
    return 'This expense is more than the credit available on \"$account\" ($amount). Save it anyway?';
  }

  @override
  String get addTxSaveAnyway => 'Save anyway';

  @override
  String get addTxSavedExpense => 'Expense saved';

  @override
  String get addTxSavedIncome => 'Income saved';

  @override
  String get addTxSavedTransfer => 'Transfer done';

  @override
  String get anTitle => 'Insights';

  @override
  String get anByCategory => 'Spending by category';

  @override
  String get anSeriesWeeks => 'Income and spending (6 weeks)';

  @override
  String get anSeriesMonths => 'Income and spending (6 months)';

  @override
  String get anRanking => 'Top categories';

  @override
  String get anThisWeek => 'This week';

  @override
  String get anThisMonth => 'This month';

  @override
  String get anThisYear => 'This year';

  @override
  String get anCustom => 'Custom';

  @override
  String get anNoExpenses => 'No spending in this period';

  @override
  String anTotal(String amount) {
    return 'Total\n$amount';
  }

  @override
  String get anNoChartData => 'No data for the chart yet';

  @override
  String get accTitle => 'My accounts';

  @override
  String get accAdd => 'Add account';

  @override
  String get accNone => 'You have no accounts yet';

  @override
  String get accCreate => 'Create account';

  @override
  String get accNetTotal => 'Total net balance';

  @override
  String get accArchiveTitle => 'Archive account';

  @override
  String accArchiveBody(String name) {
    return '\"$name\" will be archived. Its history is kept, but it won\'t show up in your lists anymore.';
  }

  @override
  String get accArchive => 'Archive';

  @override
  String get accNotFound => 'Account not found';

  @override
  String get accEdit => 'Edit account';

  @override
  String get accNoTransactions => 'This account has no transactions';

  @override
  String get accBalanceAvailable => 'Available balance';

  @override
  String get accCreditAvailable => 'Credit available';

  @override
  String get accCurrentDebt => 'Current balance owed';

  @override
  String get accCreditLimit => 'Credit limit';

  @override
  String get accStatementDate => 'Statement date';

  @override
  String get accPaymentDue => 'Payment due';

  @override
  String get accNotSet => 'Not set';

  @override
  String get accCompleteHint =>
      'Tap the pencil above to add the limit and dates.';

  @override
  String get accPayCard => 'Pay card';

  @override
  String accDebtAmount(String amount) {
    return 'Owed $amount';
  }

  @override
  String accLimitAmount(String amount) {
    return 'Limit $amount';
  }

  @override
  String get accNew => 'New account';

  @override
  String get accNameHint => 'E.g. Chase checking';

  @override
  String get accLimitHelper => 'The card\'s credit limit';

  @override
  String get accDebtHelper => 'What you owe today. Expenses add to it.';

  @override
  String get accStatementDay => 'Statement day';

  @override
  String get accPaymentDay => 'Payment due day';

  @override
  String get accCurrentBalance => 'Current balance';

  @override
  String get accInitialBalance => 'Starting balance';

  @override
  String get accSaveChanges => 'Save changes';

  @override
  String get accNameMissing => 'Enter a name for the account';

  @override
  String get accLimitMissing => 'Enter the card\'s credit limit';

  @override
  String get budTitle => 'Budgets';

  @override
  String get budNone => 'No budgets for this month';

  @override
  String get budCreate => 'Create budget';

  @override
  String get budTotal => 'Total budgeted';

  @override
  String get budSpent => 'Spent';

  @override
  String get budDeleteTitle => 'Delete budget';

  @override
  String budDeleteBody(String name) {
    return 'Delete the budget for \"$name\"?';
  }

  @override
  String get budNoCategoryExpenses => 'No spending in this category';

  @override
  String budSheetTitle(String category, String month) {
    return '$category, $month';
  }

  @override
  String get budExceeded => 'Over budget';

  @override
  String get budNearLimit => 'Near the limit';

  @override
  String budSpentOf(String spent, String limit) {
    return 'Spent $spent of $limit';
  }

  @override
  String get budShort => 'Budget';

  @override
  String get budNew => 'New budget';

  @override
  String get budLimit => 'Limit';

  @override
  String get budMonth => 'Month';

  @override
  String get budPickMonth => 'Choose a month';

  @override
  String get budSave => 'Save budget';

  @override
  String get budExistsTitle => 'Budget already exists';

  @override
  String budExistsBody(String category, String month) {
    return 'You already have a budget for \"$category\" in $month. Replace it?';
  }

  @override
  String get budReplace => 'Replace';

  @override
  String get goalTitle => 'My goals';

  @override
  String get goalNone => 'You have no savings goals yet';

  @override
  String get goalCreate => 'Create goal';

  @override
  String get goalCompleted => 'Completed';

  @override
  String goalSavedOf(String saved, String target) {
    return 'Saved $saved of $target';
  }

  @override
  String get goalOverdue => 'Past the deadline';

  @override
  String get goalDueToday => 'Due today';

  @override
  String goalDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get goalContribute => 'Add money';

  @override
  String get goalNew => 'New goal';

  @override
  String get goalNameHint => 'E.g. Trip to Cartagena';

  @override
  String get goalTarget => 'Target amount';

  @override
  String get goalDeadlineOptional => 'Deadline (optional)';

  @override
  String get goalNoDate => 'No date';

  @override
  String get goalInitialOptional => 'Already saved (optional)';

  @override
  String get goalNameMissing => 'Enter a name for the goal';

  @override
  String get goalTargetMissing => 'Enter a target amount greater than 0';

  @override
  String goalContributeQuestion(String name) {
    return 'How much do you want to add to \"$name\"?';
  }

  @override
  String get setTitle => 'Settings';

  @override
  String get setSecurity => 'Security';

  @override
  String get setPin => 'Passcode';

  @override
  String get setChangePin => 'Change PIN';

  @override
  String get setBiometric => 'Fingerprint';

  @override
  String get setBiometricNeedsPin => 'Turn on a PIN first';

  @override
  String get setAppearance => 'Appearance';

  @override
  String get setThemeLight => 'Light';

  @override
  String get setThemeDark => 'Dark';

  @override
  String get setThemeAuto => 'Auto';

  @override
  String get setLanguage => 'Language';

  @override
  String get setFinance => 'Finance';

  @override
  String get setCurrency => 'Currency';

  @override
  String get setMonthStart => 'First day of the month';

  @override
  String get setManageCategories => 'Manage categories';

  @override
  String get setData => 'Data';

  @override
  String get setExport => 'Export my data';

  @override
  String get setExportSubtitle => 'Creates a CSV with all your transactions';

  @override
  String setExportFailed(String error) {
    return 'Couldn\'t export: $error';
  }

  @override
  String get setDeleteAll => 'Delete all data';

  @override
  String get setDeleteAllBody =>
      'This deletes all your accounts, transactions, budgets and goals. You can\'t undo it.';

  @override
  String get setFinalConfirm => 'Final confirmation';

  @override
  String setTypeToConfirm(String word) {
    return 'Type $word to confirm:';
  }

  @override
  String get setConfirmWord => 'DELETE';

  @override
  String get setDeleteEverything => 'Delete everything';

  @override
  String get setAllDeleted => 'All data was deleted';

  @override
  String get setAbout => 'About';

  @override
  String get catCustom => 'Custom';

  @override
  String get catPredefined => 'Built-in';

  @override
  String get catCannotDelete => 'Built-in categories can\'t be deleted';

  @override
  String get catNew => 'New category';

  @override
  String get catCreate => 'Create category';

  @override
  String get exportSubject => 'Numo export';

  @override
  String get exportText => 'My Numo transactions';

  @override
  String get exportDestAccount => 'To account';
}
