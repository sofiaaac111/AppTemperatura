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
        // Emulación de variación de temperatura
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Temperatura actual
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
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
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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

          // Lista de registros
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  leading: const Icon(Icons.thermostat),
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