import 'package:basic_invoice_generator/models/Invoice.dart';
import 'package:basic_invoice_generator/pages/additem.dart';
import 'package:basic_invoice_generator/pages/generateInvoicepage.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var company = Hive.box("company");
  double total_sgst = 0;
  double total_cgst = 0;
  double total_price = 0;
  List<LineItem> _items = [];
  final _formKey = GlobalKey<FormState>();

  String _clientName = "";
  String _clientAddress = "";
  String _invoiceNo = "";
  String _invoicedate = "";
  String _dueDate = "";

  calculateLineTotals() {
    total_price = 0;
    total_cgst = 0;
    total_cgst = 0;
    if (_items.length < 1) {
      setState(() {});
      return;
    }
    _items.forEach((element) {
      total_price += element.price;
      total_cgst += element.cgst;
      total_sgst += element.sgst;
    });

    total_cgst = total_cgst / _items.length;
    total_sgst = total_sgst / _items.length;

    setState(() {});
  }

  saveInvoice() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    Invoice inv = new Invoice(
      clientAddress: _clientAddress,
      clientName: _clientName,
      dueDate: _dueDate,
      invoiceDate: _invoicedate,
      invoiceNo: _invoiceNo,
      lineItems: _items,
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => GenerateInvoicePage(
                  invoice: inv,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice generator"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    company.get("name"),
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    company.get("address"),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildClientDetails(),
                  buildInvoiceDetails(),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Line Items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  ListView.builder(
                    itemCount: _items.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(_items[index].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Table(
                                  columnWidths: {0: FractionColumnWidth(0.2)},
                                  children: [
                                    buildTableRow(
                                        "Qty", _items[index].qty.toString()),
                                    buildTableRow(
                                        "CGST",
                                        (_items[index].price *
                                                    ((_items[index].cgst /
                                                        100)))
                                                .toString() +
                                            " (" +
                                            _items[index].cgst.toString() +
                                            " %)"),
                                    buildTableRow(
                                        "SGST",
                                        (_items[index].price *
                                                    ((_items[index].sgst /
                                                        100)))
                                                .toString() +
                                            " (" +
                                            _items[index].sgst.toString() +
                                            " %)"),
                                    buildTableRow(
                                      "Price",
                                      (_items[index].price * _items[index].qty)
                                          .toString(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        LineItem data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => AddItemPage(),
                            maintainState: true,
                            fullscreenDialog: true,
                          ),
                        );
                        if (data != null) {
                          print(data);
                          setState(() {
                            _items.add(data);
                          });
                          calculateLineTotals();
                        }
                      },
                      child: Text("Add Item")),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Table(
                      columnWidths: {
                        0: FractionColumnWidth(0.7),
                        1: FractionColumnWidth(0.3)
                      },
                      children: [
                        buildTableRow2(
                            "Subtotal", total_price.roundToDouble().toString()),
                        buildTableRow2("SGST",
                            total_sgst.roundToDouble().toString() + " %"),
                        buildTableRow2("CGST",
                            total_cgst.roundToDouble().toString() + " %"),
                        buildTableRow2(
                          "Total",
                          (total_price *
                                  (((total_cgst + total_sgst) / 100) + 1))
                              .roundToDouble()
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          saveInvoice();
        },
      ),
    );
  }

  TableRow buildTableRow(String key, String value) {
    return TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          child: Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          child: Text(value),
        ),
      ],
    );
  }

  TableRow buildTableRow2(String key, String value) {
    return TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          child: Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.only(right: 10),
          child: Text(
            value,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Card buildInvoiceDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Invoice Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              onSaved: (va) {
                _invoiceNo = va;
              },
              validator: (va) {
                if (va.isEmpty) {
                  return "Required";
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Invoice #"),
            ),
            DateTimePicker(
              onSaved: (va) {
                _invoicedate = va;
              },
              validator: (va) {
                if (va.isEmpty) {
                  return "Required";
                }
                return null;
              },
              dateLabelText: "Invoice Date",
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
            ),
            DateTimePicker(
              onSaved: (va) {
                _dueDate = va;
              },
              validator: (va) {
                if (va.isEmpty) {
                  return "Required";
                }
                return null;
              },
              dateLabelText: "Due Date",
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
            ),
          ],
        ),
      ),
    );
  }

  Card buildClientDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Client Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              onSaved: (va) {
                _clientName = va;
              },
              validator: (va) {
                if (va.isEmpty) {
                  return "Required";
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Client's Name"),
            ),
            TextFormField(
              onSaved: (va) {
                _clientAddress = va;
              },
              validator: (va) {
                if (va.isEmpty) {
                  return "Required";
                }
                return null;
              },
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: "Client's Address"),
            )
          ],
        ),
      ),
    );
  }
}
