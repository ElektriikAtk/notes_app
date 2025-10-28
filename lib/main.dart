import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyNote extends StatefulWidget {
  const MyNote({super.key});
  @override
  State<MyNote> createState() => _MyNoteState();
}

  class Note{
    Note({ required this.width, required this.height, required this.color});
    double width;
    double height;
    Color color;
  }

  class _MyNoteState extends State<MyNote> {
    var text = 'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.';  
    var noteList = <Note>[];

  @override
    Widget build(BuildContext context) {

    
void createNote() {
  noteList.add(
    Note(width: 75, height: 75, color: Colors.red)
  );
}

    Widget gridBody = noteList.isNotEmpty
        ? 
        Stack(
          children: [
/*             GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(12),
              children: [   */                
                for (var note in noteList) 
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    width: note.width,
                    height: note.height,
                    color: note.color,
                    margin: EdgeInsets.all(10),
                    child:
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            note.width *= 4;
                            note.height *= 4;
                            note.color = Colors.green;
                          });
                        },
                        child: Text((noteList.indexOf(note).toString())),
                      ),                  
/*                   ),
              ], */
            )
          ],
          )
        : const Center(child: Text('No notes yet'));


      return Scaffold(
        body: gridBody,
        floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              setState(() {
                createNote();
              });
            },
            foregroundColor: Theme.of(context).colorScheme.surface,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );  
    }
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MyNote();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: false,//constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

/* class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final Widget body = appState.noteList.isNotEmpty
    ?
      GridView.count(
        crossAxisCount: 4, // Number of notes in a row at a time
        children: [
          for (var note in appState.noteList) 
            Container(
            padding: const EdgeInsets.all(12),
            child: note,    
            )
        ],
      )
    :
      const Center(
        child: Text('No notes yet'),
      );

    return Scaffold(
      body: body,
      floatingActionButton:
        FloatingActionButton(
          onPressed: () {
            appState.createNote();
          },
          foregroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.add),
        ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );  
  }
} */

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }


    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),

      ]
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // You can change this color, and the color scheme of the whole app, by scrolling up to MyApp and changing the seed color for the ColorScheme there.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}