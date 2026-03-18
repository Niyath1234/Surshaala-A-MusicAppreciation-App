import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Screens/artist_screen.dart';
import '/Screens/song_screen.dart';
import '/Screens/tanpura_screen.dart';
import '/models/song_model.dart';
import '../widgets/song_card.dart';
import '../models/playist_model.dart';
import '../widgets/playlist_card.dart';
import '../widgets/section_header.dart';
import '../models/mood_model.dart';
import '../widgets/mood_indigo.dart';
import 'package:carousel_slider/carousel_slider.dart';

// RIO PR bot test #2: small edit for second PR
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(text: 'Niyath Nair');
  String _searchQuery = '';
  String _listenerName = 'Niyath Nair';
  String _selectedMoodTitle = Mood.moods.first.title;
  String _actionMessage = 'Use the search and quick actions to explore music.';

  @override
  void initState() {
    showTrivia();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> showTrivia() async {
    await Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (_) => const _PopupMessage(),
        barrierDismissible: true,
      );
    });
  }

  List<Song> _filterSongs(List<Song> songs) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return songs;
    }

    return songs.where((song) {
      return song.title.toLowerCase().contains(query) ||
          song.description.toLowerCase().contains(query) ||
          song.raag.toLowerCase().contains(query) ||
          song.taal.toLowerCase().contains(query);
    }).toList();
  }

  List<Playlist> _filterPlaylists(List<Playlist> playlists) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return playlists;
    }

    return playlists.where((playlist) {
      return playlist.title.toLowerCase().contains(query);
    }).toList();
  }

  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleQuickAction() {
    final name = _listenerName.trim().isEmpty ? 'Listener' : _listenerName.trim();
    final message =
        'Hi $name, your $_selectedMoodTitle is ready. Tap a card to continue.';

    setState(() {
      _actionMessage = message;
    });
    _showActionFeedback(message);
  }

  void _playRandomSong(List<Song> songs) {
    final pool = songs.isEmpty ? Song.songs : songs;
    final song = pool[Random().nextInt(pool.length)];

    setState(() {
      _actionMessage = 'Playing a surprise pick: ${song.title}';
    });
    _showActionFeedback('Opening ${song.title}');
    Get.toNamed('/song', arguments: song);
  }

  @override
  Widget build(BuildContext context) {
    final List<Song> songs = Song.songs;
    final List<Playlist> playlists = Playlist.playlists;
    final List<Mood> moods = Mood.moods;
    final List<Song> filteredSongs = _filterSongs(songs);
    final List<Playlist> filteredPlaylists = _filterPlaylists(playlists);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:Alignment.topCenter,
          end:Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 16, 255, 255).withOpacity(1.0),
            const Color.fromARGB(221, 23, 0, 92).withOpacity(0.8),
          ],
        ),
      ),
          child:Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _CustomAppBar(
          onMenuTap: () {
            _showActionFeedback(
              'Home actions are active. Try searching, choosing a mood, or playing a surprise song.',
            );
          },
        ),
            bottomNavigationBar:const  _CustomNavBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _DiscoverMusic(
                    searchController: _searchController,
                    nameController: _nameController,
                    listenerName: _listenerName,
                    selectedMoodTitle: _selectedMoodTitle,
                    actionMessage: _actionMessage,
                    moods: moods,
                    onSearchChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onNameChanged: (value) {
                      setState(() {
                        _listenerName = value;
                      });
                    },
                    onMoodChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedMoodTitle = value;
                        _actionMessage = 'Selected mood: $value';
                      });
                    },
                    onPrimaryAction: _handleQuickAction,
                    onShuffleAction: () => _playRandomSong(filteredSongs),
                  ),
                  _TrendingMusic(songs: filteredSongs),
                  const SizedBox(height: 14.0),
                  _AfternoonHeat(moods: moods),
                  const SizedBox(height: 6.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SectionHeader(title: 'Playlists'),
                        const SizedBox(height: 20,),
                        filteredPlaylists.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('No playlists match your search yet.'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredPlaylists.length,
                                itemBuilder: ((context,index){
                                  return PlaylistCard(playlist: filteredPlaylists[index]);
                                }
                                )),
                    ],
                    ),
                  )

                ],
              ),
            ),
    ),
    );

  }
}

