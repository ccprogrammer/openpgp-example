import 'package:flutter/material.dart';
import 'package:opensort/component/encrypt_message.dart';
import 'package:opensort/component/generate_key.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          GenerateKey(),
          Divider(
            height: 48,
            thickness: 2,
            color: Colors.black,
            indent: 16,
            endIndent: 16,
          ),
          EncryptMessage(),
        ],
      ),
    );
  }
}
