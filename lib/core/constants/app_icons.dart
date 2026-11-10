import 'package:flutter/material.dart';

/// Mapea nombres de icono (almacenados como String en Isar) a [IconData].
/// Permite persistir iconos sin guardar el code point crudo.
class AppIcons {
  AppIcons._();

  static const Map<String, IconData> _map = {
    // Categorías de gasto
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'shopping_cart': Icons.shopping_cart,
    'favorite': Icons.favorite,
    'sports_esports': Icons.sports_esports,
    'checkroom': Icons.checkroom,
    'school': Icons.school,
    'home': Icons.home,
    'receipt_long': Icons.receipt_long,
    'flight': Icons.flight,
    'subscriptions': Icons.subscriptions,
    'more_horiz': Icons.more_horiz,
    // Categorías de ingreso
    'work': Icons.work,
    'laptop': Icons.laptop,
    'trending_up': Icons.trending_up,
    'attach_money': Icons.attach_money,
    // Cuentas / metas
    'account_balance_wallet': Icons.account_balance_wallet,
    'account_balance': Icons.account_balance,
    'credit_card': Icons.credit_card,
    'savings': Icons.savings,
    'payments': Icons.payments,
    'wallet': Icons.wallet,
    'card_giftcard': Icons.card_giftcard,
    'beach_access': Icons.beach_access,
    'directions_car_filled': Icons.directions_car_filled,
    'house': Icons.house,
    'phone_iphone': Icons.phone_iphone,
    'laptop_mac': Icons.laptop_mac,
    'fitness_center': Icons.fitness_center,
    'pets': Icons.pets,
    'celebration': Icons.celebration,
    'diamond': Icons.diamond,
    'rocket_launch': Icons.rocket_launch,
    'sailing': Icons.sailing,
    'pedal_bike': Icons.pedal_bike,
    'star': Icons.star,
  };

  static IconData resolve(String name) => _map[name] ?? Icons.category;

  /// Iconos sugeridos para categorías personalizadas.
  static const List<String> categoryIcons = [
    'restaurant',
    'directions_car',
    'shopping_cart',
    'favorite',
    'sports_esports',
    'checkroom',
    'school',
    'home',
    'receipt_long',
    'flight',
    'subscriptions',
    'work',
    'laptop',
    'trending_up',
    'attach_money',
    'fitness_center',
    'pets',
    'celebration',
    'card_giftcard',
    'more_horiz',
  ];

  /// Iconos sugeridos para cuentas (selector AddAccountSheet).
  static const List<String> accountIcons = [
    'account_balance_wallet',
    'account_balance',
    'credit_card',
    'wallet',
    'payments',
    'savings',
  ];

  /// 20 iconos sugeridos para cuentas y metas.
  static const List<String> pickerIcons = [
    'savings',
    'account_balance_wallet',
    'account_balance',
    'credit_card',
    'payments',
    'card_giftcard',
    'beach_access',
    'flight',
    'directions_car_filled',
    'house',
    'phone_iphone',
    'laptop_mac',
    'fitness_center',
    'pets',
    'celebration',
    'diamond',
    'rocket_launch',
    'sailing',
    'pedal_bike',
    'star',
  ];
}
