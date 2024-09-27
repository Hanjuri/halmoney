import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _jobsRec = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get jobs => _jobsRec;

  bool get isLoading => _isLoading;

  Future<void> fetchJobs() async {
    print("Fetching jobs...");
    try {
      QuerySnapshot snapshot = await _firestore.collection('jobs_recommendation').get();
      print("Jobs fetched from Firestore: ${snapshot.docs.length}");

      _jobsRec = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          'num': data['num'] ?? 'Unknown',
          'title': data['title'] ?? 'Untitled Job',
          // Use null-aware operators and casting checks
          'address': data['address'] != null ? data['address'] as String : 'No address provided',
          'wage': data['wage'] != null ? data['wage'] as String : 'Unknown',
          'career': data['career'] != null ? data['career'] as String : 'Not specified',
          'detail': data['detail'] != null ? data['detail'] as String : 'No details provided',
          'workweek': data['work_time_week'] != null ? data['work_time_week'] as String : 'Not specified',
          'image_path': data['image_path'] != null ? data['image_path'] as String : 'No image available',
          'isLiked': data['isLiked'] ?? false,
          'end_day': data['end_day'] != null && data['end_day'] is Timestamp
              ? (data['end_day'] as Timestamp).toDate().toString()
              : 'No end date provided',  // Handle missing or invalid 'end_day'
          'manager_call': data['manager_call'] != null ? data['manager_call'] as String : 'Unknown'
        };
      }).toList();


      //print("Job list: $_jobsRec");

      _isLoading = false;
      notifyListeners();  // Notify that jobs are loaded
    } catch (e) {
      print("Failed to fetch jobs from Firestore: $e");  // Log any errors
      _isLoading = false;
      notifyListeners();
    }
  }

}

