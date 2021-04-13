import 'dart:io';

import 'package:basic_invoice_generator/models/Invoice.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class InvoiceModel1 {
  Invoice invoice;
  InvoiceModel1(this.invoice);

  double total_sgst = 0;
  double total_cgst = 0;
  double total_price = 0;
  calculateLineTotals() {
    total_price = 0;
    total_cgst = 0;
    total_cgst = 0;
    if (invoice.lineItems.length < 1) {
      return;
    }
    invoice.lineItems.forEach((element) {
      total_price += element.price;
      total_cgst += element.cgst;
      total_sgst += element.sgst;
    });

    total_cgst = total_cgst / invoice.lineItems.length;
    total_sgst = total_sgst / invoice.lineItems.length;
  }

  makeAndSave() async {
    calculateLineTotals();
    final pdf = Document();
    // var image = null;
    Directory tempdir = await getApplicationDocumentsDirectory();
    // File f = File(tempdir.path + "/sign.png");
    // if (f.existsSync()) {
    //   image = MemoryImage(
    //     File(tempdir.path + "/sign.png").readAsBytesSync(),
    //   );
    // }
    //

    var company = Hive.box("company");
    PdfColor _color = PdfColors.blue;
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        build: (bc) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildheader(company, _color),
              SizedBox(height: 30),
              buildclientddetails(_color),
              SizedBox(height: 30),
              Table(
                border: TableBorder(
                  left: BorderSide(width: 0.5),
                  right: BorderSide(width: 0.5),
                  top: BorderSide(width: 0.5),
                  bottom: BorderSide(width: 0.5),
                ),
                children: [
                      TableRow(
                          decoration: BoxDecoration(
                            color: _color,
                          ),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                  right: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text("Description"),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                  right: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text("qty"),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                  right: BorderSide(
                                    width: 1,
                                    color: PdfColors.grey,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text("Unit Price"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text("Amount"),
                            ),
                          ])
                    ] +
                    invoice.lineItems.map((e) {
                      return TableRow(
                          decoration: BoxDecoration(
                              color: invoice.lineItems.indexOf(e) % 2 == 0
                                  ? PdfColors.grey200
                                  : PdfColors.white),
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(e.description)),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(e.qty.toString())),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(e.price.toString())),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: PdfColors.grey,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text((e.price * e.qty).toString())),
                          ]);
                    }).toList(),
              ),
              Row(children: [
                Spacer(flex: 6),
                Expanded(
                  flex: 4,
                  child: Container(
                    // padding: EdgeInsets.all(5),
                    color: _color,
                    child: Table(
                        border:
                            TableBorder.all(width: 1, color: PdfColors.grey),
                        children: [
                          buildTableRow("Subtotal",
                              total_price.roundToDouble().toString()),
                          buildTableRow("CGST",
                              total_sgst.roundToDouble().toString() + " %"),
                          buildTableRow("SGST",
                              total_cgst.roundToDouble().toString() + " %"),
                          buildTableRow(
                            "Total",
                            (total_price *
                                    (((total_cgst + total_sgst) / 100) + 1))
                                .roundToDouble()
                                .toString(),
                          ),
                        ]),
                  ),
                )
              ])
            ],
          );
        },
      ),
    );
    // Directory tempdir2 = await getApplicationDocumentsDirectory();
    final file = File(tempdir.path + "/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
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

  Column buildclientddetails(PdfColor _color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Bill To:',
        style:
            TextStyle(color: _color, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Text(invoice.clientName),
      Text(invoice.clientAddress),
      SizedBox(height: 30),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Invoice Date",
              style: TextStyle(color: _color, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(invoice.invoiceDate)
        ]),
        SizedBox(width: 30),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Due Date",
              style: TextStyle(color: _color, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(invoice.dueDate)
        ]),
        SizedBox(width: 30),
      ])
    ]);
  }

  Row buildheader(Box company, PdfColor _color) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.get("name"),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(company.get("address")),
                // Text("city"),
                Text(company.get("country") + " - " + company.get("pincode")),
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Invoice",
                    style: TextStyle(
                        color: _color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text("#" + invoice.invoiceNo),
              ])
        ]);
  }
}
