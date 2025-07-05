import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebook_app/Screens/cart/model/cart-model.dart';
import 'package:rebook_app/Screens/cart/payment-scree.dart';
import 'package:rebook_app/Screens/cart/widget/cartitem.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/location/location.dart';

class AddressFormScreen extends StatefulWidget {
  final List<CartModel> cartItems;
  final double totalPrice;

  const AddressFormScreen({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  String _deliveryOption = 'standard';
  String _paymentMethod = 'credit_card';
  String _selectedRegion = 'southwest';
  String? _selectedGovernorate;
  
  // Shipping fees by governorate
  final Map<String, Map<String, double>> _shippingFees = {
    'southwest': {
      'Cairo': 30.0,
      'Giza': 30.0,
      '6th of October': 40.0,
      'Sheikh Zayed': 45.0,
      'Alexandria': 40.0,
    },
    'lower_egypt': {
      'Alexandria': 40.0,
      'Beheira': 50.0,
      'Kafr El Sheikh': 60.0,
      'Dakahlia': 70.0,
      'Damietta': 75.0,
    },
  };
  
  double _shippingFee = 0.0;
  double get _totalPrice => widget.totalPrice + _shippingFee;

  // Helper method to build price row
  Widget _buildPriceRow(String label, double amount, {bool isBold = false, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.domine(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? Colors.black87,
          ),
        ),
        Text(
          'EGP ${amount.toStringAsFixed(2)}',
          style: GoogleFonts.domine(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  void _updateShippingFee() {
    if (_selectedGovernorate != null) {
      final fee = _shippingFees[_selectedRegion]?[_selectedGovernorate] ?? 0.0;
      setState(() {
        _shippingFee = fee;
      });
    } else {
      setState(() {
        _shippingFee = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final addressData = {
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
      };

      // Add shipping fee and governorate to address data
      if (_selectedGovernorate != null) {
        addressData['governorate'] = _selectedGovernorate!;
        addressData['region'] = _selectedRegion == 'southwest' ? 'Southwest Face' : 'Lower Egypt';
      }
      
      // Navigate to GPS screen with order details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            historymaodel: HistoryModel(
              userId: FirebaseAuth.instance.currentUser!.uid,
              items: widget.cartItems,
              orderType: "Cart",
              shippingDetails: addressData,
              shippingFee: _shippingFee,
              totalAmount: _totalPrice,
            ),
            totalPrice: _totalPrice,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shipping Information',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Region and Governorate Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Delivery Region',
                        style: GoogleFonts.domine(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Region Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Select Region',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'southwest',
                            child: Text('Southwest Face'),
                          ),
                          DropdownMenuItem(
                            value: 'lower_egypt',
                            child: Text('Lower Egypt'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRegion = value;
                              _selectedGovernorate = null;
                              _updateShippingFee();
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a region';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Governorate Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGovernorate,
                        decoration: InputDecoration(
                          labelText: 'Select Governorate',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          prefixIcon: Icon(Icons.location_on, color: Colors.grey[600]),
                        ),
                        isExpanded: true,
                        hint: Text('Select a governorate'),
                        items: _shippingFees[_selectedRegion]!.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Row(
                              children: [
                                Text(entry.key),
                                Spacer(),
                                Text(
                                  'EGP ${entry.value.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGovernorate = value;
                            _updateShippingFee();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a governorate';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),              
              SizedBox(height: 24),
              // Price Summary
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildPriceRow('Subtotal', widget.totalPrice),
                      const Divider(height: 24),
                      _buildPriceRow('Shipping Fee', _shippingFee, isBold: false),
                      const Divider(height: 24),
                      _buildPriceRow(
                        'Total',
                        _totalPrice,
                        isBold: true,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Proceed to Payment EGP ${_totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.domine(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
