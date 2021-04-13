import 'package:basic_invoice_generator/pages/homepage.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CompantDetails extends StatefulWidget {
  @override
  _CompantDetailsState createState() => _CompantDetailsState();
}

class _CompantDetailsState extends State<CompantDetails> {
  String _name = "";
  String _address = "";
  String _city = "";
  String _state = "";
  String _country = "";
  String _pincode = "";
  String _phone = "";
  String _email = "";
  String _gst = "";

  final _formKey = GlobalKey<FormState>();
  save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    var box = Hive.box("company");
    print(box.get("name"));
    _formKey.currentState.save();

    box.put("name", _name);
    box.put("address", _address);
    box.put("city", _city);
    box.put("state", _state);
    box.put("country", _country);
    box.put("pincode", _pincode);
    box.put("phone", _phone);
    box.put("email", _email);
    box.put("gst", _gst);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          save();
        },
        child: Icon(
          Icons.save,
        ),
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
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Company Details",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Company Name",
                    ),
                    onSaved: (v) {
                      _name = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "GST #",
                    ),
                    onSaved: (v) {
                      _gst = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Address",
                    ),
                    maxLines: 5,
                    minLines: 1,
                    onSaved: (v) {
                      _address = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "City",
                    ),
                    onSaved: (v) {
                      _city = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "State",
                    ),
                    onSaved: (v) {
                      _state = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Country",
                    ),
                    onSaved: (v) {
                      _country = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Pincode",
                    ),
                    onSaved: (v) {
                      _pincode = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Phone",
                    ),
                    onSaved: (v) {
                      _phone = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (v) {
                      _email = v;
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       save();
                  //     },
                  //     child: Text("Save & Continue"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
