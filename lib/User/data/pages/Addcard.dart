import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewCardScreen extends StatefulWidget {
  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  // TextEditingControllers to capture user input
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Card', style: GoogleFonts.roboto()),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the card with user inputs
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debit Card',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _cardHolderController.text.isNotEmpty
                          ? _cardHolderController.text
                          : 'CARDHOLDER NAME',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _cardNumberController.text.isNotEmpty
                          ? _formatCardNumber(_cardNumberController.text)
                          : '**** **** **** ****',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _expiryDateController.text.isNotEmpty
                              ? _expiryDateController.text
                              : 'MM/YY',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                        Text(
                          _cvvController.text.isNotEmpty
                              ? _cvvController.text
                              : 'CVV',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildTextField('Card Holder Name', _cardHolderController),
              SizedBox(height: 16),
              _buildTextField('Card Number', _cardNumberController),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child:
                        _buildTextField('Expiry Date', _expiryDateController),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('CVV', _cvvController),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addCard();
                },
                child: Text('Add', style: GoogleFonts.roboto()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  String _formatCardNumber(String cardNumber) {
    return cardNumber.replaceAll(RegExp(r'(\d{4})(?=\d)'), r'$1 ').trim();
  }

  void _addCard() {
    // You can use a Provider, Bloc, or any state management solution to pass the data to your payment screen
    // For this example, let's use Navigator to go back and pass the data
    Navigator.pop(context, {
      'holder': _cardHolderController.text,
      'number': _cardNumberController.text,
      'expiry': _expiryDateController.text,
      'cvv': _cvvController.text,
    });
  }
}
