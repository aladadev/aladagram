import 'package:aladagram/screens/profile_screen.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
        setState(() {
          isShowUser = false;
          searchController.clear();
        });
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for user',
            ),
            onFieldSubmitted: (value) {
              setState(() {
                isShowUser = true;
              });
            },
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: snapshot.data!.docs[index]['uid'],
                                ),
                              ));
                        }),
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]['username']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['photoUrl'],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 20,
                    itemBuilder: (context, index) {
                      return Image.network(
                          snapshot.data!.docs[index]['postUrl']);
                    },
                  );
                },
              ),
      ),
    );
  }
}
