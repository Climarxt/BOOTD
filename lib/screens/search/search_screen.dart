import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';
import '../../widgets/widgets.dart';
import '../events_screens/events.dart';
import '../screens.dart';
import 'cubit/search_cubit.dart';

class SwipeScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SwipeScreen();

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: mobileBackgroundColor,
          iconTheme: const IconThemeData(
            color: black,
          ),
          elevation: 3,
          leading: IconButton(
            icon: const Icon(
              Icons.calendar_month_sharp,
              color: black,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => EventCalendarScreen(),
                settings:
                    const RouteSettings(name: EventCalendarScreen.routeName),
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              case SearchStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 22.0,
                              radiusbackground: 23,
                              profileImageUrl: user.profileImageUrl,
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(userId: user.id),
                            ),
                          );
                        },
                      )
                    : CenteredText(text: 'No users found');
              default:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: [
                              Container(
                                width: size.width,
                                height: 440,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/app4-f4c8e.appspot.com/o/posts%2FH839Mz01JThiLqhQuSGBBMniHS62%2F6f482ce0-78dd-11ed-9d27-67e9d8d5eaf7?alt=media&token=a1121de9-7f17-4169-b893-30845c6076e9'),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("NomUtilisateur",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: white,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: const [
                                          Text("Détails",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: [
                              Container(
                                width: size.width,
                                height: 440,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/app4-f4c8e.appspot.com/o/posts%2F0oCc5CXo49cDqXfMCQPmIdpMehX2%2F4a4f1410-78df-11ed-9ffc-07af88105822?alt=media&token=bc6cdf5a-09a2-4b69-a18c-2845769c46cd'),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("NomUtilisateur",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: white,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: const [
                                          Text("Détails",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
