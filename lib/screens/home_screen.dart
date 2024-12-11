import 'package:flutter/material.dart';
import '../api/api_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiManager _apiManager = ApiManager();

  Map<String, dynamic>? _exchangeRates; // Stores fetched rates
  String _fromCurrency = 'USD'; // Default base currency
  String _toCurrency = 'INR'; // Default target currency
  String _conversionResult = '';
  TextEditingController _amountController = TextEditingController();
  DateTime? _lastUpdated; // Variable to store the last updated time

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  void _fetchRates() async {
    try {
      final data = await _apiManager.fetchExchangeRates(_fromCurrency);
      
      setState(() {
        _exchangeRates = data['rates'];
        _lastUpdated = DateTime.now(); // Set the last updated time
      });
    } catch (e) {
      setState(() {
        _conversionResult = 'Error fetching exchange rates: $e';
      });
    }
  }

  void _convertCurrency() {
    if (_exchangeRates != null && _amountController.text.isNotEmpty) {
      double amount = double.tryParse(_amountController.text) ?? 0;
      double rate = _exchangeRates![_toCurrency];
      double result = amount * rate;

      setState(() {
        _conversionResult =
            '$amount $_fromCurrency = ${result.toStringAsFixed(2)} $_toCurrency';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter amount'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    items: _exchangeRates?.keys
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value!;
                        _fetchRates(); // Update rates for new base currency
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toCurrency,
                    items: _exchangeRates?.keys
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        _toCurrency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16),
            Text(
              _conversionResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Display the last updated time
            Text(
              _lastUpdated == null
                  ? 'Fetching rates...'
                  : 'Last updated: ${_lastUpdated!.toLocal()}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
