// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event.dart';
import '../../repositories/repositories.dart';
import 'events.dart';
import '../../config/config.dart';
// import 'event_detail_screen';

//  Variables utilisés pour TableCalendar
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class EventCalendarScreen extends StatefulWidget {
  static const String routeName = '/eventcalendar';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => EventCalendarScreen(),
    );
  }

  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  LinkedHashMap<DateTime, List<Event>>? _groupedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  _groupEvents(List<Event> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime dateEventNew = DateTime.fromMicrosecondsSinceEpoch(
          event.dateEvent.microsecondsSinceEpoch);

      DateTime date =
          DateTime(dateEventNew.year, dateEventNew.month, dateEventNew.day, 12);

      if (_groupedEvents?[date] == null) _groupedEvents?[date] = [];
      _groupedEvents?[date]?.add(event);
    });
  }

  List<Event> _getEventsForDay(DateTime date) {
    return _groupedEvents?[date] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(
          color: black,
        ),
        elevation: 3,
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          "Évènements",
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: primaryColor,
            ),
            onPressed: () {
              // late final String _selectedDateString =
              //     DateFormat("yyyy-MM-dd hh:mm:ss").format(_selectedDay);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         EventAddScreen(dateEvent: _selectedDateString),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: eventDBS.streamQueryList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final events = snapshot.data;
              _groupEvents(events);
              DateTime selectedDate = _selectedDay;
              // ignore: no_leading_underscores_for_local_identifiers
              final _selectedEvents = _groupedEvents![selectedDate] ?? [];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(8.0),
                      child: TableCalendar<Event>(
                        locale: 'fr_FR',
                        firstDay: kFirstDay,
                        lastDay: kLastDay,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDay),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsForDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration: BoxDecoration(
                            color: Color.fromARGB(125, 21, 91, 239),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: couleurBleuClair2,
                            shape: BoxShape.circle,
                          ),
                          markerSizeScale: 0.3,
                          markerDecoration: BoxDecoration(
                            color: couleurJauneOrange2,
                            shape: BoxShape.circle,
                          ),
                        ),
                        availableGestures: AvailableGestures.horizontalSwipe,
                        headerStyle:
                            const HeaderStyle(formatButtonVisible: false),
                        onDaySelected: _onDaySelected,
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Event event = _selectedEvents[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(event.profImage)),
                            title: Text(event.username),
                            subtitle: Text(event.title),
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    PostEventCard(event: event),
                              ),
                            ),
                            trailing: const Icon(
                              (Icons.arrow_forward),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            }
            return const Text(
              'Something went wrong.',
              style: TextStyle(color: white),
            );
          },
        ),
      ),
    );
  }
}
