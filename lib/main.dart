import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(const TemperatureApp());
}

class TemperatureApp extends StatelessWidget {
  const TemperatureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensor de Temperatura REAL',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TemperatureHome(),
    );
  }
}

class TemperatureHome extends StatefulWidget {
  const TemperatureHome({super.key});

  @override
  State<TemperatureHome> createState() => _TemperatureHomeState();
}

class _TemperatureHomeState extends State<TemperatureHome> {
  final Battery _battery = Battery();
  Timer? _timer;

  double _currentTemperature = 0.0;
  final List<TemperatureRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _startReadingRealTemperature();
  }

  void _startReadingRealTemperature() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        // Temperatura real de la batería en décimas de grado
        final temp = await _battery.temperature;

        setState(() {
          _currentTemperature = temp;

          _records.insert(
            0,
            TemperatureRecord(
              value: _currentTemperature,
              time: DateTime.now(),
            ),
          );
        });
      } catch (e) {
        print("Error leyendo temperatura: $e");
      }
    });
  }

  Color _getBackgroundColor() {
    if (_currentTemperature < 30) {
      return Colors.green.shade200;
    } else if (_currentTemperature < 40) {
      return Colors.yellow.shade200;
    } else {
      return Colors.red.shade200;
    }
  }

  Color _getTextColor() {
    if (_currentTemperature < 30) {
      return Colors.green.shade800;
    } else if (_currentTemperature < 40) {
      return Colors.orange.shade800;
    } else {
      return Colors.red.shade800;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperatura REAL del Dispositivo'),
        centerTitle: true,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        color: _getBackgroundColor(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Temperatura de la Batería',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_currentTemperature.toStringAsFixed(1)} °C',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            const Text(
              'Historial de Mediciones',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return ListTile(
                    leading: Icon(
                      Icons.thermostat,
                      color: _getTextColor(),
                    ),
                    title: Text(
                      '${record.value.toStringAsFixed(1)} °C',
                    ),
                    subtitle: Text(
                      record.time.toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Battery {
  Future? get temperature => null;
}

class TemperatureRecord {
  final double value;
  final DateTime time;

  TemperatureRecord({
    required this.value,
    required this.time,
  });
}
