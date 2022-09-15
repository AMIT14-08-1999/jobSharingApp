import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/Widgets/all_companies_widget.dart';
import 'package:fiverr/Widgets/bottom_nav_bar.dart';
import "package:flutter/material.dart";

class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({Key? key}) : super(key: key);

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "Search Query";
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autocorrect: true,
      decoration: const InputDecoration(
          hintText: "Search for companies..",
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
          bottomNavigationBar: BottomNavigationBarApp(indexNum: 1),
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
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("name", isGreaterThanOrEqualTo: searchQuery)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data?.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AllWorkersWidget(
                          userId: snapshot.data!.docs[index]["id"],
                          userName: snapshot.data!.docs[index]["name"],
                          userEmail: snapshot.data!.docs[index]["email"],
                          phoneNumber: snapshot.data!.docs[index]
                              ["phoneNumber"],
                          userImage: snapshot.data!.docs[index]["userImage"],
                        );
                      });
                } else {
                  return const Center(
                    child: Text(
                      "There is no users",
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
          )),
    );
  }
}
