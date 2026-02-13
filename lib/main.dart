import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureApp());
}

class TemperatureApp extends StatelessWidget {
  const TemperatureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensor de Temperatura',
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
  double _currentTemperature = 25.0;
  final Random _random = Random();
  Timer? _timer;

  final List<TemperatureRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _startSensor();
  }

  void _startSensor() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        double variation = (_random.nextDouble() * 4) - 2;
        _currentTemperature += variation;

        _records.insert(
          0,
          TemperatureRecord(
            value: _currentTemperature,
            time: DateTime.now(),
          ),
        );
      });
    });
  }

  Color _getBackgroundColor() {
    if (_currentTemperature < 20) {
      return Colors.green.shade200;
    } else if (_currentTemperature < 30) {
      return Colors.yellow.shade200;
    } else {
      return Colors.red.shade200;
    }
  }

  Color _getTextColor() {
    if (_currentTemperature < 20) {
      return Colors.green.shade800;
    } else if (_currentTemperature < 30) {
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
        title: const Text('Registro de Temperatura'),
        centerTitle: true,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        color: _getBackgroundColor(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Tarjeta de temperatura actual
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Temperatura Actual',
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

            // Historial
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

// Modelo para guardar registros
class TemperatureRecord {
  final double value;
  final DateTime time;

  TemperatureRecord({
    required this.value,
    required this.time,
  });
}