import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../theme/app_colors.dart';
import 'receiver_bank_form_screen.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({super.key});

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiUrl = 'https://vast-shore-74260.herokuapp.com/banks?city=MUMBAI';

  List<String> _allBanks = [];
  List<String> _filteredBanks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBanks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBanks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final banks = data
            .map((e) => (e['bank_name'] as String?)?.trim())
            .where((name) => name != null && name!.isNotEmpty)
            .cast<String>()
            .toSet()
            .toList()
          ..sort();
        setState(() {
          _allBanks = banks;
          _filteredBanks = banks;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed with code ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Unable to fetch banks. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks = _allBanks
          .where((bank) => bank.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final popularBanks = _filteredBanks.take(6).toList();
    final otherBanks = _filteredBanks.skip(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        title: const Text(
          'Select receiver bank',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: kCardLight.withOpacity(0.3),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: kPrimaryTeal),
                hintText: 'Search for receiver bank',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _buildContent(popularBanks, otherBanks),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<String> popularBanks, List<String> otherBanks) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: kPrimaryTeal));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _fetchBanks,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredBanks.isEmpty) {
      return const Center(
        child: Text(
          'No banks found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        if (popularBanks.isNotEmpty) ...[
          const Text(
            'Popular bank',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...popularBanks.map((bank) => _buildBankTile(bank)),
          const SizedBox(height: 20),
        ],
        if (otherBanks.isNotEmpty) ...[
          const Text(
            'Other bank',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...otherBanks.map((bank) => _buildBankTile(bank)),
        ],
      ],
    );
  }

  Widget _buildBankTile(String bankName) {
    final color = _generateColorFromName(bankName);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryTeal.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryTeal.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReceiverBankFormScreen(bankName: bankName),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kPrimaryTeal.withOpacity(0.15),
              child: Text(
                bankName.substring(0, 1),
                style: const TextStyle(color: kPrimaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                bankName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _generateColorFromName(String name) {
    final hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    final hue = hash % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.5, 0.8).toColor();
  }
}

