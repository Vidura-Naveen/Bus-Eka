import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/route/route_firebase_service.dart';
import 'package:bus_eka/screens/admin/route/route_model.dart';
import 'package:uuid/uuid.dart';

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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
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
