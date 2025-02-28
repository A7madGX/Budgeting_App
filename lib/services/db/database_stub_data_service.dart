import 'dart:math';

import 'package:budgeting_app/constants.dart';
import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/models/expense_model.dart';

class DatabaseStubDataService {
  final DatabaseManager _databaseManager;
  final Random _random = Random();

  DatabaseStubDataService(this._databaseManager);

  Future<void> generateStubData() async {
    DateTime startDate = DateTime(2023, 1, 1);
    DateTime endDate = DateTime(2025, 2, 28);

    List<Expense> allExpenses = [];

    for (
      DateTime date = startDate;
      date.isBefore(endDate.add(Duration(days: 1)));
      date = date.add(Duration(days: 1))
    ) {
      int expensesCount = _getExpensesCountForDay(date);
      Set<String> usedCategoriesForDay = {};

      for (int i = 0; i < expensesCount; i++) {
        allExpenses.add(_generateRandomExpense(date, usedCategoriesForDay));
      }
    }

    await _databaseManager.insertExpenses(allExpenses);
  }

  int _getExpensesCountForDay(DateTime date) {
    bool isWeekend = date.weekday >= 6;
    bool isStartOfMonth = date.day <= 5;
    bool isHolidaySeason = date.month == 12 || date.month == 7;

    double probability = 0.5;
    if (isWeekend) probability = 0.7;
    if (isStartOfMonth) probability = 0.8;
    if (isHolidaySeason) probability = 0.75;

    if (_random.nextDouble() < probability) {
      if (isWeekend || isStartOfMonth || isHolidaySeason) {
        return _random.nextInt(4) + 2; // 2-5 expenses
      } else {
        return _random.nextInt(4) + 1; // 1-4 expenses
      }
    } else {
      return _random.nextInt(3); // 0-2 expenses
    }
  }

  Expense _generateRandomExpense(
    DateTime date,
    Set<String> usedCategoriesForDay,
  ) {
    String category = _getCategoryBasedOnContext(date, usedCategoriesForDay);
    usedCategoriesForDay.add(category);

    double amount = _getRealisticAmount(category);
    String description = _getRealisticDescription(category);

    return Expense(
      amount: amount,
      category: category,
      description: description,
      date: date.toIso8601String().split('T')[0],
    );
  }

  String _getCategoryBasedOnContext(
    DateTime date,
    Set<String> usedCategoriesForDay,
  ) {
    List<String> allCategories = List.from(categoryIcons.keys);
    List<String> nonRepeatingCategories = ['Utilities', 'Healthcare'];

    for (String category in nonRepeatingCategories) {
      if (usedCategoriesForDay.contains(category)) {
        allCategories.remove(category);
      }
    }

    Map<String, double> weights = {};

    for (String category in allCategories) {
      double weight = 1.0;

      if (date.weekday >= 6) {
        // Weekend
        if (category == 'Entertainment') weight *= 2.0;
        if (category == 'Dining') weight *= 1.5;
        if (category == 'Shopping') weight *= 1.5;
      }

      if (date.day <= 5) {
        // Start of month
        if (category == 'Utilities') weight *= 3.0;
      }

      if (date.month == 12) {
        // Holiday season
        if (category == 'Shopping') weight *= 2.0;
        if (category == 'Travel') weight *= 1.5;
      }

      if (date.month >= 6 && date.month <= 8) {
        // Summer
        if (category == 'Travel') weight *= 2.0;
      }

      weights[category] = weight;
    }

    double totalWeight = weights.values.fold(0, (sum, weight) => sum + weight);
    double randomValue = _random.nextDouble() * totalWeight;
    double cumulativeWeight = 0;

    for (var entry in weights.entries) {
      cumulativeWeight += entry.value;
      if (randomValue <= cumulativeWeight) {
        return entry.key;
      }
    }

    return allCategories[_random.nextInt(allCategories.length)];
  }

  double _getRealisticAmount(String category) {
    switch (category) {
      case 'Groceries':
        return _roundToDecimal(20.0 + _random.nextDouble() * 130.0);
      case 'Transport':
        return _roundToDecimal(5.0 + _random.nextDouble() * 95.0);
      case 'Dining':
        return _roundToDecimal(10.0 + _random.nextDouble() * 90.0);
      case 'Utilities':
        return _roundToDecimal(40.0 + _random.nextDouble() * 210.0);
      case 'Entertainment':
        return _roundToDecimal(15.0 + _random.nextDouble() * 85.0);
      case 'Shopping':
        return _roundToDecimal(20.0 + _random.nextDouble() * 230.0);
      case 'Healthcare':
        return _roundToDecimal(10.0 + _random.nextDouble() * 290.0);
      case 'Travel':
        return _roundToDecimal(50.0 + _random.nextDouble() * 950.0);
      case 'Miscellaneous':
        return _roundToDecimal(5.0 + _random.nextDouble() * 95.0);
      default:
        return _roundToDecimal(10.0 + _random.nextDouble() * 90.0);
    }
  }

  double _roundToDecimal(double value) {
    return (value * 100).round() / 100;
  }

  String _getRealisticDescription(String category) {
    final Map<String, List<String>> descriptions = {
      'Groceries': [
        'Weekly grocery shopping',
        'Fruits and vegetables',
        'Milk and dairy',
        'Meat and poultry',
        'Snacks and beverages',
        'Bakery items',
        'Canned goods',
        'Cleaning supplies',
        'Personal care items',
      ],
      'Transport': [
        'Gas refill',
        'Uber ride',
        'Monthly transit pass',
        'Bus ticket',
        'Taxi fare',
        'Car maintenance',
        'Parking fee',
        'Toll charges',
      ],
      'Dining': [
        'Lunch with colleagues',
        'Dinner with friends',
        'Coffee shop',
        'Fast food',
        'Restaurant dinner',
        'Food delivery',
        'Brunch',
      ],
      'Utilities': [
        'Electricity bill',
        'Water bill',
        'Internet bill',
        'Gas bill',
        'Phone bill',
        'Cable TV',
        'Streaming services',
      ],
      'Entertainment': [
        'Movie tickets',
        'Concert tickets',
        'Theme park',
        'Bowling night',
        'Video games',
        'Book purchase',
        'Music subscription',
        'Theater show',
      ],
      'Shopping': [
        'Clothes shopping',
        'Electronics',
        'Home decor',
        'Kitchen appliances',
        'Shoes',
        'Accessories',
        'Gift purchase',
        'Furniture',
      ],
      'Healthcare': [
        'Doctor appointment',
        'Prescription medicine',
        'Dental checkup',
        'Eye exam',
        'Health insurance',
        'Gym membership',
        'Vitamins',
      ],
      'Travel': [
        'Flight tickets',
        'Hotel booking',
        'Car rental',
        'Travel insurance',
        'Vacation package',
        'Sightseeing tours',
        'Souvenirs',
      ],
      'Miscellaneous': [
        'Charity donation',
        'Membership fee',
        'Pet supplies',
        'Birthday gift',
        'Holiday decoration',
        'Office supplies',
      ],
    };

    final List<String> categoryDescriptions = descriptions[category]!;
    return categoryDescriptions[_random.nextInt(categoryDescriptions.length)];
  }
}
