import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/JOBS/jobs_screen.dart';
import 'package:fiverr/JOBS/search_jobs.dart';
import 'package:fiverr/JOBS/upload_job.dart';
import 'package:fiverr/Search/profile_company.dart';
import 'package:fiverr/Search/search_companies.dart';
import 'package:fiverr/user_state.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarApp({Key? key, required this.indexNum}) : super(key: key);
  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Row(
            children: const [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  )),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            "Do you want to Log Out ?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => USerState(),
                  ),
                );
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: indexNum,
      items: const [
        Icon(Icons.list, size: 19, color: Colors.black),
        Icon(Icons.search, size: 19, color: Colors.black),
        Icon(Icons.add, size: 19, color: Colors.black),
        Icon(Icons.person_pin, size: 19, color: Colors.black),
        Icon(Icons.exit_to_app, size: 19, color: Colors.black),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AllWorkersScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadJobNow()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        userId: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
