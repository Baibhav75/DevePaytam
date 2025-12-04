import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String transactionDate;
  final String transactionType;
  final String debitedFrom;
  final String amount;

  const TransactionSuccessScreen({
    super.key,
    this.transactionId = '2748569855',
    this.transactionDate = '1 Nov 2022 (06:59pm)',
    this.transactionType = 'Mobile recharge',
    this.debitedFrom = 'HDFC bank',
    this.amount = '\$500',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryTeal.withOpacity(0.05),
      body: SafeArea(
        child: Column(
          children: [
            // Teal Status Bar
            Container(
              height: 40,
              color: kPrimaryTeal,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Success Icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kPrimaryTeal.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                        ),
                        // Middle ring
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kPrimaryTeal.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                        ),
                        // Inner circle with checkmark
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: kPrimaryTeal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Success Text
                    const Text(
                      'Transaction successful',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Transaction Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Transaction id', transactionId),
                          const Divider(height: 32),
                          _buildDetailRow('Transaction date', transactionDate),
                          const Divider(height: 32),
                          _buildDetailRow('Transaction type', transactionType),
                          const Divider(height: 32),
                          _buildDetailRow('Debited from', debitedFrom),
                          const Divider(height: 32),
                          _buildDetailRow('Amount', amount),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            // Back to home link
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Back to home',
                  style: TextStyle(
                    color: kPrimaryTeal,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}


