import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/message_model.dart';
import 'provider/social_profile_message_from_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialProfileMessageFromProfileScreen extends StatefulWidget {
  const SocialProfileMessageFromProfileScreen({Key? key}) : super(key: key);

  @override
  SocialProfileMessageFromProfileScreenState createState() =>
      SocialProfileMessageFromProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMessageFromProfileProvider(),
      child: const SocialProfileMessageFromProfileScreen(),
    );
  }
}

class SocialProfileMessageFromProfileScreenState
    extends State<SocialProfileMessageFromProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height - 30.h,
              decoration: BoxDecoration(
                color: const Color(0xFFB2D7FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(54.h),
                  topRight: Radius.circular(54.h),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(54.h),
                  topRight: Radius.circular(54.h),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    _buildProfileInfo(),
                    Expanded(
                      child: StreamBuilder<List<Message>>(
                        stream: Provider.of<SocialProfileMessageFromProfileProvider>(context)
                            .getMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No messages yet",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }

                          final messages = snapshot.data!;
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe = message.senderId == 
                                  FirebaseAuth.instance.currentUser?.email;

                              return Align(
                                alignment: isMe 
                                    ? Alignment.centerRight 
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 8.h,
                                    left: isMe ? 50.h : 0,
                                    right: isMe ? 0 : 50.h,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.h,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe ? theme.colorScheme.primary : Colors.white,
                                    borderRadius: BorderRadius.circular(20.h),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _buildMessageInput(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Container(
                padding: EdgeInsets.all(4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgVectorOnerrorcontainer,
                  height: 60.h,
                  width: 60.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 8.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      title: AppbarSubtitle(
        text: "Profile",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Nancy Reagan",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "@nancy_reagan",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Today 3:25 PM",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.h),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25.h),
              ),
              child: Consumer<SocialProfileMessageFromProfileProvider>(
                builder: (context, provider, child) {
                  return TextField(
                    controller: provider.messageoneController,
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Consumer<SocialProfileMessageFromProfileProvider>(
            builder: (context, provider, child) {
              final bool hasText = provider.messageoneController.text.trim().isNotEmpty;
              return Container(
                decoration: BoxDecoration(
                  color: hasText ? theme.colorScheme.primary : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: hasText ? () {
                    provider.sendMessage(provider.messageoneController.text);
                  } : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}