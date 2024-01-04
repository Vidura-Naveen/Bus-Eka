import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/admin/bus/bus_firebase_service.dart';
import 'package:bus_eka_test/screens/admin/bus/bus_model.dart';
import 'package:bus_eka_test/screens/admin/route/route_firebase_service.dart';
import 'package:bus_eka_test/screens/admin/route/route_model.dart';
import 'package:uuid/uuid.dart';

class AddEditBusPage extends StatefulWidget {
  final Bus? bus;

  AddEditBusPage({Key? key, this.bus}) : super(key: key);

  @override
  _AddEditBusPageState createState() => _AddEditBusPageState();
}

class _AddEditBusPageState extends State<AddEditBusPage> {
  final BusFirebaseService _busfirebaseService = BusFirebaseService();
  final RouteFirebaseService _routeFirebaseService = RouteFirebaseService();

  final _busformKey = GlobalKey<FormState>();

  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _seatcountController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  List<Routez> _routes = [];
  String? _selectedRouteId;

  @override
  void initState() {
    super.initState();
    if (widget.bus != null) {
      _busNameController.text = widget.bus!.busname;
      _seatcountController.text = widget.bus!.seatcount.toString();
      _startTimeController.text = widget.bus!.starttime;
      _endTimeController.text = widget.bus!.endtime;
      _routeController.text = widget.bus!.route;
      _selectedRouteId = widget.bus!.route; // Set the selected route ID
    }
    _fetchRoutes();
  }

  void _fetchRoutes() {
    _routeFirebaseService.getRoutes().listen((List<Routez> routes) {
      setState(() {
        _routes = routes;
      });
    });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime =
          "${picked.hour}:${picked.minute} ${picked.period == DayPeriod.am ? 'AM' : 'PM'}";
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bus == null ? 'Add Bus' : 'Edit Bus'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _busformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _busNameController,
                  decoration: InputDecoration(labelText: 'Bus Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bus name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _seatcountController,
                  decoration: InputDecoration(labelText: 'Seat Count'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the seat count';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () => _selectTime(context, _startTimeController),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: InputDecoration(labelText: 'Start Time'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the start time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () => _selectTime(context, _endTimeController),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: InputDecoration(labelText: 'End Time'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the end time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRouteId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRouteId = newValue;
                      _routeController.text = newValue ?? "";
                    });
                  },
                  items: _routes.map((Routez route) {
                    return DropdownMenuItem<String>(
                      value: route.routeid,
                      child: Text(route.routename),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Route'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a route';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_busformKey.currentState?.validate() ?? false) {
                      _saveBus();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.bus == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveBus() {
    final String busId = widget.bus?.busid ?? Uuid().v4();
    final String busname = _busNameController.text;
    final int seatcount = int.parse(_seatcountController.text);
    final String starttime = _startTimeController.text;
    final String endtime = _endTimeController.text;
    final String route = _routeController.text;

    Bus bus = Bus(
        busid: busId,
        busname: busname,
        seatcount: seatcount,
        route: route,
        starttime: starttime,
        endtime: endtime);

    if (widget.bus == null) {
      _busfirebaseService.addBus(bus);
    } else {
      _busfirebaseService.updateBus(bus);
    }
  }
}
