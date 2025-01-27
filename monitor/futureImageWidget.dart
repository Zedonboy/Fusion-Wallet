import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FutureAdaptiveImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String fallbackAsset;
  final Widget? loadingWidget;

  const FutureAdaptiveImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.fallbackAsset = 'assets/images/usd.png',
    this.loadingWidget,
  }) : super(key: key);

  Future<Widget> _processImage() async {
    try {
      if (_isBase64()) {
        final decodedData = base64Decode(_getBase64Data());
        if (_isSvg()) {
          return SvgPicture.memory(
            decodedData,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          );
        } else {
          return Image.memory(
            decodedData,
            width: width,
            height: height,
            fit: fit,
            color: color,
            errorBuilder: (context, error, stackTrace) => _buildFallback(),
          );
        }
      } else if (_isSvg()) {
        if (imageUrl.startsWith('http')) {
          return SvgPicture.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (context) => _buildLoader(),
          );
        } else {
          return SvgPicture.asset(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          );
        }
      } else if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      } else {
        return Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      }
    } catch (e) {
      return _buildFallback();
    }
  }

  bool _isBase64() {
    try {
      if (imageUrl.startsWith('data:')) {
        return true;
      }
      final sanitized =
          imageUrl.replaceAll(RegExp(r'^data:image/[^;]+;base64,'), '');
      base64.decode(sanitized);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isSvg() {
    return imageUrl.toLowerCase().endsWith('.svg') ||
        imageUrl.toLowerCase().contains('svg+xml');
  }

  String _getBase64Data() {
    if (imageUrl.contains(',')) {
      return imageUrl.split(',')[1];
    }
    return imageUrl;
  }

  Widget _buildLoader() {
    if (loadingWidget != null) return loadingWidget!;

    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFallback() {
    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _processImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoader();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildFallback();
        }

        return snapshot.data!;
      },
    );
  }
}