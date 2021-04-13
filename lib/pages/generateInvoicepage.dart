import 'package:basic_invoice_generator/models/Invoice.dart';
import 'package:basic_invoice_generator/pdf_gens/inv_model1.dart';
import 'package:flutter/material.dart';

class GenerateInvoicePage extends StatefulWidget {
  Invoice invoice;
  GenerateInvoicePage({this.invoice});
  @override
  _GenerateInvoicePageState createState() =>
      _GenerateInvoicePageState(invoice: this.invoice);
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  Invoice invoice;
  _GenerateInvoicePageState({this.invoice});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InvoiceModel1(invoice).makeAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
