import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
        title: 'Namer App',
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
  double height = 100;
  double width = 100;
  var text = 'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.';
  var noteList = <AnimatedContainer>[];
  void createNote() {
/*     noteList.add(
      AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        color: Colors.amberAccent,
        width: width,
        height: height,
        child:
          ElevatedButton(
            onPressed: () {
              height = 400;
              width = 400;
              Stack(
                children: [
                  noteList[0],
                  noteList[1],
                ],
              );
              notifyListeners();
            },
            style: 
              ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                minimumSize: Size.zero, // Set this
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15), 
              ),
            child: 
            // MODIFY SO IT IS RESIZED ACCORDING TO DISPLAY RESOLUTION, MAYBE PUT TEXT IN A CONTAINER?

                  AutoSizeText(
                    text,
                    //textScaler:TextScaler.linear(1),
                    style: TextStyle(
                      //height: 2.1,
                    ),
                    maxLines: 5,
                  ),
          ),
          )
    ); 
    notifyListeners(); */
  }
}

class MyNote extends StatefulWidget {
  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  double w = 40;
  double h = 40;
  Color bg = Colors.red;
  @override

  Widget build(BuildContext context) {
      return Scaffold(    
        body:
          AnimatedContainer(
            duration: Duration(seconds: 1),
            width: w.toDouble(),
            height: h.toDouble(),
            child: 
            FloatingActionButton(
              backgroundColor: bg,
              onPressed: () {
                setState(() {
                  w = w*4;
                  h = h*4;
                  bg = Colors.green;
                }); 
              },
            ),
          ),
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
                  extended: constraints.maxWidth >= 600,
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

class GeneratorPage extends StatelessWidget {
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
}

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