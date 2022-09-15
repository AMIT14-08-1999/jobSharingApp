import 'package:fiverr/Search/profile_company.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImage;

  const AllWorkersWidget(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.phoneNumber,
      required this.userImage})
      : super(key: key);

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  void _mailTo() async {
    var mailUrl = "mailto:${widget.userEmail}";
    if (await canLaunchUrlString(mailUrl)) {
      await launchUrlString(mailUrl);
    } else {
      throw "Error Occured";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.userId)));
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
              // ignore: prefer_if_null_operators, unnecessary_null_comparison
              widget.userImage == null
                  ? "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png"
                  : widget.userImage,
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Visit Profile,",
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.mail,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            _mailTo();
          },
        ),
      ),
    );
  }
}
