import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_symmetric.dart';
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
  bool isGenerateLoading = false;

  Future<void> generateKey() async {
    setState(() {
      isGenerateLoading = true;
    });
    try {
      var keyOptions = KeyOptions()..rsaBits = 2048;

      keyPair = await OpenPGP.generate(
        options: Options()
          ..name = 'test'
          ..email = 'test@test.com'
          ..passphrase = ''
          ..keyOptions = keyOptions,
      );
    } catch (_) {}
    setState(() {
      isGenerateLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Openpgp Demo')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => generateKey().then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Key Generated'),
              duration: Duration(seconds: 3),
            ))),
        child: isGenerateLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Icon(Icons.key),
      ),
      body: ListView(
        children: [
          MyKey(keyPair: keyPair),
          const EncryptMessage(),
          EncryptImage(keyPair: keyPair),
          EncryptSymmetric(keyPair: keyPair),
          const SizedBox(height: 46),
        ],
      ),
    );
  }
}
