import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openpgp/openpgp.dart';
import 'package:opensort/component/encrypt_wrapper.dart';
import 'package:opensort/component/expandable_text.dart';

class EncryptImage extends StatefulWidget {
  const EncryptImage({super.key, required this.keyPair});
  final KeyPair? keyPair;

  @override
  State<EncryptImage> createState() => _EncryptImageState();
}

class _EncryptImageState extends State<EncryptImage> {
  File? _image;
  Uint8List? encryptedBytes;
  File? decryptedBytes;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  _encryptImage() async {
    try {
      encryptedBytes = await OpenPGP.encryptBytes(
        _image!.readAsBytesSync(),
        widget.keyPair!.publicKey,
      );
    } catch (_) {}
    log('Original Image =>\n');
    log('Encrypt Image =>\n$encryptedBytes');
    setState(() {});
  }

  _decryptImage() async {
    log('Encrypt Image =>\n$encryptedBytes');
    try {
      var tmpDecryptedImg = await OpenPGP.decryptBytes(
        encryptedBytes!,
        widget.keyPair!.privateKey,
        '',
      );
      decryptedBytes = File(tmpDecryptedImg.toString());
    } catch (_) {}
    log('decryptedBytes Image =>\n$decryptedBytes');
    setState(() {});
  }

  reset() {
    _image = null;
    encryptedBytes = null;
    decryptedBytes = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EncryptWrapper(
      label: 'Encrypt Image (Bytes)',
      reset: () => reset(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _getImageFromGallery(),
            child: const Text('Get Image'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
          ),
          if (_image != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Image Bytes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ExpandableText(
                    text: _image!.readAsBytesSync().toString(), trimLines: 10),
              ],
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _encryptImage(),
            child: const Text('Encrypt Bytes'),
          ),
          const SizedBox(height: 8),
          if (encryptedBytes != null)
            ExpandableText(text: encryptedBytes!.toString(), trimLines: 10),
          ElevatedButton(
            onPressed: () => _decryptImage(),
            child: const Text('Decrypt Bytes'),
          ),
          const SizedBox(height: 8),
          Container(
            child: decryptedBytes == null
                ? const Text('Encrypted Bytes.')
                : Image.file(_image!),
          ),
        ],
      ),
    );
  }
}
