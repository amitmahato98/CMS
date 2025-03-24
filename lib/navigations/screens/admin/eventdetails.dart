import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';

// Add this class to your file
class EventDetailsPage extends StatelessWidget {
  final int eventIndex;
  final String eventTitle;

  const EventDetailsPage({
    Key? key,
    required this.eventIndex,
    required this.eventTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get event details based on the index
    final String eventTime =
        eventIndex == 0
            ? '9:00 AM - 11:00 AM'
            : eventIndex == 1
            ? 'All Day'
            : eventIndex == 2
            ? '2:00 PM - 4:00 PM'
            : '10:00 AM - 12:00 PM';

    final String eventLocation =
        eventIndex == 0
            ? 'Conference Room'
            : eventIndex == 1
            ? 'Online Portal'
            : eventIndex == 2
            ? 'Main Campus'
            : 'Admin Building';

    final String eventDate = '${eventIndex + 22} MAR 2025';

    final Color accentColor = eventIndex % 2 == 0 ? darkBlue : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        title: Text(eventTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: accentColor.withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${eventIndex + 22}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: accentColor,
                                ),
                              ),
                              Text(
                                'MAR',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: grayColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    eventTime,
                                    style: const TextStyle(color: grayColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: grayColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    eventLocation,
                                    style: const TextStyle(color: grayColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a detailed description for the ${eventTitle.toLowerCase()}. '
                      'The event will take place on ${eventDate} at ${eventLocation}. '
                      'Please arrive on time and bring all necessary materials.'
                      ' We look forward to seeing you there.'
                      '- Cmapus Dean : Mr. Dr. Prof. Amit Mahato',
                      style: const TextStyle(color: grayColor),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Participants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: accentColor.withOpacity(0.2),
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(color: accentColor),
                            ),
                          ),
                          title: Text(
                            index == 0
                                ? 'Dr. Sushanti Kumar'
                                : index == 1
                                ? 'Prof. Sittal Sins'
                                : 'Member Mindip Nepali',
                          ),
                          subtitle: Text(
                            index == 0
                                ? 'Faculty Head'
                                : index == 1
                                ? 'Parent concellor'
                                : 'Dean Member',
                            style: const TextStyle(color: grayColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
