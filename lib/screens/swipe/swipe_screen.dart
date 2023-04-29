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

  const SwipeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isSearching = false;

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
        appBar: _buildAppBar(context),
        body: _buildBody(context, size),
      ),
    );
  }

  // Création d'une fonction pour la barre d'applications
  AppBar _buildAppBar(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(color: black),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () {
            setState(() {
              _isSearching = false;
            });
            context.read<SearchCubit>().resetSearch();
          },
        ),
        title: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Search for a user',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            context.read<SearchCubit>().searchUsers(value);
          },
        ),
      );
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(color: black),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.calendar_month_sharp, color: black, size: 30),
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => EventCalendarScreen(),
              settings:
                  const RouteSettings(name: EventCalendarScreen.routeName),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: black,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          )
        ],
      );
    }
  }

  // Création d'une fonction pour le corps
  Widget _buildBody(BuildContext context, Size size) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStatus.error:
            return CenteredText(text: state.failure.message);
          case SearchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case SearchStatus.loaded:
            return _buildLoadedState(context, state);
          default:
            return _buildDefaultState(size);
        }
      },
    );
  }

  // Création d'une fonction pour le cas où les données sont chargées
  Widget _buildLoadedState(BuildContext context, SearchState state) {
    return state.users.isNotEmpty
        ? ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = state.users[index];
              return ListTile(
                leading: UserProfileImage(
                  radius: 22.0,
                  outerCircleRadius: 23,
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
  }

  // Création d'une fonction pour l'état par défaut
  Widget _buildDefaultState(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPost(size,
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_e5af98f9-7adb-478f-8a18-71d897d3e68b.jpg?alt=media&token=ace3779f-cc7d-4f0f-a23c-35719ab4c3d2'),
            Divider(),
            _buildPost(size,
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_4def9ea3-d748-41c4-9a4d-5e042e386616.jpg?alt=media&token=433cc76c-6c47-4218-aad1-e5ebf63a943e'),
          ],
        ),
      ),
    );
  }

  // Création d'une fonction pour construire chaque post
  Widget _buildPost(Size size, String imageUrl) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "NomUtilisateur",
                      style: TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Détails",
                      style: TextStyle(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
