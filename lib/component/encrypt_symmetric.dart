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

  bool encryptLoading = false;
  bool decryptLoading = false;

  Uint8List? encryptedBytes;
  String? decryptedBytes;

  _encryptSymmetricBytes() async {
    setState(() {
      encryptLoading = true;
    });
    try {
      encryptedBytes = await OpenPGP.encryptSymmetricBytes(
        Uint8List.fromList(messageC.text.codeUnits),
        '',
      );
    } catch (_) {}
    log('Encrypt Message =>\n$encryptedBytes');
    setState(() {
      encryptLoading = false;
    });
  }

  _decryptSymmetricBytes() async {
    setState(() {
      decryptLoading = true;
    });
    try {
      var tmpDecryptedMessage = await OpenPGP.decryptSymmetricBytes(
        encryptedBytes!,
        '',
      );
      decryptedBytes = tmpDecryptedMessage.toString();
    } catch (_) {}

    log('decryptedSymmetricBytes  =>\n$decryptedBytes');
    setState(() {
      decryptLoading = false;
    });
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
            child: Text(
                encryptLoading ? 'Encrypting...' : 'Encrypt Symmetric Bytes'),
          ),
          const SizedBox(height: 8),
          if (encryptedBytes != null)
            ExpandableText(text: encryptedBytes!.toString(), trimLines: 4),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _decryptSymmetricBytes(),
            child: Text(
                decryptLoading ? 'Decrypting...' : 'Decrypt Symmetric Bytes'),
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
