import 'package:flutter/material.dart';

import '../models/bank_account.dart';
import '../theme/app_colors.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reAccountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _recipientController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _reAccountNumberController.dispose();
    _ifscController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _handleProceed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop(
      BankAccount(
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        title: const Text('Add new bank account', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField('Bank name', _bankNameController, TextInputType.text),
                const SizedBox(height: 16),
                _buildField('Account number', _accountNumberController, TextInputType.number),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reAccountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Re - enter account number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please re-enter account number';
                    }
                    if (value != _accountNumberController.text) {
                      return 'Account numbers do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildField('IFSC number', _ifscController, TextInputType.text),
                const SizedBox(height: 16),
                _buildField('Recipient name', _recipientController, TextInputType.text),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Proceed',
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
                  'The information will be securely saved as per smart pay terms of services and privacy policy',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: kPrimaryTeal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

