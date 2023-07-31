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
  File? _image;
  String? encryptedImage;
  File? decryptedImage;

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
      encryptedImage = await OpenPGP.encrypt(
        _image!.path,
        widget.keyPair!.publicKey,
      );
    } catch (_) {}
    log('Original Image =>\n');
    log('Encrypt Image =>\n$encryptedImage');
    setState(() {});
  }

  _decryptImage() async {
    log('Encrypt Image =>\n$encryptedImage');
    try {
      var tmpDecryptedImg = await OpenPGP.decrypt(
        encryptedImage!,
        widget.keyPair!.privateKey,
        '',
      );
      decryptedImage = File(tmpDecryptedImg);
    } catch (_) {}
    log('DecryptedImage Image =>\n$decryptedImage');
    setState(() {});
  }

  reset() {
    _image = null;
    encryptedImage = null;
    decryptedImage = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EncryptWrapper(
      label: 'Encrypt Image',
      reset: () => reset(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _getImageFromGallery(),
            child: const Text('Get Image'),
          ),
          Container(
            child: _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _encryptImage(),
            child: const Text('Encrypt Image'),
          ),
          const SizedBox(height: 8),
          if (encryptedImage != null)
            ExpandableText(text: encryptedImage!, trimLines: 10),
          ElevatedButton(
            onPressed: () => _decryptImage(),
            child: const Text('Decrypt Image'),
          ),
          const SizedBox(height: 8),
          Container(
            child: decryptedImage == null
                ? const Text('Encrypted Image.')
                : Image.file(_image!),
          ),
        ],
      ),
    );
  }
}
