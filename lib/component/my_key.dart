import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/expandable_text.dart';

class MyKey extends StatelessWidget {
  const MyKey({super.key, this.keyPair});
  final KeyPair? keyPair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 1,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildKeyContainer(
            title: 'Private Key',
            key: keyPair?.privateKey ?? '',
            onTap: () => keyPair?.privateKey != null
                ? FlutterClipboard.copy(keyPair?.privateKey ?? '')
                : showWarning(context),
          ),
          buildKeyContainer(
            title: 'Public Key',
            key: keyPair?.publicKey ?? '',
            onTap: () => keyPair?.publicKey != null
                ? FlutterClipboard.copy(keyPair?.publicKey ?? '')
                : showWarning(context),
          ),
        ],
      ),
    );
  }

  showWarning(context) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Warning"),
          content: const Text(
              "You need to generate key first by pressing the floating button right bottom"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
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
                fontSize: 18,
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
