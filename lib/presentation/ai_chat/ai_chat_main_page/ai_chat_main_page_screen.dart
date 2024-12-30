import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_bottom_bar.dart';
import '../../../services/camera_logic/camera_screen.dart';
import 'models/ai_chat_main_page_model.dart';
import 'provider/ai_chat_main_page_provider.dart';
import 'dart:io';

class AiChatMainScreen extends StatefulWidget {
  const AiChatMainScreen({Key? key}) : super(key: key);

  @override
  AiChatMainScreenState createState() => AiChatMainScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiChatMainProvider(),
      child: AiChatMainScreen(),
    );
  }
}

class AiChatMainScreenState extends State<AiChatMainScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Wait for the provider to be available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AiChatMainProvider>(context, listen: false);
      provider.onMessageAdded = _scrollToBottom;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    // Get the list of available cameras
    final cameras = await availableCameras();
    
    // Use the first available camera (usually the back camera)
    final firstCamera = cameras.first;

    // Navigate to the camera screen
    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: firstCamera),
      ),
    );

    // If an image was captured, handle it
    if (imagePath != null) {
      final provider = Provider.of<AiChatMainProvider>(context, listen: false);
      
      // Set the selected image in the provider
      provider.selectedImage = XFile(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan900,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: SizeUtils.height,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              Consumer<AiChatMainProvider>(
                builder: (context, provider, child) {
                  if (provider.messages.isEmpty) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.h, top: 16.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgInfo,
                              height: 24.h,
                              width: 24.h,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeUtils.height * 0.05),
                        Text(
                          "What can I help\nyou with?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.h,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgSiriGraph,
                          height: 46.h,
                          width: double.maxFinite,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: Consumer<AiChatMainProvider>(
                  builder: (context, provider, child) {
                    if (provider.messages.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: false,
                      itemCount: provider.messages.length,
                      padding: EdgeInsets.only(top: 16.h),
                      itemBuilder: (context, index) {
                        final message = provider.messages[index];
                        final isUser = message['role'] == 'user';
                        
                        // Check if the message contains an image path
                        final bool hasImagePath = message['content']?.contains('📸') ?? false;
                        
                        // If it's a user message with an image
                        if (isUser && hasImagePath) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              width: SizeUtils.width * 0.7, // 70% of screen width
                              height: SizeUtils.height * 0.4, // 40% of screen height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.h),
                                image: DecorationImage(
                                  image: FileImage(File(message['content']!.split('\n').last.trim())),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                        
                        // For nutrition info messages
                        if (!isUser && message['content']?.contains('🍽️ Nutrition Information:') == true) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.all(12.h),
                              width: SizeUtils.width * 0.7, // 70% of screen width
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.h),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🍽️ Nutrition Information',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.h,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ...message['content']!
                                      .split('\n')
                                      .skip(1)
                                      .map((line) => Text(
                                            line,
                                            style: TextStyle(fontSize: 14.h),
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        // Default message rendering
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.all(12.h),
                            decoration: BoxDecoration(
                              color: isUser ? appTheme.lightBlue300 : Colors.white,
                              borderRadius: BorderRadius.circular(16.h),
                            ),
                            child: Text(
                              message['content'] ?? '',
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 16.h,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              _buildBottomSection(context),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        backgroundColor: appTheme.cyan900,
        onChanged: (BottomBarEnum type) {
          switch (type) {
            case BottomBarEnum.Home:
              Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
              break;
            case BottomBarEnum.Leaderboard:
              Navigator.pushNamed(context, "/leaderboard");
              break;
            case BottomBarEnum.AI:
              Navigator.pushNamed(context, AppRoutes.aiChatSplashScreen);
              break;
          }
        },
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                "Speak to TrackEat - AI",
                ImageConstant.imgSpeakingIcon,
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: _buildActionButton(
                "SnapEat",
                ImageConstant.imgCameraIcon,
                onTap: _openCamera,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Consumer<AiChatMainProvider>(
          builder: (context, provider, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.h),
              ),
              constraints: BoxConstraints(
                minHeight: 50.h,
                maxHeight: 150.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 50.h,
                        maxHeight: 120.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<AiChatMainProvider>(
                            builder: (context, provider, child) {
                              if (provider.selectedImage != null) {
                                return Container(
                                  margin: EdgeInsets.only(top: 8.h, left: 8.h, right: 8.h),
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.h),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.h),
                                        child: Image.file(
                                          File(provider.selectedImage!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4.h,
                                        right: 4.h,
                                        child: GestureDetector(
                                          onTap: provider.removeImage,
                                          child: Container(
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final provider = Provider.of<AiChatMainProvider>(
                                    context,
                                    listen: false,
                                  );
                                  provider.pickImage();
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: appTheme.lightBlue300,
                                  size: 24.h,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: provider.messageController,
                                  decoration: InputDecoration(
                                    hintText: "Message TrackEat - AI",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16.h,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.h,
                                      vertical: 12.h,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) => provider.sendMessage(value),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.sendMessage(provider.messageController.text),
                    child: Container(
                      margin: EdgeInsets.only(right: 4.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [appTheme.lightBlue300, theme.colorScheme.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.h),
                        child: provider.isLoading
                            ? SizedBox(
                                width: 20.h,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : CustomImageView(
                                imagePath: ImageConstant.imgArrowIcon,
                                height: 20.h,
                                width: 20.h,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, String iconPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appTheme.lightBlue300, theme.colorScheme.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(22.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.h),
            CustomImageView(
              imagePath: iconPath,
              height: 24.h,
              width: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}