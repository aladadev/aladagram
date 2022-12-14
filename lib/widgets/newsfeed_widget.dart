import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/resources/firestore_method.dart';
import 'package:aladagram/screens/comment_screen.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:aladagram/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsFeed extends StatefulWidget {
  final snapshotdata;
  const NewsFeed({Key? key, required this.snapshotdata}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  int commentNum = 0;
  bool isLikeAnimating = false;
  bool smallLikeAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentsNum();
  }

  void getCommentsNum() async {
    try {
      var snapComment = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshotdata['postId'])
          .collection('comments')
          .get();
      commentNum = snapComment.docs.length;

      setState(() {});
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _devicewidth = MediaQuery.of(context).size.width;
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      color: mobileBackgroundColor,
      child: Column(
        children: [
          //Username avatar and more options
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snapshotdata['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      '${widget.snapshotdata['username']}',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    await FireStoreMethods().deletePost(
                                        widget.snapshotdata['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 16,
                                    ),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert_outlined,
                  ),
                ),
              ],
            ),
          ),
          // post photo showdown
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FireStoreMethods().likePost(
                widget.snapshotdata['postId'],
                user.uid,
                widget.snapshotdata['likes'],
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snapshotdata['postUrl'],
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(
                    microseconds: 500,
                  ),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snapshotdata['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      widget.snapshotdata['postId'],
                      user.uid,
                      widget.snapshotdata['likes'],
                    );
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.snapshotdata['likes'].contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_rounded,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_add_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snapshotdata['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snapshotdata['username'],
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: '  ${widget.snapshotdata['description']}',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return CommentScreen(
                          snapData: widget.snapshotdata,
                        );
                      },
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: Text('View all $commentNum comments!'),
                    // child: StreamBuilder(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('posts')
                    //         .doc(widget.snapshotdata['postId'])
                    //         .collection('comments')
                    //         .snapshots(),
                    //     builder: (context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return const Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       return Text(
                    //         'View all ${snapshot.data!.docs.length} comments',
                    //         style: const TextStyle(
                    //           fontSize: 14,
                    //           color: secondaryColor,
                    //         ),
                    //       );
                    //     }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snapshotdata['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
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
