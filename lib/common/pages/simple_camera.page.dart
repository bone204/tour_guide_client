import 'package:camera/camera.dart';
import 'package:tour_guide_app/common_libs.dart';

class SimpleCameraPage extends StatefulWidget {
  final String instructionText;
  final CameraLensDirection initialDirection;

  const SimpleCameraPage({
    super.key,
    required this.instructionText,
    this.initialDirection = CameraLensDirection.back,
  });

  @override
  State<SimpleCameraPage> createState() => _SimpleCameraPageState();
}

class _SimpleCameraPageState extends State<SimpleCameraPage> {
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
        // Find preferred camera
        final preferredIndex = _cameras!.indexWhere(
          (c) => c.lensDirection == widget.initialDirection,
        );
        _selectedCameraIndex = preferredIndex != -1 ? preferredIndex : 0;

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
    if (!_isInitialized ||
        _controller == null ||
        _controller!.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile image = await _controller!.takePicture();

      if (mounted) {
        Navigator.pop(context, image);
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
        backgroundColor:
            Colors.black, // Camera background should always be black
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
                  padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                  child: Text(
                    widget.instructionText,
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
                      // Placeholder to balance layout
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
