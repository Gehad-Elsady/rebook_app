import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // A method to periodically check for expired time and refresh the UI
  void startTimer(Duration duration, void Function() onTimeout) {
    Timer(
        duration, onTimeout); // After the time passes, the callback is executed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: StreamBuilder<List<HistoryModel>>(
          stream: FirebaseFunctions.getHistoryStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Error loading history: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                "history-empty",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ));
            }

            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];

                // Handling null timestamp with a fallback
                DateTime timestamp = history.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                    : DateTime.now();
                DateTime now = DateTime.now();
                Duration timeDiff = now.difference(timestamp);

                // Show cancel button only if the order was placed within 5 minutes
                bool enableCancelButton = timeDiff.inMinutes < 5;

                // Start a timer to refresh the UI after 5 minutes
                if (enableCancelButton) {
                  startTimer(Duration(seconds: 300 - timeDiff.inSeconds), () {
                    setState(() {}); // Trigger a rebuild to refresh the UI
                  });
                }

                String formattedTime = DateFormat('yyyy-MM-dd HH:mm a')
                    .format(timestamp.toLocal());

                return Card(
                  color: Color(0xff02457A),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Service Type: ${history.orderType ?? 'N/A'}',
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 18,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        Text(
                          "Timestamp: $formattedTime",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 12),

                        // Order status
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Order Status: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: history.orderStatus,
                                style: TextStyle(
                                  color: history.orderStatus == 'Pending'
                                      ? Colors.amberAccent
                                      : Colors.greenAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Service Items
                        if (history.items != null && history.items!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: history.items!.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image on the left
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item.serviceModel.image,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            height: 80,
                                            width: 80,
                                            alignment: Alignment.center,
                                            child:
                                                const CircularProgressIndicator(
                                                    color: Colors.white),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 80,
                                          width: 80,
                                          color: Colors.grey[700],
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.broken_image,
                                              color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Text on the right
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: ${item.serviceModel.name}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Price: \$${item.serviceModel.price}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.amberAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 10),

                        if (enableCancelButton)
                          Text(
                            "Cancel within ${5 - timeDiff.inMinutes} minutes",
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        const SizedBox(height: 10),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: enableCancelButton
                                  ? Colors.redAccent
                                  : Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            onPressed: enableCancelButton
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Cancel Order"),
                                          content: const Text(
                                              "Are you sure you want to cancel this order?"),
                                          actions: [
                                            TextButton(
                                              child: const Text("Yes"),
                                              onPressed: () {
                                                FirebaseFunctions
                                                    .deleteHistoryOrder(
                                                        history.timestamp!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
