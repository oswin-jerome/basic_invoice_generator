import 'package:basic_invoice_generator/models/Invoice.dart';
import 'package:flutter/material.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  int _qty = 0;
  double _price = 0;
  int _cgst = 0;
  int _sgst = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Item details"),
                TextFormField(
                  validator: (s) {
                    if (s.isEmpty) {
                      return "Fill this field";
                    }
                    return null;
                  },
                  onSaved: (va) {
                    _description = va;
                  },
                  decoration: InputDecoration(labelText: "description / item"),
                ),
                TextFormField(
                  onSaved: (va) {
                    _qty = int.parse(va);
                  },
                  validator: (s) {
                    if (s.isEmpty) {
                      return "Fill this field";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantity"),
                ),
                TextFormField(
                  onSaved: (va) {
                    _price = double.parse(va);
                  },
                  validator: (s) {
                    if (s.isEmpty) {
                      return "Fill this field";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price per qty"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (va) {
                          _cgst = int.parse(va);
                        },
                        validator: (s) {
                          if (s.isEmpty) {
                            return "Fill this field";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "CGST (%)"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        onSaved: (va) {
                          _sgst = int.parse(va);
                        },
                        validator: (s) {
                          if (s.isEmpty) {
                            return "Fill this field";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "SGST (%)"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      LineItem item = new LineItem(
                        cgst: _cgst,
                        sgst: _sgst,
                        description: _description,
                        price: _price,
                        qty: _qty,
                      );
                      Navigator.pop(context, item);
                    }
                  },
                  child: Text("Add item"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
