import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'enter_amount_screen.dart';

class ReceiverBankFormScreen extends StatefulWidget {
  const ReceiverBankFormScreen({super.key, required this.bankName});

  final String bankName;

  @override
  State<ReceiverBankFormScreen> createState() => _ReceiverBankFormScreenState();
}

class _ReceiverBankFormScreenState extends State<ReceiverBankFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _recipientController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _ifscController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EnterAmountScreen(
            bankName: widget.bankName,
            accountNumber: _accountController.text,
            recipientName: _recipientController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _generateColorFromName(widget.bankName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.bankName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 32,
                backgroundColor: kPrimaryTeal.withOpacity(0.15),
                child: const Icon(Icons.account_balance, color: kPrimaryTeal, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                widget.bankName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account number',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Enter account number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Account number is required';
                        }
                        if (value.length < 8) {
                          return 'Account number must be at least 8 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'IFSC code',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _ifscController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _inputDecoration('Enter IFSC code'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'IFSC code is required';
                        }
                        if (value.length < 11) {
                          return 'Enter a valid IFSC code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Recipient name',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _recipientController,
                      decoration: _inputDecoration('Enter recipient name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Recipient name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The information will be securely saved as per Smart Pay terms of services and privacy policy',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimaryTeal.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimaryTeal.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryTeal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Color _generateColorFromName(String name) {
    final hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    final hue = hash % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.45, 0.8).toColor();
  }
}

