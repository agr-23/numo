import '../../data/models/category.dart';

/// Definición declarativa de una categoría predefinida.
class CategorySeed {
  final String key;
  final String name; // nombre en español, guardado en Isar
  final String iconName;
  final String colorHex;
  final CategoryType type;

  const CategorySeed(
    this.key,
    this.name,
    this.iconName,
    this.colorHex,
    this.type,
  );
}

/// Categorías de gasto (12) e ingreso (4). Ver brief.
const List<CategorySeed> kDefaultCategories = [
  // Gastos
  CategorySeed('food', 'Comida', 'restaurant', '#FF6B35', CategoryType.expense),
  CategorySeed(
    'transport',
    'Transporte',
    'directions_car',
    '#4ECDC4',
    CategoryType.expense,
  ),
  CategorySeed(
    'groceries',
    'Mercado',
    'shopping_cart',
    '#45B7D1',
    CategoryType.expense,
  ),
  CategorySeed('health', 'Salud', 'favorite', '#F6465D', CategoryType.expense),
  CategorySeed(
    'entertainment',
    'Entretenimiento',
    'sports_esports',
    '#A855F7',
    CategoryType.expense,
  ),
  CategorySeed(
    'clothing',
    'Ropa',
    'checkroom',
    '#EC4899',
    CategoryType.expense,
  ),
  CategorySeed(
    'education',
    'Educación',
    'school',
    '#3B82F6',
    CategoryType.expense,
  ),
  CategorySeed('home', 'Hogar', 'home', '#10B981', CategoryType.expense),
  CategorySeed(
    'utilities',
    'Servicios',
    'receipt_long',
    '#6B7280',
    CategoryType.expense,
  ),
  CategorySeed('travel', 'Viajes', 'flight', '#F59E0B', CategoryType.expense),
  CategorySeed(
    'subscriptions',
    'Suscripciones',
    'subscriptions',
    '#8B5CF6',
    CategoryType.expense,
  ),
  CategorySeed(
    'otherExpense',
    'Otros gastos',
    'more_horiz',
    '#9CA3AF',
    CategoryType.expense,
  ),
  // Ingresos
  CategorySeed('salary', 'Salario', 'work', '#1DD18F', CategoryType.income),
  CategorySeed(
    'freelance',
    'Freelance',
    'laptop',
    '#06B6D4',
    CategoryType.income,
  ),
  CategorySeed(
    'investments',
    'Inversiones',
    'trending_up',
    '#F0B429',
    CategoryType.income,
  ),
  CategorySeed(
    'otherIncome',
    'Otros ingresos',
    'attach_money',
    '#34D399',
    CategoryType.income,
  ),
];

/// Crea las instancias [Category] a sembrar en la primera ejecución.
List<Category> buildDefaultCategories() {
  return [
    for (var i = 0; i < kDefaultCategories.length; i++)
      Category()
        ..key = kDefaultCategories[i].key
        ..name = kDefaultCategories[i].name
        ..iconName = kDefaultCategories[i].iconName
        ..colorHex = kDefaultCategories[i].colorHex
        ..type = kDefaultCategories[i].type
        ..isCustom = false
        ..sortOrder = i,
  ];
}
