// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void listenToFirestoreUpdates() {
//   FirebaseFirestore.instance
//       .collection('serviceRequests')
//       .snapshots()
//       .listen((snapshot) {
//     for (var docChange in snapshot.docChanges) {
//       if (docChange.type == DocumentChangeType.modified) {
//         // Check if the specific field was updated
//         var updatedField = docChange.doc.get('status');
//         if (updatedField != null && updatedField == 'completed') {
//            triggerNotification(
//               'Service Updated', 'Your service status is updated to completed');
//         }
//       }
//     }
//   });
//   void triggerNotification(String title, String body) {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 10, // unique ID for notification
//         channelKey: 'basic_channel', // same channel key used for initialization
//         title: title,
//         body: body,
//       ),
//     );
//   }
// }
