import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_message.dart';
import 'package:opensort/component/expandable_text.dart';

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
          ..passphrase = '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildgenerateKey(),
          const Divider(
            height: 48,
            thickness: 2,
            color: Colors.black,
            indent: 16,
            endIndent: 16,
          ),
          const EncryptMessage(),
        ],
      ),
    );
  }

  buildgenerateKey() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => generateKey(),
              child: const Text('Generate Key'),
            ),
            buildKeyContainer(
              title: 'Private Key',
              key: '${keyPair?.privateKey}',
              onTap: () => FlutterClipboard.copy(keyPair!.privateKey),
            ),
            buildKeyContainer(
              title: 'Public Key',
              key: '${keyPair?.publicKey}',
              onTap: () => FlutterClipboard.copy(keyPair!.publicKey),
            ),
          ],
        ),
      );

  buildKeyContainer(
      {required String title, required String key, required Function() onTap}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => onTap(),
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        ExpandableText(text: key, trimLines: 6),
      ],
    );
  }
}
