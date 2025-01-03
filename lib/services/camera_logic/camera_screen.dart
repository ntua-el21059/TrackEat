import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import 'photo_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }).catchError((error) {
      print('Camera initialization error: $error');
    });
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      
      // Show preview screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoPreviewScreen(imagePath: image.path),
        ),
      );
      
      // If user confirmed the photo, return it
      if (result != null) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black background
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
        ),

        // Gradient border container
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 1.0],
              colors: [
                Color(0xFF2A85B5), // Lighter blue
                Color(0xFF1B6A9C), // Mid blue
                appTheme.cyan900,   // Current cyan
              ],
            ),
          ),
        ),

        // Main scaffold
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Camera preview with gradient border
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2A85B5),
                        appTheme.cyan900,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.h), // Border width
                    child: _isCameraInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.h),
                          child: CameraPreview(_controller),
                        )
                      : Container(
                          color: Colors.black.withOpacity(0.7),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                  ),
                ),
              ),

              // Top bar with close button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.h,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom section with title and camera button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 48.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: Text(
                          'SNAPEAT',
                          style: TextStyle(
                            color: Color(0xFFFFD700), // Golden yellow
                            fontSize: 20.h,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera button
                            GestureDetector(
                              onTap: _isCameraInitialized ? _takePicture : null,
                              child: SvgPicture.asset(
                                'assets/images/camera_button.svg',
                                height: 80.h,
                                width: 80.h,
                              ),
                            ),
                            // Flash button
                            Positioned(
                              right: 32.h,
                              child: GestureDetector(
                                onTap: _toggleFlash,
                                child: SvgPicture.asset(
                                  _isFlashOn 
                                    ? 'assets/images/flash_icon_pressed.svg'
                                    : 'assets/images/flash_icon.svg',
                                  height: 32.h,
                                  width: 32.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}