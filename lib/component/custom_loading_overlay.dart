import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustomLoadingFallback extends StatelessWidget {
  const CustomLoadingFallback({
    required this.isLoading,
    required this.child,
     this.loadingLabel,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    buildIndicator() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(width: 10),
            DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              child: Text(
                loadingLabel ?? 'Loading',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black54,
      progressIndicator: buildIndicator(),
      child: child,
    );
  }
}