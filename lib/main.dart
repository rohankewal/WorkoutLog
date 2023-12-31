import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WorkoutLog {
  final String exercise;
  final int sets;
  final List<SetData> setData;
  final DateTime date;

  WorkoutLog({
    required this.exercise,
    required this.sets,
    required this.setData,
    required this.date,
  });
}

class SetData {
  int reps;
  double weight;

  SetData({
    required this.reps,
    required this.weight,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Log',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF2E2C42),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      home: const WorkoutListPage(),
    );
  }
}

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({Key? key}) : super(key: key);

  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  final List<WorkoutLog> _workoutLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Log'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: 420,
              width: 370,
              child: Card(
                color: const Color(0xFF2E2C42),
                elevation: 5,
                child: CalendarCarousel(
                  onDayPressed: (DateTime date, List<Event> events) {
                    // Handle calendar day press event if needed
                  },
                  weekendTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 14.0),
                  thisMonthDayBorderColor: Colors.transparent,
                  headerTextStyle:
                      const TextStyle(fontSize: 20.0, color: Color(0xFF34D1C2)),
                  weekdayTextStyle: const TextStyle(color: Colors.white),
                  selectedDateTime: DateTime.now(),
                  daysHaveCircularBorder: true,
                  showOnlyCurrentMonthDate: true,
                  prevDaysTextStyle: const TextStyle(fontSize: 12.0),
                  nextDaysTextStyle: const TextStyle(fontSize: 12.0),
                  selectedDayButtonColor: const Color(0xFF34D1C2),
                  selectedDayBorderColor: Colors.transparent,
                  selectedDayTextStyle: const TextStyle(color: Colors.white),
                  daysTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 14.0),
                  customDayBuilder: (
                    bool isSelectable,
                    int index,
                    bool isSelectedDay,
                    bool isToday,
                    bool isPrevMonthDay,
                    TextStyle textStyle,
                    bool isNextMonthDay,
                    bool isThisMonthDay,
                    DateTime day,
                  ) {
                    Color? textColor =
                        isSelectable ? Colors.white : Colors.grey;
                    Color? boxColor = isSelectedDay
                        ? const Color(0xFF34D1C2)
                        : Colors.transparent;
                    if (isToday) {
                      boxColor = Colors.yellow;
                    }
                    if (isPrevMonthDay || isNextMonthDay) {
                      textColor = Colors.grey;
                    }
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: boxColor,
                          gradient: isSelectedDay
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF34D1C2),
                                    Color(0xFF31A6DC),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: textStyle.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _workoutLogs.length,
              itemBuilder: (context, index) {
                final workout = _workoutLogs[index];

                final bool showHeader = index == 0 ||
                    _workoutLogs[index].date.day !=
                        _workoutLogs[index - 1].date.day;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        color: const Color(0xFF2E2C42),
                        child: Text(
                          workout.date.toString().substring(0, 10),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _workoutLogs.removeAt(index);
                        });
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                        color: const Color(0xFF2E2C42),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            workout.exercise,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Date: ${workout.date.toString().substring(0, 10)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailPage(workout),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34D1C2),
              Color(0xFF31A6DC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final newWorkout = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WorkoutInputPage()),
            );

            if (newWorkout != null) {
              setState(() {
                _workoutLogs.add(newWorkout);
                _workoutLogs.sort((a, b) => b.date.compareTo(a.date));
              });
            }
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class WorkoutInputPage extends StatefulWidget {
  const WorkoutInputPage({Key? key}) : super(key: key);

  @override
  _WorkoutInputPageState createState() => _WorkoutInputPageState();
}

class _WorkoutInputPageState extends State<WorkoutInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  List<SetData> _setData = [];

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _exerciseController,
                    decoration: const InputDecoration(
                      labelText: 'Exercise',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an exercise';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _setsController,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the number of sets';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Set Data:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _setData.length,
                    itemBuilder: (context, index) {
                      return SetInput(
                        setNumber: index + 1,
                        onRepsChanged: (value) {
                          setState(() {
                            _setData[index].reps = int.parse(value);
                          });
                        },
                        onWeightChanged: (value) {
                          setState(() {
                            _setData[index].weight = double.parse(value);
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Add Set'),
                    onPressed: () {
                      setState(() {
                        final sets = int.parse(_setsController.text);
                        _setData = List.generate(
                          sets,
                          (_) => SetData(reps: 0, weight: 0.0),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final exercise = _exerciseController.text;
                        final sets = int.parse(_setsController.text);

                        final workoutLog = WorkoutLog(
                          exercise: exercise,
                          sets: sets,
                          setData: _setData,
                          date: DateTime.now(),
                        );

                        Navigator.pop(context, workoutLog);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SetInput extends StatelessWidget {
  final int setNumber;
  final ValueChanged<String> onRepsChanged;
  final ValueChanged<String> onWeightChanged;

  const SetInput({
    Key? key,
    required this.setNumber,
    required this.onRepsChanged,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Reps',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            onChanged: onRepsChanged,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Weight',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            onChanged: onWeightChanged,
          ),
        ),
      ],
    );
  }
}

class WorkoutDetailPage extends StatelessWidget {
  final WorkoutLog workout;

  const WorkoutDetailPage(this.workout, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Detail'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercise: ${workout.exercise}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 16.0),
              Text(
                'Sets:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workout.setData.length,
                itemBuilder: (context, index) {
                  final setData = workout.setData[index];
                  final setNumber = index + 1;
                  return ListTile(
                    title: Text(
                      'Set $setNumber',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Reps: ${setData.reps}, Weight: ${setData.weight} lbs.',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Card(
                color: const Color(0xFF2E2C42),
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.bar_chart_outlined,
                                color: Color(0xFF31A6DC),
                              ),
                            ),
                            TextSpan(
                                text: ' Progress Chart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                        height: 15.0,
                      ),
                      SizedBox(
                        height: 200.0,
                        child: BarChart(
                          workout: workout,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final WorkoutLog workout;

  const BarChart({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setData = workout.setData;

    final List<charts.Series<SetData, String>> seriesList = [
      charts.Series<SetData, String>(
        id: 'Sets',
        domainFn: (SetData set, _) => set.reps.toString(),
        measureFn: (SetData set, _) => set.weight,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(const Color(0xFF34D1C2)),
        data: setData,
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }
}
