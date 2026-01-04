import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';

/// Loading widget with shimmer effect
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          );
        },
      ),
    );
  }
}

/// Circular progress indicator centered
class CenteredLoadingWidget extends StatelessWidget {
  const CenteredLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

