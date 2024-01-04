import 'dart:async';
import 'dart:io';
import 'package:bus_eka/screens/passenger/passenger_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:url_launcher/url_launcher.dart';

class TicketPage extends StatefulWidget {
  final List<int> newlyBookedSeats;
  final String routeName;
  final double ticketPrice;
  final String busName;
  final DateTime selectedDate;
  final String userName;

  TicketPage({
    required this.newlyBookedSeats,
    required this.routeName,
    required this.ticketPrice,
    required this.busName,
    required this.selectedDate,
    required this.userName,
  });

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late StreamController<String> _downloadLinkController;
  String downloadLink = ''; // Add a variable to store the download link

  @override
  void initState() {
    super.initState();
    _downloadLinkController = StreamController<String>();
    _downloadTicket();
  }

  Future<void> _downloadTicket() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Hello ${widget.userName}',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('This is your Ticket',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Route: ${widget.routeName}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Bus: ${widget.busName}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text(
                  'Date: ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 16),
              pw.Text('Seats: ${widget.newlyBookedSeats.join(', ')}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text(
                  'Total: Rs${widget.newlyBookedSeats.length * widget.ticketPrice}0',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ticket_example.pdf");
    await file.writeAsBytes(await pdf.save());

    final ref = FirebaseStorage.instance.ref().child(
        'TicketpdfInfo/${widget.userName}${widget.routeName}${widget.busName}${widget.newlyBookedSeats.join(', ')}ticket.pdf');
    await ref.putFile(file);

    // Set the download link when the file is successfully uploaded
    final link = await ref.getDownloadURL();
    _downloadLinkController.add(link);
    setState(() {
      downloadLink = link;
    }); // Add the link to the stream
  }

  // Function to copy the URL to the clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: downloadLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL copied to clipboard'),
      ),
    );
  }

  @override
  void dispose() {
    _downloadLinkController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PassengerOption(),
              ),
            );
          },
        ),
        title: Text('Booking Confirmation'),
        backgroundColor: Colors.white,
        toolbarTextStyle: TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontSize: 20),
        ).bodyMedium,
        titleTextStyle: TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontSize: 20),
        ).titleLarge,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello ${widget.userName}',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('This is your Ticket',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text('Route: ${widget.routeName}',
                    style: TextStyle(fontSize: 18)),
                Text('Bus: ${widget.busName}', style: TextStyle(fontSize: 18)),
                Text(
                    'Date: ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Text('Seats: ${widget.newlyBookedSeats.join(', ')}',
                    style: TextStyle(fontSize: 18)),
                Text(
                    'Total: Rs${widget.newlyBookedSeats.length * widget.ticketPrice}0',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _copyToClipboard();
                  },
                  child: Text('Show Downloadable Link'),
                ),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    _copyToClipboard();
                  },
                ),
                SizedBox(height: 16),
                StreamBuilder<String>(
                  stream: _downloadLinkController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return SelectableText(
                        '${snapshot.data}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container if no data is available yet
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
