import 'package:flutter/material.dart';
import 'package:legwork/Features/job_recommendation/data/data_sources/ml_service.dart';

class DancerHomeScreen extends StatefulWidget {
  const DancerHomeScreen({super.key});

  @override
  State<DancerHomeScreen> createState() => _DancerHomeScreenState();
}

class _DancerHomeScreenState extends State<DancerHomeScreen> {
  final MLService _mlService = MLService();
  List<double> predictions = [];

  @override
  void initState() {
    super.initState();
    _mlService.loadModel();
  }

  void predictJob() async {
    List<double> jobFeatures = [0, 1, 50000]; // Example: Hip-Hop, Lagos, 50k
    List<double> result = await _mlService.runModel(jobFeatures);

    setState(() {
      predictions = result;
    });
  }

  @override
  void dispose() {
    _mlService.closeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(' Dancer Home screen'),
          const SizedBox(height: 25),
          Text(
              "Predictions: ${predictions.isNotEmpty ? predictions.toString() : 'Press Button'}"),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: predictJob,
            child: const Text("Get Recommendations"),
          ),
        ],
      ),
    );
  }
}
