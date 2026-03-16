import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '/Screens/artist_screen.dart';
import '/Screens/song_screen.dart';
import '/Screens/tanpura_screen.dart';
import '/models/song_model.dart';
import '../widgets/song_card.dart';
import '../models/playist_model.dart';
import '../widgets/playlist_card.dart';
import '../widgets/section_header.dart';
import '../models/artist_model.dart';
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
  /// REST path for catalog fetch (GET). Used by [fetchSongsFromApi].
  static const String _apiSongsPath = '/api/v1/songs';
  /// REST path for playlists (GET). Used by [fetchPlaylistsFromApi].
  static const String _apiPlaylistsPath = '/api/v1/playlists';
  /// REST path for moods (GET). Used by [fetchMoodsFromApi].
  static const String _apiMoodsPath = '/api/v1/moods';
  /// REST path for artists (GET). Used by [fetchArtistsFromApi].
  static const String _apiArtistsPath = '/api/v1/artists';

  @override
  void initState() {
    // TODO: implement initState
    showTrivia();
    super.initState();
  }


  Future<List<Song>> fetchSongsFromApi() async {
    return Song.songs;
  }

  /// Fetches playlists from backend. Mirrors GET _apiPlaylistsPath; currently
  /// returns in-memory list until API is wired.
  Future<List<Playlist>> fetchPlaylistsFromApi() async {
    // TODO: http.get(Uri.parse('$baseUrl$_apiPlaylistsPath'))
    return Playlist.playlists;
  }

  /// Fetches moods from backend. Mirrors GET _apiMoodsPath; currently
  /// returns in-memory list until API is wired.
  Future<List<Mood>> fetchMoodsFromApi() async {
    // TODO: http.get(Uri.parse('$baseUrl$_apiMoodsPath'))
    return Mood.moods;
  }

  /// Fetches artists from backend. Mirrors GET _apiArtistsPath; currently
  /// returns in-memory list until API is wired.
  Future<List<Artist>> fetchArtistsFromApi() async {
    // TODO: http.get(Uri.parse('$baseUrl$_apiArtistsPath'))
    return Artist.artists;
  }

  Future<void> showTrivia() async{
    await Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (_) => const _PopupMessage(),
        barrierDismissible: true,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    // Currently using in-memory data only. No backend call here — adding a
    // fetch (e.g. for catalog, user playlists, or recommendations) would
    List<Song> songs = Song.songs;
    List<Playlist> playlists= Playlist.playlists;
    List<Mood> moods=Mood.moods;

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
        appBar: const _CustomAppBar(),
            bottomNavigationBar:const  _CustomNavBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const _DiscoverMusic(),
                  _TrendingMusic(songs: songs),
                  const SizedBox(height: 14.0),
                  _AfternoonHeat(moods: moods),
                  const SizedBox(height: 6.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SectionHeader(title: 'Playlists'),
                        const SizedBox(height: 20,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                            itemBuilder: ((context,index){
                              return PlaylistCard(playlist: playlists[index]);
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
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),title: Text('           SURSHAALA'),
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
  const _DiscoverMusic({Key? key}) : super(key: key);

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
            '  Niyath Nair',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              // Add your desired font size here
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
          TextFormField(
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
          )
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

