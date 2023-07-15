import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, Event;
import 'package:flutter_calendar_carousel/classes/event.dart';

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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Log',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      home: WorkoutListPage(),
    );
  }
}

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  List<WorkoutLog> _workoutLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Log'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<Event> events) {
                // Handle calendar day press event if needed
              },
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              headerTextStyle: TextStyle(fontSize: 24.0),
              weekdayTextStyle: TextStyle(color: Colors.black),
              selectedDateTime: DateTime.now(),
              daysHaveCircularBorder: true,
              showOnlyCurrentMonthDate: true,
              prevDaysTextStyle: TextStyle(fontSize: 16.0),
              nextDaysTextStyle: TextStyle(fontSize: 16.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _workoutLogs.length,
              itemBuilder: (context, index) {
                final workout = _workoutLogs[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _workoutLogs.removeAt(index);
                    });
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(workout.exercise),
                      subtitle: Text('Date: ${workout.date.toString().substring(0, 10)}'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WorkoutDetailPage(workout)),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newWorkout = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutInputPage()),
          );

          if (newWorkout != null) {
            setState(() {
              _workoutLogs.add(newWorkout);
              _workoutLogs.sort((a, b) => b.date.compareTo(a.date));
            });
          }
        },
      ),
    );
  }
}

class WorkoutInputPage extends StatefulWidget {
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
        title: Text('Add Workout'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _exerciseController,
                    decoration: InputDecoration(labelText: 'Exercise'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an exercise';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _setsController,
                    decoration: InputDecoration(labelText: 'Sets'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the number of sets';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Set Data:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Add Set'),
                    onPressed: () {
                      setState(() {
                        final sets = int.parse(_setsController.text);
                        _setData = List.generate(sets, (_) => SetData(reps: 0, weight: 0.0));
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Save'),
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

  SetInput({
    required this.setNumber,
    required this.onRepsChanged,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Reps'),
            keyboardType: TextInputType.number,
            onChanged: onRepsChanged,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Weight'),
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

  WorkoutDetailPage(this.workout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Detail'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercise: ${workout.exercise}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8.0),
              Text('Date: ${workout.date.toString().substring(0, 10)}'),
              SizedBox(height: 16.0),
              Text(
                'Sets:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workout.setData.length,
                itemBuilder: (context, index) {
                  final setData = workout.setData[index];
                  return ListTile(
                    title: Text('Set ${index + 1}'),
                    subtitle: Text('Reps: ${setData.reps}, Weight: ${setData.weight}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
