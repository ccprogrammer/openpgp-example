import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_wrapper.dart';
import 'package:opensort/component/expandable_text.dart';

class EncryptSymmetric extends StatefulWidget {
  const EncryptSymmetric({super.key, required this.keyPair});
  final KeyPair? keyPair;

  @override
  State<EncryptSymmetric> createState() => _EncryptSymmetric();
}

class _EncryptSymmetric extends State<EncryptSymmetric> {
  var messageC = TextEditingController();

  Uint8List? encryptedBytes;
  String? decryptedBytes;

  _encryptSymmetricBytes() async {
    try {
      encryptedBytes = await OpenPGP.encryptSymmetricBytes(
        Uint8List.fromList(messageC.text.codeUnits),
        '',
      );
    } catch (_) {}
    log('Original Message =>\n');
    log('Encrypt Message =>\n$encryptedBytes');
    setState(() {});
  }

  _decryptSymmetricBytes() async {
    try {
      var tmpDecryptedMessage = await OpenPGP.decryptSymmetricBytes(
        encryptedBytes!,
        '',
      );
      log('decrypted message === $tmpDecryptedMessage');
      decryptedBytes = tmpDecryptedMessage.toString();
    } catch (_) {}

    log('decryptedSymmetricBytes  =>\n$decryptedBytes');
    setState(() {});
  }

  reset() {
    messageC.text = '';
    encryptedBytes = null;
    decryptedBytes = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EncryptWrapper(
      label: 'Encrypt Message (Symmetric Bytes)',
      reset: () => reset(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: messageC,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _encryptSymmetricBytes(),
            child: const Text('Encrypt Symmetric Bytes'),
          ),
          const SizedBox(height: 8),
          if (encryptedBytes != null)
            ExpandableText(text: encryptedBytes!.toString(), trimLines: 4),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _decryptSymmetricBytes(),
            child: const Text('Decrypt Symmetric Bytes'),
          ),
          const SizedBox(height: 8),
          Container(
            child: decryptedBytes == null
                ? const Text('Encrypted Symmetric Bytes.')
                : Text('$decryptedBytes'),
          ),
        ],
      ),
    );
  }
}
