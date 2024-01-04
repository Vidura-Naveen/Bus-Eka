import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/route/route_firebase_service.dart';
import 'package:bus_eka/screens/admin/route/route_model.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddEditRoutePage extends StatefulWidget {
  final Routez? route;

  AddEditRoutePage({Key? key, this.route}) : super(key: key);

  @override
  _AddEditRoutePageState createState() => _AddEditRoutePageState();
}

class _AddEditRoutePageState extends State<AddEditRoutePage> {
  final RouteFirebaseService _routefirebaseService = RouteFirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _routeNumberController = TextEditingController();
  final TextEditingController _fromLatitudeController = TextEditingController();
  final TextEditingController _fromLongitudeController =
      TextEditingController();
  final TextEditingController _toLatitudeController = TextEditingController();
  final TextEditingController _toLongitudeController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.route != null) {
      _routeNumberController.text = widget.route!.routename;
      _fromLatitudeController.text = widget.route!.fromlatitude.toString();
      _fromLongitudeController.text = widget.route!.fromlongitude.toString();
      _toLatitudeController.text = widget.route!.tolatitude.toString();
      _toLongitudeController.text = widget.route!.tolongitude.toString();
      _ticketPriceController.text = widget.route!.ticketprice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.route == null ? 'Add route' : 'Edit route'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _routeNumberController,
                  decoration: InputDecoration(labelText: 'route Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a route name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _fromLatitudeController,
                  decoration: InputDecoration(labelText: 'From Lat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a latitude';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _fromLongitudeController,
                  decoration: InputDecoration(labelText: 'From Long'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a longitude';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _toLatitudeController,
                  decoration: InputDecoration(labelText: 'To Lat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a latitude';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _toLongitudeController,
                  decoration: InputDecoration(labelText: 'To Long'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a longitude';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _ticketPriceController,
                  decoration: InputDecoration(labelText: 'Price '),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Price';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                ...fileRelatedWidgets(), //The ... is the spread operator in Dart. It's used to expand the elements of an iterable (like a list) into the elements of the surrounding list or collection.
                // SizedBox(height: 16.0),
                // selectedFile != null
                //     ? Text(selectedFile!.path.split('/').last)
                //     : Icon(Icons.insert_drive_file),
                // SizedBox(height: 20),
                // ElevatedButton.icon(
                //   onPressed: pickFile,
                //   icon: Icon(Icons.attach_file),
                //   label: Text('Pick PDF'),
                // ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: submitFile,
                //   child: Text('Submit PDF'),
                // ),
                // SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                    // submitFile();
                    if (widget.route != null) {
                      submitFile();
                    }
                  },
                  child: Text(widget.route == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> fileRelatedWidgets() {
    if (widget.route != null) {
      return [
        SizedBox(height: 16.0),
        selectedFile != null
            ? Text(selectedFile!.path.split('/').last)
            : Icon(Icons.insert_drive_file),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: pickFile,
          icon: Icon(Icons.attach_file),
          label: Text('Pick PDF'),
        ),
      ];
    } else {
      return [];
    }
  }

  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> submitFile() async {
    if (selectedFile != null) {
      try {
        String routeId = widget.route?.routeid ?? Uuid().v4();
        await firebase_storage.FirebaseStorage.instance
            .ref('MyPdf/$routeId.pdf')
            // .ref('MyPdf/${widget.route!.routeid}/${selectedFile!.path.split('/').last}')
            .putFile(selectedFile!);
        // TODO: Add any additional processing or actions after file submission
      } on firebase_storage.FirebaseException catch (e) {
        // Handle error
        print('Error uploading file: $e');
      }
    } else {
      // No file selected
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _saveRoute();
      Navigator.pop(context);
    }
  }

  void _saveRoute() {
    final String routeId = widget.route?.routeid ?? Uuid().v4();
    final String routename = _routeNumberController.text;
    final double fromlatitude = double.parse(_fromLatitudeController.text);
    final double fromlongitude = double.parse(_fromLongitudeController.text);
    final double tolatitude = double.parse(_toLatitudeController.text);
    final double tolongitude = double.parse(_toLongitudeController.text);
    final double ticketprice = double.parse(_ticketPriceController.text);

    Routez route = Routez(
      routeid: routeId,
      routename: routename,
      fromlatitude: fromlatitude,
      fromlongitude: fromlongitude,
      tolatitude: tolatitude,
      tolongitude: tolongitude,
      ticketprice: ticketprice,
    );

    if (widget.route == null) {
      _routefirebaseService.addRoute(route);
    } else {
      _routefirebaseService.updateRoute(route);
    }
  }
}
