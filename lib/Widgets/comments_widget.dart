import 'package:fiverr/Search/profile_company.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {Key? key,
      required this.commentId,
      required this.commnterId,
      required this.commenterName,
      required this.commentBody,
      required this.commenterImageUrl})
      : super(key: key);
  final String commentId;
  final String commnterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepOrange,
  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => ProfileScreen(userId: widget.commnterId),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: _colors[1],
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.commenterImageUrl),
                fit: BoxFit.fill,
              ),
            ),
          )),
          const SizedBox(width: 6),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.commenterName,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.commentBody,
                  maxLines: 5,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.tealAccent,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
