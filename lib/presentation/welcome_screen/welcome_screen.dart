import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';
import 'welcome_provider.dart';
import '../../camera_logic/camera_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  WelcomeScreenState createState() => WelcomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeProvider(),
      child: WelcomeScreen(),
    );
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
  try {
    // Request camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraDescription = cameras.first;
      } else {
        print("No cameras available");
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      print("Camera access permission was denied.");
      if (status.isPermanentlyDenied) {
        openAppSettings(); // Open settings for manual permission enabling
      }
    }
  } catch (e) {
    print("Error initializing camera: $e");
  }
}

  Future<void> _openCamera() async {
    if (_cameraDescription != null) {
      final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: _cameraDescription),
        ),
      );

      if (imagePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved at $imagePath')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 24.h,
            vertical: 70.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgLogo,
                height: 212.h,
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  left: 36.h,
                  right: 34.h,
                ),
              ),
              SizedBox(height: 80.h),
              Text(
                "msg_welcome_to_trackeat".tr,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 84.h),
              CustomElevatedButton(
                text: "lbl_login".tr,
                onPressed: _openCamera, // Trigger the camera on press
              ),
              SizedBox(height: 16.h),
              Text(
                "lbl_or".tr,
                style: CustomTextStyles.bodyMediumBlack900,
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () {
                  onTapTxtCreateanone(context);
                },
                child: Text(
                  "msg_create_an_account".tr,
                  style: CustomTextStyles.bodyLargePrimary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the createAccountScreen when the action is triggered.
  void onTapTxtCreateanone(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.createAccountScreen,
    );
  }
}