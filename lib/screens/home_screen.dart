import 'package:flutter/material.dart';
import '../api/api_manager.dart';

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final ApiManager _apiManager = ApiManager();

  Map<String, dynamic>? _exchangeRates; 
  String _fromCurrency = 'USD'; 
  String _toCurrency = 'INR'; 
  String _conversionResult = '';
  final TextEditingController _amountController = TextEditingController();
  DateTime? _lastUpdated; 

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _fetchRates() async {
    try {
      final data = await _apiManager.fetchExchangeRates(_fromCurrency);

      setState(() {
        _exchangeRates = data['rates'];
        _lastUpdated = DateTime.fromMillisecondsSinceEpoch(
          data['time_last_updated'] * 1000,
          isUtc: true,
        ); 
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

// Public factory function
Widget buildHomeScreen() {
  return const _HomeScreen(); // Provides controlled access
}
