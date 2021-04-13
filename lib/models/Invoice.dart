class Invoice {
  Invoice({
    this.clientName,
    this.clientAddress,
    this.invoiceNo,
    this.invoiceDate,
    this.dueDate,
    this.lineItems,
  });

  String clientName;
  String clientAddress;
  String invoiceNo;
  String invoiceDate;
  String dueDate;
  List<LineItem> lineItems;
}

class LineItem {
  LineItem({
    this.description,
    this.qty,
    this.price,
    this.sgst,
    this.cgst,
  });

  String description;
  int qty;
  double price;
  int sgst;
  int cgst;
}
