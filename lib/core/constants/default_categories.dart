import '../../data/models/category.dart';

/// Definición declarativa de una categoría predefinida.
class CategorySeed {
  final String name;
  final String iconName;
  final String colorHex;
  final CategoryType type;

  const CategorySeed(this.name, this.iconName, this.colorHex, this.type);
}

/// Categorías de gasto (12) e ingreso (4). Ver brief.
const List<CategorySeed> kDefaultCategories = [
  // Gastos
  CategorySeed('Comida', 'restaurant', '#FF6B35', CategoryType.expense),
  CategorySeed('Transporte', 'directions_car', '#4ECDC4', CategoryType.expense),
  CategorySeed('Mercado', 'shopping_cart', '#45B7D1', CategoryType.expense),
  CategorySeed('Salud', 'favorite', '#F6465D', CategoryType.expense),
  CategorySeed(
      'Entretenimiento', 'sports_esports', '#A855F7', CategoryType.expense),
  CategorySeed('Ropa', 'checkroom', '#EC4899', CategoryType.expense),
  CategorySeed('Educación', 'school', '#3B82F6', CategoryType.expense),
  CategorySeed('Hogar', 'home', '#10B981', CategoryType.expense),
  CategorySeed('Servicios', 'receipt_long', '#6B7280', CategoryType.expense),
  CategorySeed('Viajes', 'flight', '#F59E0B', CategoryType.expense),
  CategorySeed('Suscripciones', 'subscriptions', '#8B5CF6', CategoryType.expense),
  CategorySeed('Otros gastos', 'more_horiz', '#9CA3AF', CategoryType.expense),
  // Ingresos
  CategorySeed('Salario', 'work', '#1DD18F', CategoryType.income),
  CategorySeed('Freelance', 'laptop', '#06B6D4', CategoryType.income),
  CategorySeed('Inversiones', 'trending_up', '#F0B429', CategoryType.income),
  CategorySeed('Otros ingresos', 'attach_money', '#34D399', CategoryType.income),
];

/// Crea las instancias [Category] a sembrar en la primera ejecución.
List<Category> buildDefaultCategories() {
  return [
    for (var i = 0; i < kDefaultCategories.length; i++)
      Category()
        ..name = kDefaultCategories[i].name
        ..iconName = kDefaultCategories[i].iconName
        ..colorHex = kDefaultCategories[i].colorHex
        ..type = kDefaultCategories[i].type
        ..isCustom = false
        ..sortOrder = i,
  ];
}
