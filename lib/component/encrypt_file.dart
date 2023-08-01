import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_wrapper.dart';
import 'package:opensort/component/expandable_text.dart';

class EncryptFile extends StatefulWidget {
  const EncryptFile({super.key, required this.keyPair});
  final KeyPair? keyPair;

  @override
  State<EncryptFile> createState() => _EncryptFile();
}

class _EncryptFile extends State<EncryptFile> {
  File? _file;

  Uint8List? encryptedBytes;
  File? decryptedBytes;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _file = File(result.files.single.path!);
        });
      }
    } catch (_) {
      log('file picker crash');
    }
  }

  _encryptFile() async {
    try {
      encryptedBytes = await OpenPGP.encryptSymmetricBytes(
        _file!.readAsBytesSync(),
        '',
      );
    } catch (_) {}
    log('Original File =>\n');
    log('Encrypt File =>\n$encryptedBytes');
    setState(() {});
  }

  _decryptFile() async {
    try {
      var tmpDecryptedFile = await OpenPGP.decryptSymmetricBytes(
        encryptedBytes!,
        '',
      );
      log('decrypted file === $tmpDecryptedFile');
      decryptedBytes = File(tmpDecryptedFile.toString());
    } catch (_) {}
    log('decryptedSymmetricBytes File =>\n$decryptedBytes');
    setState(() {});
  }

  reset() {
    _file = null;
    encryptedBytes = null;
    decryptedBytes = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EncryptWrapper(
      label: 'Encrypt File (Symmetric Bytes)',
      reset: () => reset(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _pickFile(),
            child: const Text('Pick File'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: _file == null
                ? const Text('No file selected.')
                : Text('${_file!.path}.'),
          ),
          if (_file != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'File Bytes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ExpandableText(
                    text: _file!.readAsBytesSync().toString(), trimLines: 10),
              ],
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _encryptFile(),
            child: const Text('Encrypt Symmetric Bytes'),
          ),
          const SizedBox(height: 8),
          if (encryptedBytes != null)
            ExpandableText(text: encryptedBytes!.toString(), trimLines: 10),
          ElevatedButton(
            onPressed: () => _decryptFile(),
            child: const Text('Decrypt Symmetric Bytes'),
          ),
          const SizedBox(height: 8),
          Container(
            child: decryptedBytes == null
                ? const Text('Encrypted Symmetric Bytes.')
                : ExpandableText(text: decryptedBytes!.path, trimLines: 10),
          ),
        ],
      ),
    );
  }
}
