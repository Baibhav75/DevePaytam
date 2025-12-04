import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_bank_screen.dart';

class ToAccountScreen extends StatelessWidget {
  const ToAccountScreen({super.key});

  final List<Map<String, dynamic>> _beneficiaries = const [
    {
      'name': 'Romit shah',
      'accountNumber': 'xxxx 5451',
      'bankName': 'HDFC bank',
      'bankColor': kPrimaryTeal,
    },
    {
      'name': 'Romit shah',
      'accountNumber': 'xxxx 5542',
      'bankName': 'State bank of india',
      'bankColor': kPrimaryTeal,
    },
    {
      'name': 'Jenny Wilson',
      'accountNumber': 'xxxx 5542',
      'bankName': 'ICICI bank',
      'bankColor': kPrimaryTeal,
    },
    {
      'name': 'Robert Fox',
      'accountNumber': 'xxxx 5542',
      'bankName': 'HDFC bank',
      'bankColor': kPrimaryTeal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'To account',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SelectBankScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 12),
                    Text(
                      'Search bank account',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _beneficiaries.length,
        itemBuilder: (context, index) {
          final beneficiary = _beneficiaries[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPrimaryTeal.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryTeal.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: beneficiary['bankColor'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beneficiary['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ac no : ${beneficiary['accountNumber']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        beneficiary['bankName'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardLight.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: kPrimaryTeal.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Handle add beneficiary
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add beneficiary account'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add beneficiary account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

