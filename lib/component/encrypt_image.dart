import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
  bool encryptLoading = false;
  bool decryptLoading = false;

  File? _image;
  String? encryptedBytes;
  File? decryptedBytes;

  final ImagePicker picker = ImagePicker();
  Future _getImageFromGallery() async {
    try {
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxHeight: 480,
        maxWidth: 640,
      );

      if (pickedImage == null) return;

      _image = File(pickedImage.path);
      setState(() {});

      log('image path =>\n${_image!.path}');
    } catch (e) {
      log('ERROR CRASH');
    }
  }

  _encryptImage() async {
    setState(() {
      encryptLoading = true;
    });
    try {
      var tmp = await OpenPGP.encryptBytes(
        _image!.readAsBytesSync(),
        widget.keyPair!.publicKey,
      );
      encryptedBytes = base64Encode(tmp);
    } catch (_) {
      log('Crashhh');
    }
    log('Encrypt Image =>\n$encryptedBytes');
    setState(() {
      encryptLoading = false;
    });
  }

  _decryptImage() async {
    setState(() {
      decryptLoading = true;
    });
    try {
      var tmpDecryptedImg = await OpenPGP.decryptBytes(
        base64Decode(encryptedBytes!),
        widget.keyPair!.privateKey,
        '',
      );
      decryptedBytes = File(tmpDecryptedImg.toString());
    } catch (_) {}
    log('decryptedBytes Image =>\n$decryptedBytes');
    setState(() {
      decryptLoading = false;
    });
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
            child: Text(encryptLoading ? 'Encrypting...' : 'Encrypt Bytes'),
          ),
          const SizedBox(height: 8),
          encryptedBytes != null
              ? ExpandableText(text: encryptedBytes!.toString(), trimLines: 10)
              : const Text('Eencrypted Bytes.'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _decryptImage(),
            child: Text(decryptLoading ? 'Decrypting...' : 'Decrypt Bytes'),
          ),
          const SizedBox(height: 8),
          Container(
            child: decryptedBytes == null
                ? const Text('Decrypted Bytes.')
                : Image.file(_image!),
          ),
        ],
      ),
    );
  }
}
