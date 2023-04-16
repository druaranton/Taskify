import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import '../providers/friends_provider.dart';
import '/screens/friends_page.dart';
import '/screens/search_page.dart';
import '/screens/profile.dart';
import '/screens/todo_page.dart';
import '/screens/notif_page.dart';
import '../services/local_notification_service.dart';
import 'package:flutter/services.dart';
import 'package:project_aranton/providers/todo_provider.dart';

//fot the homepage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initializePlatformNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> friendsStream = context
        .watch<FriendsListProvider>()
        .friends; //stream is outside of tabs
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        //for the color of the statusbar and navigation buttons
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.brown,
          systemNavigationBarColor: Colors.brown,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
            child: StreamBuilder(
                stream: friendsStream,
                builder: (context, snapshot1) {
                  if (snapshot1.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot1.error}"),
                    );
                  } else if (snapshot1.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot1.hasData) {
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  }
                  return StreamBuilder(
                      stream: todosStream,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasError) {
                          return Center(
                            child:
                                Text("Error encountered! ${snapshot2.error}"),
                          );
                        } else if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot2.hasData) {
                          return const Center(
                            child: Text("No Todos Found"),
                          );
                        }
                        return DefaultTabController(
                          //uses tabs
                          length: 5,
                          child: Scaffold(
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 197, 171),
                              body: NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return <Widget>[
                                    SliverAppBar(
                                      key: const Key("appbar"),
                                      title: const Text('Taskify'),
                                      centerTitle: true,
                                      pinned: true,
                                      floating: true,
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.logout),
                                          onPressed: () {
                                            context
                                                .read<AuthProvider>()
                                                .signOut();
                                            // Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      bottom: const TabBar(
                                        //isScrollable: true,
                                        indicatorColor: Colors.amberAccent,

                                        tabs: [
                                          Tab(
                                              child: Icon(
                                                  Icons.account_box_outlined)),
                                          Tab(
                                              child: Icon(
                                                  Icons.note_alt_outlined)),
                                          Tab(child: Icon(Icons.group)),
                                          Tab(child: Icon(Icons.notifications)),
                                          Tab(child: Icon(Icons.search))
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                body: TabBarView(
                                  children: <Widget>[
                                    Profile(
                                        friendsStream,
                                        snapshot1,
                                        context
                                            .read<AuthProvider>()
                                            .getEmail()),
                                    TodoPage(friendsStream, snapshot1,
                                        todosStream, snapshot2),
                                    FriendsPage(friendsStream,
                                        snapshot1), //page where friend list and friend requests are found
                                    NotificationPage(friendsStream, snapshot1,
                                        todosStream, snapshot2),
                                    SearchPage(friendsStream,
                                        snapshot1), //search users page
                                  ],
                                ),
                              )),
                        );
                      });
                })));
  }
}
