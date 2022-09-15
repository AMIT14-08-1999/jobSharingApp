import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/Widgets/bottom_nav_bar.dart';
import 'package:fiverr/user_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String email = "";
  String phoneNumber = "";
  String imageUrl = "";
  String joinedAt = "";
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading == true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get("name");
          email = userDoc.get("email");
          phoneNumber = userDoc.get("phoneNumber");
          imageUrl = userDoc.get("userImage");
          Timestamp joinedTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (e) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Widget userInfo({required IconData iconData, required String content}) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        )
      ],
    );
  }

  Widget _contactBy({
    required Color color,
    required Function fct,
    required IconData icon,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = "https://wa.me/$phoneNumber?text=HelloWorld";
    launchUrlString(url);
  }

  void _mailTo() async {
    final Uri params = Uri(
        scheme: "mailto",
        path: email,
        query:
            'subject=Write subject here,Please&body=Hello, Please write details,');
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async {
    var url = "tel://$phoneNumber";
    launchUrlString(url);
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
        bottomNavigationBar: BottomNavigationBarApp(indexNum: 3),
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white10,
                          margin: const EdgeInsets.all(30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 100),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    name == null ? "Name Here" : name!,
                                    style: const TextStyle(
                                        color: Colors.cyan, fontSize: 24),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 15),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Accounts Information: ",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      iconData: Icons.email_outlined,
                                      content: email),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      iconData: Icons.phone_android,
                                      content: phoneNumber),
                                ),
                                const SizedBox(height: 30),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 30),
                                _isSameUser
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _contactBy(
                                            color: Colors.green,
                                            fct: () {
                                              _openWhatsAppChat();
                                            },
                                            icon: FontAwesome.whatsapp,
                                          ),
                                          _contactBy(
                                            color: Colors.red,
                                            fct: () {
                                              _mailTo();
                                            },
                                            icon: FontAwesome.mail,
                                          ),
                                          _contactBy(
                                            color: Colors.blueGrey,
                                            fct: () {
                                              _callPhoneNumber();
                                            },
                                            icon: FontAwesome.phone,
                                          ),
                                        ],
                                      ),
                                !_isSameUser
                                    ? Container()
                                    : Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: MaterialButton(
                                            onPressed: () {
                                              _auth.signOut();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          USerState()));
                                            },
                                            color: Colors.black,
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "Logout",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.logout_sharp,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.26,
                              height: size.width * 0.26,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 8,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                    imageUrl == null
                                        ? "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png"
                                        : imageUrl,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
