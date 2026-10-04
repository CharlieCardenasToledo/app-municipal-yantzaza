import 'package:flutter/material.dart';

/// Imágenes editoriales locales o remotas con un fallback visual institucional.
class YantzazaRemoteImage extends StatelessWidget {
  final String url;
  final String? assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? overlay;

  const YantzazaRemoteImage({
    super.key,
    required this.url,
    this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
          _buildImage(context),
            ?overlay,
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final fallback = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined, size: 42, color: Theme.of(context).colorScheme.outline),
    );

    if (assetPath != null) {
      return Image.asset(assetPath!, height: height, width: width, fit: fit, filterQuality: FilterQuality.medium, errorBuilder: (_, _, _) => fallback);
    }

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.medium,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
