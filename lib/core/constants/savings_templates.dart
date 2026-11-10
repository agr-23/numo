import '../../data/models/pocket.dart';
import '../../l10n/app_localizations.dart';

/// Bolsillo sugerido dentro de una plantilla.
class PocketSeed {
  final String key;
  final PocketKind kind;
  final String iconName;
  const PocketSeed(this.key, this.kind, this.iconName);

  String label(AppLocalizations l10n) => switch (key) {
    'fuel' => l10n.tplFuel,
    'parking' => l10n.tplParking,
    'tolls' => l10n.tplTolls,
    'insurance' => l10n.tplInsurance,
    'inspection' => l10n.tplInspection,
    'vehicleTax' => l10n.tplVehicleTax,
    'rent' => l10n.tplRent,
    'utilities' => l10n.tplUtilities,
    'maintenance' => l10n.tplMaintenance,
    'propertyTax' => l10n.tplPropertyTax,
    'flights' => l10n.tplFlights,
    'lodging' => l10n.tplLodging,
    'tripSpending' => l10n.tplTripSpending,
    _ => l10n.tplEmergencyPocket,
  };
}

/// Plantilla de grupo: nombre, ícono y bolsillos sugeridos.
class SavingsTemplate {
  final String key;
  final String iconName;
  final List<PocketSeed> pockets;
  const SavingsTemplate(this.key, this.iconName, this.pockets);

  String label(AppLocalizations l10n) => switch (key) {
    'car' => l10n.tplCar,
    'home' => l10n.tplHome,
    'trip' => l10n.tplTrip,
    'emergency' => l10n.tplEmergency,
    _ => l10n.tplCustom,
  };
}

const kSavingsTemplates = [
  SavingsTemplate('car', 'directions_car_filled', [
    PocketSeed('fuel', PocketKind.monthly, 'local_gas_station'),
    PocketSeed('parking', PocketKind.monthly, 'local_parking'),
    PocketSeed('tolls', PocketKind.monthly, 'toll'),
    PocketSeed('insurance', PocketKind.yearly, 'shield'),
    PocketSeed('inspection', PocketKind.yearly, 'build'),
    PocketSeed('vehicleTax', PocketKind.yearly, 'receipt_long'),
  ]),
  SavingsTemplate('home', 'house', [
    PocketSeed('rent', PocketKind.monthly, 'home'),
    PocketSeed('utilities', PocketKind.monthly, 'bolt'),
    PocketSeed('maintenance', PocketKind.yearly, 'handyman'),
    PocketSeed('propertyTax', PocketKind.yearly, 'receipt_long'),
  ]),
  SavingsTemplate('trip', 'flight', [
    PocketSeed('flights', PocketKind.goal, 'flight'),
    PocketSeed('lodging', PocketKind.goal, 'hotel'),
    PocketSeed('tripSpending', PocketKind.goal, 'luggage'),
  ]),
  SavingsTemplate('emergency', 'health', [
    PocketSeed('emergency', PocketKind.goal, 'health'),
  ]),
];

SavingsTemplate? templateByKey(String? key) {
  for (final t in kSavingsTemplates) {
    if (t.key == key) return t;
  }
  return null;
}
