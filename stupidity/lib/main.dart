import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: DoodooApi(),
    );
  }
}

class DoodooApi extends StatefulWidget {
  const DoodooApi({super.key});

  @override
  State<DoodooApi> createState() => _DoodooApiState();
}

class _DoodooApiState extends State<DoodooApi> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = "";

  void _submit() {
    int value = int.tryParse(_controller.text) ?? 0;
    int shifted = value << 2;

    setState(() {
      _displayText = '$shifted';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bit Shift Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter a number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            Text('You typed (shifted << 2): $_displayText'),
          ],
        ),
      ),
    );
  }
}
