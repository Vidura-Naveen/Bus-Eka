import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/admin/route/route_add_edit.dart';
import 'package:bus_eka_test/screens/admin/route/route_firebase_service.dart';
import 'package:bus_eka_test/screens/admin/route/route_model.dart';

class RouteCrud extends StatefulWidget {
  @override
  _RouteCrudState createState() => _RouteCrudState();
}

class _RouteCrudState extends State<RouteCrud> {
  final RouteFirebaseService _firebaseService = RouteFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Routez>>(
              stream: _firebaseService.getRoutes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Routez> routes = snapshot.data!;

                return ListView.builder(
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    Routez route = routes[index];
                    return ListTile(
                      title: Text(route.routename),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${route.routename}'),
                          Text('FromLat: ${route.fromlatitude}'),
                          Text('FromLong: ${route.fromlongitude}'),
                          Text('ToLat: ${route.tolatitude}'),
                          Text('ToLong: ${route.tolongitude}'),
                          Text('Ticket Price: ${route.ticketprice}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditRoute(context, route);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _firebaseService.deleteRoute(route.routeid);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                _navigateToAddRoute(context);
              },
              label: Text('Add Route'),
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddRoute(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditRoutePage()),
    );
  }

  void _navigateToEditRoute(BuildContext context, Routez route) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditRoutePage(route: route)),
    );
  }
}
