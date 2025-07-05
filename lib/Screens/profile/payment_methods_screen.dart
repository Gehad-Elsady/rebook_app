import 'package:flutter/material.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/models/payment_method.dart';

class PaymentMethodsScreen extends StatefulWidget {
  static const String routeName = '/payment-methods';

  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  PaymentType _selectedType = PaymentType.bankAccount;
  bool _isLoading = false;
  List<PaymentMethod> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final methods = await FirebaseFunctions.getUserPaymentMethods();
      setState(() {
        _paymentMethods = methods;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load payment methods')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addPaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final method = PaymentMethod(
        type: _selectedType,
        accountName: _accountNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        isDefault: _paymentMethods.isEmpty, // Set as default if first method
      );

      await FirebaseFunctions.addPaymentMethod(method);
      
      // Clear form
      _accountNameController.clear();
      _accountNumberController.clear();
      
      // Reload methods
      await _loadPaymentMethods();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method added successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add payment method: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: _isLoading && _paymentMethods.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add New Payment Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<PaymentType>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Payment Type',
                                border: OutlineInputBorder(),
                              ),
                              items: PaymentType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(_getPaymentTypeName(type)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedType = value;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _accountNameController,
                              decoration: const InputDecoration(
                                labelText: 'Account Holder Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter account holder name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _accountNumberController,
                              decoration: InputDecoration(
                                labelText: _getAccountNumberLabel(_selectedType),
                                border: const OutlineInputBorder(),
                                hintText: _getAccountNumberHint(_selectedType),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${_getAccountNumberLabel(_selectedType).toLowerCase()}';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _addPaymentMethod,
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Add Payment Method'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_paymentMethods.isNotEmpty) ...[
                    const Text(
                      'Your Payment Methods',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._paymentMethods.map((method) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(_getPaymentTypeIcon(method.type)),
                            title: Text(_getPaymentTypeName(method.type)),
                            subtitle: Text(method.accountNumber),
                            trailing: method.isDefault
                                ? const Chip(
                                    label: Text('Default'),
                                    backgroundColor: Colors.blue,
                                    labelStyle: TextStyle(color: Colors.white),
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      try {
                                        await FirebaseFunctions.setDefaultPaymentMethod(
                                            method.id!);
                                        await _loadPaymentMethods();
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to set default method')),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: const Text('Set as Default'),
                                  ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
    );
  }

  String _getPaymentTypeName(PaymentType type) {
    switch (type) {
      case PaymentType.bankAccount:
        return 'Bank Account';
      case PaymentType.vodafoneCash:
        return 'Vodafone Cash';
      case PaymentType.instapay:
        return 'InstaPay';
    }
  }

  String _getAccountNumberLabel(PaymentType type) {
    switch (type) {
      case PaymentType.bankAccount:
        return 'Account Number';
      case PaymentType.vodafoneCash:
        return 'Phone Number';
      case PaymentType.instapay:
        return 'InstaPay Number';
    }
  }

  String _getAccountNumberHint(PaymentType type) {
    switch (type) {
      case PaymentType.bankAccount:
        return 'e.g., 1234567890';
      case PaymentType.vodafoneCash:
        return 'e.g., 01XXXXXXXX';
      case PaymentType.instapay:
        return 'e.g., 01XXXXXXXX';
    }
  }

  IconData _getPaymentTypeIcon(PaymentType type) {
    switch (type) {
      case PaymentType.bankAccount:
        return Icons.account_balance;
      case PaymentType.vodafoneCash:
        return Icons.phone_android;
      case PaymentType.instapay:
        return Icons.payment;
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }
}
