import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_bottom_bar.dart';
import '../../../services/camera_logic/camera_screen.dart';
import '../info_blur/info_blur_screen.dart';
import 'provider/ai_chat_main_page_provider.dart';
import 'dart:io';

class AiChatMainScreen extends StatefulWidget {
  const AiChatMainScreen({super.key});

  @override
  AiChatMainScreenState createState() => AiChatMainScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiChatMainProvider(),
      child: AiChatMainScreen(),
    );
  }
}

class AiChatMainScreenState extends State<AiChatMainScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSending = false;
  bool _isManualStop = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _speech = stt.SpeechToText();
    
    // Initialize breathing animation controller with faster speed
    _breathingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    // Create breathing animation with larger range
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5)
      .animate(CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ));
    
    // Make the animation repeat in both directions
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
    
    // Wait for the provider to be available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AiChatMainProvider>(context, listen: false);
      provider.onMessageAdded = () {
        // Add a small delay to ensure the UI is updated
        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      };
    });
  }

  Future<void> _handleMessageSend() async {
    if (_isSending) return;
    
    final provider = Provider.of<AiChatMainProvider>(context, listen: false);
    final message = provider.messageController.text.trim();
    if (message.isEmpty && provider.selectedImage == null) return;

    setState(() {
      _isSending = true;
      _isManualStop = true;  // Set manual stop flag
    });

    // Stop listening if active and ensure complete cleanup
    if (_isListening) {
      setState(() {
        _isListening = false;
        _isManualStop = true;
      });
      _breathingController.stop();
      await _speech.stop();
      // Small delay to ensure speech recognition is fully stopped
      await Future.delayed(Duration(milliseconds: 100));
    }

    // Send message
    provider.sendMessage(message);
    
    // Clear message box and reset states
    setState(() {
      provider.messageController.text = '';
      _isSending = false;
      _isManualStop = false;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (!_isManualStop) {  // Only handle if not manual stop
              setState(() {
                _isListening = false;
              });
              _breathingController.stop();
            }
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() {
            _isListening = false;
            _isSending = false;
            _isManualStop = false;
          });
          _breathingController.stop();
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _isManualStop = false;
        });
        _breathingController.forward();
        
        await _speech.listen(
          onResult: (result) {
            if (!mounted || _isManualStop || _isSending) return;
            
            final provider = Provider.of<AiChatMainProvider>(context, listen: false);
            if (!_isManualStop && !_isSending) {  // Double check to prevent updates after sending
              setState(() {
                provider.messageController.text = result.recognizedWords;
              });
            }
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 8),
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.dictation,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _isManualStop = true;  // Ensure manual stop is set when stopping listening
      });
      _breathingController.stop();
      await _speech.stop();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _breathingController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _openCamera() async {
    if (!mounted) return;
    // Get the list of available cameras
    final cameras = await availableCameras();
    if (!mounted) return;
    
    // Use the first available camera (usually the back camera)
    final firstCamera = cameras.first;

    // Navigate to the camera screen
    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: firstCamera),
      ),
    );

    // If an image was captured and kept, handle it
    if (imagePath != null && mounted) {
      final provider = Provider.of<AiChatMainProvider>(context, listen: false);
      provider.setSelectedImage(XFile(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Container(
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
          child: SafeArea(
            child: Column(
              children: [
                Consumer<AiChatMainProvider>(
                  builder: (context, provider, child) {
                    // Only show welcome content if messages are empty and keyboard is closed
                    if (provider.messages.isEmpty && MediaQuery.of(context).viewInsets.bottom == 0) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.h, top: 16.h),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      transitionDuration: Duration(milliseconds: 150),
                                      reverseTransitionDuration: Duration(milliseconds: 150),
                                      pageBuilder: (context, _, __) => const InfoBlurScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return Stack(
                                          children: [
                                            FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                            FadeTransition(
                                              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
                                              child: CustomImageView(
                                                imagePath: ImageConstant.imgInfo,
                                                height: 24.h,
                                                width: 24.h,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgInfo,
                                  height: 24.h,
                                  width: 24.h,
                                ),
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
                        padding: EdgeInsets.only(
                          top: 16.h,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 80.h, // Add padding when keyboard is open
                        ),
                        itemBuilder: (context, index) {
                          final message = provider.messages[index];
                          final isUser = message['role'] == 'user';
                          
                          // Check if the message contains an image path
                          final bool hasImagePath = message['content']?.contains('📸') ?? false;
                          
                          // If it's a user message with an image
                          if (isUser && hasImagePath) {
                            final imagePath = message['content']!.split('\n').last.trim();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.h),
                                  width: SizeUtils.width * 0.7, // 70% of screen width
                                  height: SizeUtils.height * 0.3, // 30% of screen height
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.h),
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (message['content']!.contains('User note:'))
                                  Container(
                                    margin: EdgeInsets.only(right: 16.h, bottom: 4.h),
                                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.lightBlue300,
                                      borderRadius: BorderRadius.circular(16.h),
                                    ),
                                    child: Text(
                                      message['content']!.split('\n')[1].replaceAll('User note: ', ''),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.h,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                          
                          // For nutrition info messages
                          if (!isUser && message['content']?.contains('🍽️') == true) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.h),
                                padding: EdgeInsets.all(12.h),
                                constraints: BoxConstraints(
                                  maxWidth: SizeUtils.width * 0.85,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9747FF),
                                  borderRadius: BorderRadius.circular(16.h),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: message['content']!
                                      .split('\n')
                                      .map((line) => Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.h),
                                            child: Text(
                                              line,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.h,
                                                fontWeight: line.startsWith('Food:') 
                                                    ? FontWeight.bold 
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          }
                          
                          // Default message rendering
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                              constraints: BoxConstraints(
                                maxWidth: SizeUtils.width * 0.85,
                              ),
                              decoration: BoxDecoration(
                                color: isUser ? appTheme.lightBlue300 : const Color(0xFF9747FF),
                                borderRadius: BorderRadius.circular(16.h),
                              ),
                              child: Text(
                                message['content'] ?? '',
                                style: TextStyle(
                                  color: Colors.white,
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 0,
          color: appTheme.cyan900,
          child: CustomBottomBar(
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
                  // Already on AI chat page, no navigation needed
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Consumer<AiChatMainProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 8.h,
            left: 20.h,
            right: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show action buttons only when track dialog is not visible and keyboard is not open
              if (!provider.showTrackDialog && MediaQuery.of(context).viewInsets.bottom == 0)
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        "Speak to TrackEat",
                        ImageConstant.imgSpeakingIcon,
                        onTap: _listen,
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
              if (!provider.showTrackDialog && MediaQuery.of(context).viewInsets.bottom == 0)
                SizedBox(height: 14.h),
              // Message input and track dialog
              Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dark blue background with slide to track
                    if (provider.showTrackDialog)
                      Container(
                        decoration: BoxDecoration(
                          color: provider.showTrackingSuccess ? Colors.transparent : const Color(0xFF0B2840),
                          borderRadius: BorderRadius.circular(20.h),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: provider.showTrackingSuccess ? 0 : 16.h, 
                          vertical: provider.showTrackingSuccess ? 0 : 12.h
                        ),
                        margin: EdgeInsets.only(bottom: provider.showTrackingSuccess ? 0 : 12.h),
                        child: Column(
                          children: [
                            if (!provider.showTrackingSuccess)
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.setTrackDialogState(false);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.h, bottom: 8.h),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (provider.showTrackingSuccess)
                              AnimatedOpacity(
                                opacity: provider.showTrackingSuccess ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(16.h),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Tracked Successfully',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.h,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (!provider.showTrackingSuccess && !provider.showMealTypeSelection)
                              Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25.h),
                                ),
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    final RenderBox box = context.findRenderObject() as RenderBox;
                                    final double maxDx = box.size.width - 50.h;
                                    final double progress = (details.localPosition.dx / maxDx).clamp(0.0, 1.0);
                                    provider.updateSlideProgress(progress);
                                  },
                                  onHorizontalDragEnd: (_) {
                                    if (provider.slideProgress < 0.8) {
                                      provider.resetSlideProgress();
                                    }
                                  },
                                  onHorizontalDragCancel: () {
                                    provider.resetSlideProgress();
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: (MediaQuery.of(context).size.width - 72.h) * provider.slideProgress,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(25.h),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Transform.translate(
                                            offset: Offset(
                                              provider.slideProgress * (MediaQuery.of(context).size.width - 120.h),
                                              0,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(8.h),
                                              margin: EdgeInsets.all(4.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 24.h,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'Slide to track it',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!provider.showTrackingSuccess && provider.showMealTypeSelection)
                              Column(
                                children: [
                                  Text(
                                    'Track it as:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.h,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  SizedBox(
                                    height: 50.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildMealTypeButton(context, 'Breakfast', provider),
                                        _buildMealTypeButton(context, 'Lunch', provider),
                                        _buildMealTypeButton(context, 'Dinner', provider),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    // Message input box (always in the same position)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 50.h,
                        maxHeight: 150.h,
                      ),
                      child: Stack(
                        children: [
                          Row(
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
                                  child: Row(
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
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (provider.selectedImage != null)
                                              Container(
                                                margin: EdgeInsets.only(left: 20.h, bottom: 4.h),
                                                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(12.h),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Image added",
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12.h,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.h),
                                                    GestureDetector(
                                                      onTap: provider.removeImage,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.grey[600],
                                                        size: 14.h,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            TextField(
                                              controller: provider.messageController,
                                              decoration: InputDecoration(
                                                hintText: provider.showTrackDialog
                                                    ? "Want to edit something?"
                                                    : "Message TrackEat - AI",
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
                                              onSubmitted: (value) {
                                                // Just unfocus to close keyboard
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleMessageSend,
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
                          // Animated overlay that doesn't affect layout
                          if (_isListening)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: AnimatedBuilder(
                                  animation: _breathingAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.h),
                                        border: Border.all(
                                          color: appTheme.lightBlue300,
                                          width: 3.0 * _breathingAnimation.value,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: appTheme.lightBlue300.withOpacity(0.5),
                                            blurRadius: 12.0 * _breathingAnimation.value,
                                            spreadRadius: 4.0 * _breathingAnimation.value,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
      },
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

  Widget _buildMealTypeButton(BuildContext context, String mealType, AiChatMainProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.selectMealType(mealType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: provider.selectedMealType == mealType 
              ? Colors.green 
              : const Color(0xFF1B6A9C),
          borderRadius: BorderRadius.circular(16.h),
        ),
        child: Text(
          mealType,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.h,
          ),
        ),
      ),
    );
  }
}