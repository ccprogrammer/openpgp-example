import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_image.dart';
import 'package:opensort/component/encrypt_message.dart';
import 'package:opensort/component/my_key.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  KeyPair? keyPair;

  generateKey() async {
    var keyOptions = KeyOptions()..rsaBits = 2048;

    keyPair = await OpenPGP.generate(
      options: Options()
        ..name = 'test'
        ..email = 'test@test.com'
        ..passphrase = ''
        ..keyOptions = keyOptions,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => generateKey(),
        child: const Icon(Icons.key),
      ),
      body: ListView(
        children: [
          MyKey(keyPair: keyPair),
          const EncryptMessage(),
          EncryptImage(keyPair: keyPair),
        ],
      ),
    );
  }
}
