import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:image/image.dart' as img;

class CccdCameraPage extends StatefulWidget {
  const CccdCameraPage({super.key});

  @override
  State<CccdCameraPage> createState() => _CccdCameraPageState();
}

class _CccdCameraPageState extends State<CccdCameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isLoading = true;
  bool _isInitialized = false;
  bool _isTakingPicture = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Find back camera preference for CCCD
        final backCameraIndex = _cameras!.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
        );
        _selectedCameraIndex = backCameraIndex != -1 ? backCameraIndex : 0;

        await _initializeController();
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = AppLocalizations.of(context)!.noCamerasAvailable;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = AppLocalizations.of(
            context,
          )!.cameraError(e.toString());
        });
      }
    }
  }

  Future<void> _initializeController() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    final camera = _cameras![_selectedCameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = AppLocalizations.of(
            context,
          )!.cameraError(e.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    // Switch to next camera
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;

    if (_controller != null) {
      await _controller!.dispose();
    }

    // reset state
    setState(() {
      _isInitialized = false;
      _isLoading = true;
    });

    await _initializeController();
  }

  Future<void> _takePicture() async {
    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile imageFile = await _controller!.takePicture();

      // Read the image bytes
      final bytes = await imageFile.readAsBytes();
      var capturedImage = img.decodeImage(bytes);

      if (capturedImage != null) {
        // Handle orientation if needed (bakeOrientation usually handles EXIF)
        capturedImage = img.bakeOrientation(capturedImage);

        // Get screen size and pixel ratio
        if (mounted) {
          final screenSize = MediaQuery.of(context).size;
          final screenWidth = screenSize.width;
          final screenHeight = screenSize.height;

          // Helper variables for image dimensions
          final imageWidth = capturedImage.width;
          final imageHeight = capturedImage.height;

          // Calculate the Rect of the Preview as it appears on screen (Contain fit)
          // The camera preview maintains aspect ratio and fits inside the screen
          final double screenAspectRatio = screenWidth / screenHeight;
          final double imageAspectRatio = imageWidth / imageHeight;

          double renderWidth;
          double renderHeight;
          double renderOffsetX;
          double renderOffsetY;

          if (screenAspectRatio > imageAspectRatio) {
            // Screen is "wider" than image.
            // Fit HEIGHT (Contain behavior)
            renderHeight = screenHeight;
            renderWidth = screenHeight * imageAspectRatio;
            renderOffsetX = (screenWidth - renderWidth) / 2;
            renderOffsetY = 0;
          } else {
            // Screen is "taller" than image.
            // Fit WIDTH (Contain behavior)
            renderWidth = screenWidth;
            renderHeight = screenWidth / imageAspectRatio;
            renderOffsetX = 0;
            renderOffsetY = (screenHeight - renderHeight) / 2;
          }

          // Calculate the Cutout Rect on Screen
          final cutoutWidth = screenWidth * 0.9;
          final cutoutHeight = cutoutWidth / 1.58;
          final cutoutRect = Rect.fromCenter(
            center: Offset(screenWidth / 2, screenHeight / 2),
            width: cutoutWidth,
            height: cutoutHeight,
          );

          // Map Cutout Rect to Image Coordinates
          // (cutoutX - renderOffsetX) / renderWidth = (imageCropX) / imageWidth

          double cropX =
              (cutoutRect.left - renderOffsetX) * (imageWidth / renderWidth);
          double cropY =
              (cutoutRect.top - renderOffsetY) * (imageHeight / renderHeight);
          double cropW = cutoutRect.width * (imageWidth / renderWidth);
          double cropH = cutoutRect.height * (imageHeight / renderHeight);

          // Ensure crop bounds are valid
          cropX = cropX.clamp(0, imageWidth.toDouble());
          cropY = cropY.clamp(0, imageHeight.toDouble());
          if (cropX + cropW > imageWidth) cropW = imageWidth - cropX;
          if (cropY + cropH > imageHeight) cropH = imageHeight - cropY;

          // Crop
          final croppedImage = img.copyCrop(
            capturedImage,
            x: cropX.toInt(),
            y: cropY.toInt(),
            width: cropW.toInt(),
            height: cropH.toInt(),
          );

          // Encode to JPG
          final croppedBytes = img.encodeJpg(croppedImage);

          // Write back to file
          final File resultFile = File(imageFile.path);
          await resultFile.writeAsBytes(croppedBytes);

          Navigator.pop(context, XFile(resultFile.path));
        }
      } else {
        // Fallback if decode fails
        if (mounted) Navigator.pop(context, imageFile);
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.takePictureError(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.onPrimary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.cameraNotInitialized,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          // CCCD Overlay
          CustomPaint(
            painter: CccOverlayPainter(theme.colorScheme.primary),
            child: Container(),
          ),

          // Controls
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // Top Instruction
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    AppLocalizations.of(context)!.citizenIdInstruction,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Bottom Controls
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 30.h,
                    left: 30.w,
                    right: 30.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 48),

                      // Capture Button
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child:
                              _isTakingPicture
                                  ? CircularProgressIndicator(
                                    color: theme.colorScheme.primary,
                                  )
                                  : Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),

                      // Switch Camera
                      IconButton(
                        onPressed: _switchCamera,
                        icon: const Icon(
                          Icons.cameraswitch_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CccOverlayPainter extends CustomPainter {
  final Color primaryColor;

  CccOverlayPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // CCCD usually 85.6mm x 53.98mm => ~1.58 ratio
    // Let's take 90% width of screen, calculate height based on ratio
    final cutoutWidth = size.width * 0.9;
    final cutoutHeight = cutoutWidth / 1.58;

    final cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutoutWidth,
      height: cutoutHeight,
    );

    final cutoutRRect = RRect.fromRectAndRadius(
      cutoutRect,
      const Radius.circular(12),
    );

    final cutoutPath = Path()..addRRect(cutoutRRect);

    final overlayPath = Path.combine(
      PathOperation.difference,
      path,
      cutoutPath,
    );

    canvas.drawPath(overlayPath, paint);

    // Draw Frame Corners
    final borderPaint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final double cornerLength = 30.0;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(cutoutRect.left, cutoutRect.top + cornerLength)
        ..lineTo(cutoutRect.left, cutoutRect.top)
        ..lineTo(cutoutRect.left + cornerLength, cutoutRect.top),
      borderPaint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(cutoutRect.right - cornerLength, cutoutRect.top)
        ..lineTo(cutoutRect.right, cutoutRect.top)
        ..lineTo(cutoutRect.right, cutoutRect.top + cornerLength),
      borderPaint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(cutoutRect.right, cutoutRect.bottom - cornerLength)
        ..lineTo(cutoutRect.right, cutoutRect.bottom)
        ..lineTo(cutoutRect.right - cornerLength, cutoutRect.bottom),
      borderPaint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(cutoutRect.left + cornerLength, cutoutRect.bottom)
        ..lineTo(cutoutRect.left, cutoutRect.bottom)
        ..lineTo(cutoutRect.left, cutoutRect.bottom - cornerLength),
      borderPaint,
    );

    // Optional: Draw a subtle thin line around the whole shape
    final thinBorderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawRRect(cutoutRRect, thinBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
