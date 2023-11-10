import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'ProgramDescriptionScreen.dart';
import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      home: const ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 0;
  List<Tableau> selectedTableau = [];
  List<int> channelIDs = [132, 163, 164, 205];

  Future<List<Tableau>> fetchTableauData(int channelID) async {
    final urlString =
        'https://api.sr.se/api/v2/scheduledepisodes?channelid=$channelID&format=json';
    final dio = Dio();

    try {
      final response = await dio.get(urlString);
      final responseSchedule =
          List<Map<String, dynamic>>.from(response.data['schedule']);

      final tableaus = responseSchedule.map((data) {
        return Tableau(
          title: data['title'],
          description: data['description'],
          startTime: parseCustomDate(data['starttimeutc']),
          endTime: parseCustomDate(data['endtimeutc']),
          imageString: data['imageurl'],
        );
      }).toList();

      return tableaus;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  void _onChannelTapped(int index) {
    fetchTableauData(channelIDs[index]).then((data) {
      setState(() {
        _selectedIndex = index;
        selectedTableau = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Sveriges Radio',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Tableau>>(
          future: fetchTableauData(channelIDs[_selectedIndex]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ScheduleList(schedule: snapshot.data ?? []);
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('images/p1.png', width: 24, height: 24),
            label: 'P1',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/p2.png', width: 24, height: 24),
            label: 'P2',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/p3.png', width: 24, height: 24),
            label: 'P3',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/p4.png', width: 24, height: 24),
            label: 'P4',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onChannelTapped,
      ),
    );
  }
}

class Tableau {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageString;

  Tableau({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.imageString,
  });
}

DateTime parseCustomDate(String customDate) {
  final int milliseconds =
      int.parse(customDate.replaceAll(RegExp(r'[^0-9]'), ''));
  return DateTime.fromMillisecondsSinceEpoch(milliseconds);
}

class ScheduleList extends StatelessWidget {
  final List<Tableau> schedule;

  const ScheduleList({required this.schedule, Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final Tableau tableau = schedule[index];

          final startTimeFormatted =
              "${tableau.startTime.hour.toString().padLeft(2, '0')}:${tableau.startTime.minute.toString().padLeft(2, '0')}";
          final endTimeFormatted =
              "${tableau.endTime.hour.toString().padLeft(2, '0')}:${tableau.endTime.minute.toString().padLeft(2, '0')}";

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProgramDescriptionScreen(tableau: tableau),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.grey[300],
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startTimeFormatted,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Flexible(
                      child: Text(
                        tableau.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      endTimeFormatted,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
