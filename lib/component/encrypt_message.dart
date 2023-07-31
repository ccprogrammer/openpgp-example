import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_wrapper.dart';
import 'package:opensort/component/expandable_text.dart';

class EncryptMessage extends StatefulWidget {
  const EncryptMessage({super.key});

  @override
  State<EncryptMessage> createState() => _EncryptMessageState();
}

class _EncryptMessageState extends State<EncryptMessage> {
  var messageC = TextEditingController();
  String? privateKey;
  String? publicKey;
  String? encryptedMessage;
  String? decryptedMessage;

  pastePrivateKey() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        privateKey = value;
      });
    });
  }

  pastePublicKey() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        publicKey = value;
      });
      log('public key =>\n$value');
    });
  }

  encryptMessage() async {
    try {
      encryptedMessage = await OpenPGP.encrypt(
        messageC.text,
        publicKey!,
      );
    } catch (_) {}
    log('Original Message =>\n${messageC.text}');
    log('Encrypt message =>\n$encryptedMessage');
    setState(() {});
  }

  decryptMessage() async {
    log('Encrypt message =>\n$encryptedMessage');
    try {
      decryptedMessage = await OpenPGP.decrypt(
        encryptedMessage!,
        privateKey!,
        '',
      );
    } catch (_) {}
    log('DecryptedMessage message =>\n$decryptedMessage');
    setState(() {});
  }

  reset() {
    privateKey = null;
    publicKey = null;
    encryptedMessage = null;
    decryptedMessage = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EncryptWrapper(
      label: 'Encrypt Message (Normal Encryption)',
      reset: () => reset(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: messageC,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => pastePublicKey(),
            child: const Text('Paste Public Key'),
          ),
          const SizedBox(height: 8),
          if (publicKey != null)
            ExpandableText(text: '$publicKey', trimLines: 10),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => encryptMessage(),
            child: const Text('Encrypt Message'),
          ),
          const SizedBox(height: 8),
          if (encryptedMessage != null)
            ExpandableText(text: encryptedMessage!, trimLines: 10),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => pastePrivateKey(),
            child: const Text('Paste Private Key'),
          ),
          const SizedBox(height: 8),
          if (privateKey != null)
            ExpandableText(text: privateKey!, trimLines: 10),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => decryptMessage(),
            child: const Text('Decrypt Message'),
          ),
          const SizedBox(height: 8),
          Text(decryptedMessage ?? 'Encrypted Message')
        ],
      ),
    );
  }
}
