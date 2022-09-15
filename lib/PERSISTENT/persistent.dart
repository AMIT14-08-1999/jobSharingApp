import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/SERVICES/global_variables.dart';

class Persistent {
  static List<String> jobCategoryList = [
    "Architecture & Engineering",
    "Arts & Design",
    "Business & Management",
    "Development-Programming",
    "Education & Teaching",
    "Information Technology",
    "Human Resources",
    "Marketing & Sales",
    "Accounting & Finance",
    "Healthcare & Medicine",
    "Law & Legal",
    "Science & Mathematics",
    "Social Sciences",
    "Writing & Translation",
  ];
  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name = userDoc.get("name");
    userImage = userDoc.get("userImage");
    location = userDoc.get("location");
  }
}
