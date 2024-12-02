import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTicketsScreen extends StatefulWidget {
  const UserTicketsScreen({super.key});

  @override
  _UserTicketsScreenState createState() => _UserTicketsScreenState();
}

class _UserTicketsScreenState extends State<UserTicketsScreen> {
  bool _isLoading = true;
  late Future<List<Map<String, dynamic>>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _fetchAllTickets();
  }

  // Fetch all support tickets from the collection
  Future<List<Map<String, dynamic>>> _fetchAllTickets() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('support_tickets').get();

      List<Map<String, dynamic>> tickets = [];
      for (var doc in querySnapshot.docs) {
        tickets.add(doc.data() as Map<String, dynamic>);
      }

      return tickets;
    } catch (e) {
      throw Exception('Error fetching tickets: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _isLoading = true;
      _ticketsFuture = _fetchAllTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tickets'),
        backgroundColor: mainColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No tickets found.'));
                }

                List<Map<String, dynamic>> tickets = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: _refreshTickets,
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      var ticket = tickets[index];
                      return TicketCard(
                        ticket: ticket,
                        onReply: () => _showReplyDialog(ticket),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showReplyDialog(Map<String, dynamic> ticket) async {
    TextEditingController replyController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Reply to Ticket'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('User Email: ${ticket['email']}'),
                  SizedBox(height: 10),
                  Text('Issue: ${ticket['description']}'),
                  SizedBox(height: 10),
                  TextField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: 'Enter reply...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
              actions: [
                isSubmitting
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (replyController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter a reply')));
                            return;
                          }

                          setState(() {
                            isSubmitting = true;
                          });

                          try {
                            // Update the ticket with the admin's reply and close status
                            await FirebaseFirestore.instance
                                .collection('support_tickets')
                                .where('email', isEqualTo: ticket['email'])
                                .where('status', isEqualTo: 'open')
                                .get()
                                .then((querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                doc.reference.update({
                                  'status': 'closed',
                                  'admin_reply': replyController.text,
                                  'closed_at': FieldValue.serverTimestamp(),
                                });
                              }
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Ticket closed and reply sent')),
                            );
                            await _refreshTickets(); // Refresh tickets after closing
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')));
                          } finally {
                            setState(() {
                              isSubmitting = false;
                            });
                          }
                        },
                        child: Text('Submit Reply'),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}

// TicketCard Widget to display each ticket
class TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final VoidCallback onReply;

  const TicketCard({super.key, required this.ticket, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Email: ${ticket['email']}',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Issue Description:',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(ticket['description'],
                style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 10),
            Text('Status: ${ticket['status']}',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Created At: ${ticket['created_at'].toDate()}',
                style: GoogleFonts.poppins(fontSize: 14)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onReply,
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text('Reply & Close Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
