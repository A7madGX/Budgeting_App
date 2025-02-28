import 'dart:math';

import 'package:budgeting_app/constants.dart';
import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/models/account_model.dart';
import 'package:budgeting_app/models/expense_model.dart';

class DatabaseStubDataService {
  final DatabaseManager _databaseManager;
  final Random _random = Random();
  final List<int> _accountIds = [];

  DatabaseStubDataService(this._databaseManager);

  Future<void> generateStubData() async {
    // Generate accounts first
    await _generateAccountData();

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
        // Determine if this will be income or expense
        bool isIncome =
            i == 0 &&
            date.day <= 5 &&
            _random.nextDouble() < 0.7; // Salary likely at start of month

        if (!isIncome && _random.nextDouble() < 0.15) {
          // Random income throughout month
          isIncome = true;
        }

        allExpenses.add(
          _generateRandomExpense(date, usedCategoriesForDay, isIncome),
        );
      }
    }

    await _databaseManager.insertExpenses(allExpenses);
  }

  Future<void> _generateAccountData() async {
    List<Account> accounts = [
      Account(
        name: 'Main Account',
        balance: 5000.0,
        cardNumber: '4532 **** **** 1234',
        expiryDate: '12/26',
        bankName: 'NBE',
        holderName: 'Ahmed Osama',
      ),
      Account(
        name: 'Savings Account',
        balance: 12000.0,
        cardNumber: '5678 **** **** 9012',
        expiryDate: '08/25',
        bankName: 'CIB',
        holderName: 'Ahmed Osama',
      ),
    ];

    await _databaseManager.insertAccounts(accounts);

    // Get accounts to retrieve their IDs
    List<Account> savedAccounts = await _databaseManager.getAccounts();
    _accountIds.clear();
    for (var account in savedAccounts) {
      if (account.id != null) {
        _accountIds.add(account.id!);
      }
    }
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
    bool isIncome,
  ) {
    int accountId =
        _accountIds.isNotEmpty
            ? _accountIds[_random.nextInt(_accountIds.length)]
            : 1;

    String category = _getCategoryBasedOnContext(
      date,
      usedCategoriesForDay,
      isIncome,
    );
    usedCategoriesForDay.add(category);

    double amount = _getRealisticAmount(category, isIncome);
    String description = _getRealisticDescription(category, isIncome);

    return Expense(
      amount: amount,
      category: category,
      description: description,
      date: date.toIso8601String().split('T')[0],
      positive: isIncome,
      accountId: accountId,
    );
  }

  String _getCategoryBasedOnContext(
    DateTime date,
    Set<String> usedCategoriesForDay,
    bool isIncome,
  ) {
    List<String> allCategories =
        isIncome
            ? List.from(incomeCategoryIcons.keys)
            : List.from(expenseCategoryIcons.keys);

    List<String> nonRepeatingCategories = ['Utilities', 'Healthcare'];

    for (String category in nonRepeatingCategories) {
      if (usedCategoriesForDay.contains(category) &&
          allCategories.contains(category)) {
        allCategories.remove(category);
      }
    }

    Map<String, double> weights = {};

    for (String category in allCategories) {
      double weight = 1.0;

      if (isIncome) {
        if (date.day <= 5 && category == 'Salary') weight *= 5.0;
        if (date.month == 12 && category == 'Gifts') weight *= 3.0;
      } else {
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

  double _getRealisticAmount(String category, bool isIncome) {
    if (isIncome) {
      switch (category) {
        case 'Salary':
          return _roundToDecimal(1500.0 + _random.nextDouble() * 3500.0);
        case 'Investments':
          return _roundToDecimal(100.0 + _random.nextDouble() * 900.0);
        case 'Gifts':
          return _roundToDecimal(20.0 + _random.nextDouble() * 200.0);
        case 'Miscellaneous':
          return _roundToDecimal(10.0 + _random.nextDouble() * 300.0);
        default:
          return _roundToDecimal(50.0 + _random.nextDouble() * 200.0);
      }
    } else {
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
  }

  double _roundToDecimal(double value) {
    return (value * 100).round() / 100;
  }

  String _getRealisticDescription(String category, bool isIncome) {
    final Map<String, List<String>> expenseDescriptions = {
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

    final Map<String, List<String>> incomeDescriptions = {
      'Salary': [
        'Monthly salary',
        'Bi-weekly paycheck',
        'Overtime payment',
        'Quarterly bonus',
        'Commission payment',
      ],
      'Investments': [
        'Stock dividends',
        'Interest income',
        'Rental income',
        'Cryptocurrency gains',
        'Bond interest',
      ],
      'Gifts': [
        'Birthday gift',
        'Holiday gift',
        'Wedding present',
        'Graduation gift',
        'Cash gift from family',
      ],
      'Miscellaneous': [
        'Refund payment',
        'Selling items online',
        'Garage sale',
        'Freelance work',
        'Cash back reward',
        'Tax refund',
      ],
    };

    final Map<String, List<String>> descriptions =
        isIncome ? incomeDescriptions : expenseDescriptions;

    if (!descriptions.containsKey(category)) {
      return "Payment";
    }

    final List<String> categoryDescriptions = descriptions[category]!;
    return categoryDescriptions[_random.nextInt(categoryDescriptions.length)];
  }
}
