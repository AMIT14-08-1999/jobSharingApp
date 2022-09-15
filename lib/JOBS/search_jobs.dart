import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/JOBS/jobs_screen.dart';
import 'package:fiverr/Widgets/job_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "Search Query";
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autocorrect: true,
      decoration: const InputDecoration(
          hintText: "Search for jobs..",
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white,
          )),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      onChanged: (query) => updteSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          _clearSearchQuery();
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updteSearchQuery('');
    });
  }

  void updteSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _buildSearchField(),
          actions: _buildActions(),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.redAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9],
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => JobScreen()));
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("jobTitle", isGreaterThanOrEqualTo: searchQuery)
              .where("recruitment", isEqualTo: true)
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
                        recruitment: snapshot.data?.docs[index]["recruitment"],
                        email: snapshot.data?.docs[index]["email"],
                        location: snapshot.data?.docs[index]["location"],
                      );
                    });
              } else {
                return const Center(
                  child: Text(
                    "There is no jobs",
                  ),
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
