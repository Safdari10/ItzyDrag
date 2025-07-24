import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// The root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag-and-Drop Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Drag-and-Drop Game'),
    );
  }
}

// The main game screen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDropped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Game instructions or success message
            Text(
              _isDropped
                  ? 'Great job! You dropped the box!'
                  : 'Drag the blue box into the target area.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            // Row with draggable box and target
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Draggable blue box
                Draggable<Color>(
                  data: Colors.blue,
                  feedback: Container(
                    width: 80,
                    height: 80,
                    // ignore: deprecated_member_use
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  childWhenDragging: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey,
                  ),
                  child: Container(width: 80, height: 80, color: Colors.blue),
                ),
                const SizedBox(width: 60),
                // Drop target
                DragTarget<Color>(
                  onAcceptWithDetails: (color) {
                    setState(() {
                      _isDropped = true;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isDropped ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          _isDropped ? 'Success!' : 'Drop here',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Play Again button
            if (_isDropped)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isDropped = false;
                  });
                },
                child: const Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}
