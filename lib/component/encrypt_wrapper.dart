import 'package:flutter/material.dart';

class EncryptWrapper extends StatelessWidget {
  const EncryptWrapper({
    super.key,
    required this.label,
    required this.child,
    required this.reset,
  });
  final String label;
  final Widget child;
  final Function() reset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => reset(),
                icon: const Icon(Icons.restore),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