class _AfternoonHeat extends StatelessWidget{
  const _AfternoonHeat({Key? key,required this.moods}) : super(key: key);
  final List<Mood> moods;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 20.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'How do you Feel?'),
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.10,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              itemBuilder: (context, index) {
                return MoodCard(mood: moods[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
  }
class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key, required this.onMenuTap}) : super(key: key);

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: const Icon(Icons.grid_view_rounded),
      ),
      title: const Text('           SURSHAALA'),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),

          // child: const CircleAvatar(
          //   //backgroundImage: NetworkImage(),
          // ),
        )
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _TrendingMusic extends StatelessWidget{
  const _TrendingMusic({Key? key,required this.songs}) : super(key: key);

  final List<Song> songs;
  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text('No songs found. Try a different search.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.16,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
            ),
            items: songs.map((song) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: 400, // Adjust the width here
                    child: SongCard(song: song),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}

class _CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black45,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_fill_outlined),
              label: 'Play'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_search_rounded),
              label: 'Tanpura')
        ],
        onTap: (int index) {
          if (index == 0) { // Tools button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
          if (index == 1) { // Tools button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SongScreen()),
            );
          }
          if (index == 2) { // Tools button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SongScreen()),
            );
          }
          if (index == 3) { // Tools button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TanpuraScreen()),
            );
          }
          if (index == 4) { // Tools button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArtistListScreen()),
            );
          }
        },

    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _DiscoverMusic extends StatelessWidget implements PreferredSizeWidget {
  const _DiscoverMusic({
    Key? key,
    required this.searchController,
    required this.nameController,
    required this.listenerName,
    required this.selectedMoodTitle,
    required this.actionMessage,
    required this.moods,
    required this.onSearchChanged,
    required this.onNameChanged,
    required this.onMoodChanged,
    required this.onPrimaryAction,
    required this.onShuffleAction,
  }) : super(key: key);

  final TextEditingController searchController;
  final TextEditingController nameController;
  final String listenerName;
  final String selectedMoodTitle;
  final String actionMessage;
  final List<Mood> moods;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String?> onMoodChanged;
  final VoidCallback onPrimaryAction;
  final VoidCallback onShuffleAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1,),
          Text(
            '   Greetings!',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              // Add your desired font size here
              fontSize: 16,
              // Optionally, you can add other styling properties
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4,),
          Text(
            '  ${listenerName.trim().isEmpty ? 'Music Lover' : listenerName}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              // Add your desired font size here
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
          TextFormField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Discover the Collection',
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                // Add your desired font size here
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            onChanged: onNameChanged,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your name',
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedMoodTitle,
            onChanged: onMoodChanged,
            dropdownColor: const Color.fromARGB(255, 23, 0, 92),
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.16),
              labelText: 'Choose a mood',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
            items: moods
                .map(
                  (mood) => DropdownMenuItem<String>(
                    value: mood.title,
                    child: Text(mood.title),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 16, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 23, 0, 92),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: const Text('Submit Action'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onShuffleAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: const Text('Surprise Me'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            actionMessage,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],

      ),
    );

  }
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

String rand_fact = Song.songs[Random().nextInt(Song.songs.length)].trivia;
class _PopupMessage extends StatefulWidget {
  const _PopupMessage({Key? key}) : super(key: key);

  @override
  State<_PopupMessage> createState() => _PopupMessageState();
}

class _PopupMessageState extends State<_PopupMessage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Add a blurred background behind the popup
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Define the popup message box
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 16, 255, 255).withOpacity(1.0),
                  const Color.fromARGB(221, 23, 0, 92).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          // DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Trivia of the Day\n',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,


                              ),
                            ),

                            TextSpan(
                              text: rand_fact,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// Add a close button to the popup
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Return'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


// class SectionHeader extends StatelessWidget with PreferredSizeWidget {
//   const SectionHeader({Key? key,
//   required this.title,this.action='View More'}) : super(key: key);
//   final String title;
//   final String action;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: Theme
//             .of(context)
//             .textTheme
//             .headline6!
//             .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//
//         Text(action, style: Theme
//             .of(context)
//             .textTheme
//             .bodyLarge!
//             .copyWith(color: Colors.white)),
//       ],
//     );
//   }
//   @override
//   Size get preferredSize => const Size.fromHeight(56.0);
// }

// class SongCard extends StatelessWidget {
//   const SongCard({Key? key, required this.songs, required Song song}) : super(key: key);
//
//   final List<Song> songs;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width * 0.45,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//               songs[index].coverUrl,
//           ),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

