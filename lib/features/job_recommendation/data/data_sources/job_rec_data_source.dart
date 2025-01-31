import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/data_sources/home_remote_data_source.dart';
import 'package:tflite/tflite.dart';

class JobRecService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final jobService = JobService();

  /// GET DANCER'S PREFS FROM FIRESTORE
  Future<List<dynamic>> getDancerPrefs() async {
    try {
      // Get uid of currently logged in user
      final user = auth.currentUser;
      String uid = user!.uid;

      // Fetch the dancer's doc from firestore
      final dancerDoc = await db.collection('dancers').doc(uid).get();

      List<dynamic> danceStyles = dancerDoc['danceStyles'] ?? [];
      Map<String, dynamic> jobPrefs = dancerDoc['jobPrefs'] ?? {};
      return [danceStyles, jobPrefs];
    } on FirebaseException catch (e) {
      debugPrint('Error fetching dancers prefs: ${e.code}');
      return [];
    } catch (e) {
      debugPrint('Unknown error while fetching dancers prefs: $e');
      return [];
    }
  }

  /**
   * THE FOLLOWING MAPPING FUNCTIONS CONVERT JOB FEATURES INTO NUMERICAL VALUES
   */
  Map<String, int> styleMapping = {
    'hiphop': 0,
    'afro': 1,
    'contemporary': 2,
    'krump': 3,
    'commercial': 4,
    'animation': 5,
    'popping': 6,
    'waacking': 7,
    'locking': 8,
    'dancehall': 9,
    'salsa': 10,
    'ballet': 11,
    'traditional': 12,
  };

  Map<String, int> locationMapping = {
    'Agege': 1,
    'Ajeromi-Ifelodun': 2,
    'Alimosho': 3,
    'Apapa': 4,
    'Amuwo-Odofin': 5,
    'Badagry': 6,
    'Epe': 7,
    'Eit-osa': 8,
    'Ibeju-Lekki': 9,
    'Ifako-Ijaiye': 10,
    'Ifako-Gbagada': 11,
    'Ikeja': 12,
    'Ikorodu': 13,
    'Kosofe': 14,
    'Lagos Island': 15,
    'Lagos Mainland': 16,
    'Mushin': 17,
    'Ojo': 18,
    'Oshodi-isolo': 19,
    'Somolu': 20,
    'Surulere': 21,
    'Bariga': 22,
    'Ejigbo': 23,
    "Egbeda": 24,
    'Ikoyi-Obalende': 25,
    'Onigbongbo': 26,
    "yaba": 27,
    'Lekki': 28,
  };

  /// CONVERT JOBS TO NUMERICAL FEATURES
  List<int> convertJobToFeatures(Map<String, dynamic> job) {
    // Convert Job features to numerical value, default to -1 if not found
    return [
      styleMapping[job['danceStyle']] ?? -1, // danceStyle
      locationMapping[job['jobLocation']] ?? -1, // Location
      int.parse(job['pay']), // pay
    ];
  }

  /// USE THE MAPPING FUNCTIONS TO CONVERT THE PREPARED DATA INTO A NUMERICAL FORMAT
  List<List<int>> preparedJobFeatures(List<Map<String, dynamic>> jobs) {
    return jobs.map((job) => convertJobToFeatures(job)).toList();
  }

  /// CONVERT INPUT FEATURES TO BINARY FORMAT FOR TFLITE
  Uint8List convertToBinary(List<double> input) {
    // Flatten the input and normalize values if needed (depends on model requirements)
    // Assuming no normalization is needed here; adjust as required
    var buffer = ByteData(input.length * 4);
    for (int i = 0; i < input.length; i++) {
      buffer.setFloat32(i * 4, input[i], Endian.little);
    }
    return buffer.buffer.asUint8List();
  }

  /// PASS FETCHED JOBS AND DANCER PREFS TO ML MODEL
  Future<List<Map<String, dynamic>>> recommendJobs(
      List<Map<String, dynamic>> jobs, List<dynamic> dancerPrefs) async {
    List<Map<String, dynamic>> recommendedJobs = [];

    for (int i = 0; i < jobs.length; i++) {
      if (dancerPrefs[i][0]['confidence'] > 0.5) {
        // Example confidence threshold
        recommendedJobs.add(jobs[i]);
      }
    }
    return recommendedJobs;
    // // For simplicity, let's say the ML model compares dancer preferences to job data
    // List<Map<String, dynamic>> recommendedJobs = [];

    // // Checking if the job matches the dancers prefs
    // for (var job in jobs) {
    //   int score = 0;
    //   // Check if any of the dance styles in dancer's profile matches any of the dance styles on the job
    //   for (var style in dancerPrefs) {
    //     if (job['prefDanceStyles'].contains(style)) {
    //       score += 10;
    //     }
    //   }
    //   // Do the same for location
    //   for (var location in dancerPrefs) {
    //     if (job['prefLocation'].contains(location)) {
    //       score += 3;
    //     }
    //   }
    //   if (job['pay'] >= dancerPrefs[2]) {
    //     score += 5;
    //   }

    //   // If score is high recommend job to user
    //   if (score > 8) {
    //     recommendedJobs.add(job);
    //   }
    // }
    // debugPrint("Recommended jobs: $recommendedJobs");
    // return recommendedJobs;
  }

  /// GET RECOMMENDED JOBS
  Future<void> getRecommendedJobs() async {
    try {
      // 1: fetch jobs and dancerprefs
      final jobs = await jobService.getJobs();
      final dancerPrefs = await getDancerPrefs();

      // 2: convert jobs to numerical features
      List<List<int>> jobFeatures = preparedJobFeatures(jobs);

      // 3: Pass to the ML model
      List<dynamic> predictions = await runModel(jobFeatures);

      // 4: Filter recommendedjobs based on predictions
      Future<List<Map<String, dynamic>>> recommendedJobs =
          recommendJobs(jobs, predictions);

      // 5: Display recommended jobs
      debugPrint("Recommended Jobs: $recommendedJobs");

      debugPrint("Final recommended jobs: $recommendedJobs");
    } on FirebaseException catch (e) {
      debugPrint('Error getting recommended job: ${e.code}');
      return;
    } catch (e) {
      debugPrint('Unknown error while getting recommended job: $e');
      return;
    }
  }

  /// THE BELOW METHOD PROCESSES THE JOB FEATURES DATA,
  /// PASSES IT TO THE TFLITE MODEL AND RETURNS PREDICTIONS
  Future<List<dynamic>> runModel(List<List<int>> jobFeatures) async {
    // 1: Load the TFlite model
    await Tflite.loadModel(
      model: 'assets/model.tflite', // path to model
      numThreads: 1, // number of threads to use
      isAsset: true, // indicates the model is in the assets folder
    );
    List<dynamic> predictions = [];

    // 2: process each job feature set
    for (var features in jobFeatures) {
      // Convert the features into a format suitable for the model
      var input = features
          .map((e) => e.toDouble())
          .toList(); // Ensure features are double

      var result = await Tflite.runModelOnBinary(
        binary: convertToBinary(input), // Convert input to binary format
        numResults: 5, // Number of top results to return
        threshold: 0.5, // confidence threshold
      );
      predictions.add(result);
    }
    await Tflite.close();
    return predictions;
  }

  /// PREPARE DATA BY EXTRACTING AND FORMATTING IT INTO A COMPATIBLE FORMAT
  List<List<dynamic>> prepareData(List<Map<String, dynamic>> jobs) {
    return jobs.map((job) {
      return [
        styleMapping[job['prefDanceStyles']] ?? -1,
        locationMapping[job['jobLocation']] ?? -1, // Location
        int.parse(job['pay']),
      ];
    }).toList();
    // List<List<dynamic>> processedJobs = [];

    // for (var job in jobs) {
    //   // convert each job into a list of features

    //   processedJobs.addAll([
    //     job['prefDanceStyles'], // numerical ID for style
    //     job['jobLocation'], // Numerical ID for job location
    //     job['pay'], // numerical ID for job pay
    //   ]);
    // }

    // return processedJobs;
  }
}
