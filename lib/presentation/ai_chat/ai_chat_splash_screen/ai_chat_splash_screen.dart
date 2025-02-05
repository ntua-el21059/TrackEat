import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'provider/ai_chat_splash_provider.dart';

class AiChatSplashScreen extends StatefulWidget {
  const AiChatSplashScreen({super.key});

  @override
  AiChatSplashScreenState createState() => AiChatSplashScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiChatSplashProvider(),
      child: AiChatSplashScreen(),
    );
  }
}

class AiChatSplashScreenState extends State<AiChatSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.maxFinite,
        height: SizeUtils.height,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 120.h),
              CustomImageView(
                imagePath: ImageConstant.imgVector,
                height: 220.h,
                width: 240.h,
              ),
              Spacer(),
              Text(
                "Hello, it's TrackEat - AI",
                style: CustomTextStyles.headlineSmallBold,
              ),
              SizedBox(height: 20.h),
              CustomElevatedButton(
                height: 36.h,
                width: 100.h,
                text: "Next",
                buttonStyle: CustomButtonStyles.fillCyan,
                buttonTextStyle: CustomTextStyles.labelLargeSemiBold,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
                },
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}