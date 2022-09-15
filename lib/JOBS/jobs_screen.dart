import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/JOBS/search_jobs.dart';
import 'package:fiverr/PERSISTENT/persistent.dart';
import 'package:fiverr/Widgets/bottom_nav_bar.dart';
import 'package:fiverr/Widgets/job_widget.dart';
import 'package:flutter/material.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (
        ctx,
      ) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Job Category",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.purple,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  jobCategoryFilter = null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "Cancel Filter",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    Persistent persistent = Persistent();
    persistent.getMyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.redAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Job Screen"),
          backgroundColor: const Color.fromARGB(49, 94, 1, 65),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              _showTaskCategoriesDialog(
                size: size,
              );
            },
            icon: const Icon(
              Icons.filter_list_outlined,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (c) => SearchPage()));
                },
                icon: const Icon(
                  Icons.search_sharp,
                  color: Colors.greenAccent,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("jobCategory", isEqualTo: jobCategoryFilter)
              .where("recruitment", isEqualTo: true)
              .orderBy("createdAt", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return JobWidget(
                          jobTitle: snapshot.data?.docs[index]["jobTitle"],
                          jobDescription: snapshot.data?.docs[index]
                              ["jobDescription"],
                          jobId: snapshot.data?.docs[index]["jobId"],
                          uploadedBy: snapshot.data?.docs[index]["uploadedBy"],
                          userImage: snapshot.data?.docs[index]["userImage"],
                          name: snapshot.data?.docs[index]["name"],
                          recruitment: snapshot.data?.docs[index]
                              ["recruitment"],
                          email: snapshot.data?.docs[index]["email"],
                          location: snapshot.data?.docs[index]["location"]);
                    });
              } else {
                return const Center(
                  child: Text("There is no jobs "),
                );
              }
            }
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
