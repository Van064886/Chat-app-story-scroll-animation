import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegram_story_scroll_animation/models/user.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapsed = false;

  // List of profile picture urls
  List<String> images = [
    'https://th.bing.com/th/id/OIG.MxQxUggA0RKmKdTjwAqw',
    'https://www.referenseo.com/wp-content/uploads/2019/03/image-attractive-960x540.jpg',
    'https://imgupscaler.com/images/samples/animal-after.webp',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1529148266338-1a3f1f4ec096?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1483',
    'https://plus.unsplash.com/premium_photo-1683121366070-5ceb7e007a97?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://t4.ftcdn.net/jpg/06/28/04/87/360_F_628048704_BIm31smMFDYYFCGItT45pS2agYStYZmm.jpg'
  ];

  // List of users
  List<User> _users = [];

  // List of all users stories
  List<Widget> _allStories = [];

  // Shortened user story widget
  late Widget _shortenedUserStories;

  // List of all messages
  List<Widget> _messages = [];

  @override
  void initState() {
    super.initState();

    // Init the scrollcontroller to handle scroll actions
    _scrollController.addListener(() {
      setState(() {
        _isAppBarCollapsed = _scrollController.offset >= 60;
      });
    });

    // Initialize needed values
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _users = List.generate(50, (index) {
          return User(
              id: index,
              username: Faker().person.name(),
              picture: images[Random().nextInt(images.length)]);
        });
        
        _allStories = generateUsersStories();
        _shortenedUserStories = generateShortenedUserStories();
        _messages = generateMessages();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  title: _isAppBarCollapsed == false
                      ? const Text(
                          'Chats',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        )
                      : null,
                  expandedHeight: 170.0,
                  leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black,
                        )),
                  ],
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 3),
                    background: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                    centerTitle: _isAppBarCollapsed ? true : false,
                    title: SizedBox(
                      height: _isAppBarCollapsed ? 44 : 65,
                      width: _isAppBarCollapsed
                          ? MediaQuery.of(context).size.width * .4
                          : MediaQuery.of(context).size.width,
                      child: _isAppBarCollapsed
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _shortenedUserStories,
                                const SizedBox(
                                  width: 4,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Chats',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: _allStories),
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Messages',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(children: _messages),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  // Generate users stories
  List<Widget> generateUsersStories() {
    return _users.map((user) {
      return Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: const Color.fromARGB(255, 73, 72, 72),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.picture!),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  user.username!,
                  style: const TextStyle(fontSize: 8, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      );
    }).toList();
  }

  // Generate shortened user stories
  Widget generateShortenedUserStories() {
    return SizedBox(
      width: 23 * 4,
      child: Stack(
          children: _users.sublist(0, 3).map(
        (user) {
          return Positioned(
            left: user.id! * 23,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: const Color.fromARGB(255, 73, 72, 72),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(user.picture!),
                ),
              ),
            ),
          );
        },
      ).toList()),
    );
  }

  // Generate a list of messages
  List<Widget> generateMessages() {
    return List.generate(100, (index) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .2,
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(images[Random().nextInt(images.length)]),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          Faker().person.name(),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          [
                            'Sat Jun 24 2023',
                            'Tue Dec 12 2023'
                          ][Random().nextInt(1)],
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    Faker().lorem.sentence(),
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
