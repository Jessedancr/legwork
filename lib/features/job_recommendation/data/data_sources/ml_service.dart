
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

// class MLService {
//   late Interpreter _interpreter;

//   /// Load the TFLite model
//   Future<void> loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//       debugPrint("TFLite Model Loaded Successfully!");
//     } catch (e) {
//       debugPrint("Error loading model: $e");
//     }
//   }

//   /// Run the model on job features and get predictions
//   Future<List<double>> runModel(List<double> inputFeatures) async {
//     if (_interpreter == null) {
//       debugPrint("Model not loaded!");
//       return [];
//     }

//     // Convert input to the required format
//     var input = [inputFeatures];  // Model expects a batch (2D array)
//     var output = List.filled(1, List.filled(1, 0.0));  // Adjust based on model output shape

//     // Run inference
//     _interpreter.run(input, output);

//     debugPrint("Model Prediction: ${output[0]}");

//     return output[0];  // Return prediction results
//   }

//   /// Close the interpreter when done
//   void closeModel() {
//     _interpreter.close();
//     debugPrint("TFLite Model Closed");
//   }
// }
