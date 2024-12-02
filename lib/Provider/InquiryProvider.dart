import 'package:flutter/material.dart';

class InquiryProvider with ChangeNotifier {
  final List<String> _inquiries = ["When can I book?", "How long will the service take?"];

  List<String> get inquiries => _inquiries;
}
