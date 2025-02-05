import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/message_model.dart';
import 'provider/social_profile_message_from_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class SocialProfileMessageFromProfileScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;
  final String? receiverUsername;

  const SocialProfileMessageFromProfileScreen({
    Key? key,
    this.receiverId,
    this.receiverName,
    this.receiverUsername,
  }) : super(key: key);

  @override
  SocialProfileMessageFromProfileScreenState createState() =>
      SocialProfileMessageFromProfileScreenState();

  static Widget builder(
    BuildContext context, {
    String? receiverId,
    String? receiverName,
    String? receiverUsername,
  }) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMessageFromProfileProvider()
        ..setReceiverInfo(
          receiverId: receiverId,
          receiverName: receiverName,
          receiverUsername: receiverUsername,
        ),
      child: SocialProfileMessageFromProfileScreen(
        receiverId: receiverId,
        receiverName: receiverName,
        receiverUsername: receiverUsername,
      ),
    );
  }
}

class SocialProfileMessageFromProfileScreenState
    extends State<SocialProfileMessageFromProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final FocusNode _messageFocusNode = FocusNode();
  Map<int, bool> _showTimestamp = {};
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
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
                        child:
                            Consumer<SocialProfileMessageFromProfileProvider>(
                          builder: (context, provider, _) {
                            final messages = provider.messages;

                            if (messages.isEmpty) {
                              return Center(
                                child: Text(
                                  "Start a conversation",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }

                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _scrollToBottom());
                            return ListView.builder(
                              controller: _scrollController,
                              reverse: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.h, vertical: 8.h),
                              itemCount: messages.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              addAutomaticKeepAlives: true,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isMe = message.senderId ==
                                    FirebaseAuth.instance.currentUser?.email;
                                final isLastMessage =
                                    index == messages.length - 1;
                                final showDateHeader =
                                    _shouldShowDateHeader(messages, index);

                                return Column(
                                  children: [
                                    if (showDateHeader)
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Text(
                                          _formatDateHeader(
                                              message.timestamp.toDate()),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    RepaintBoundary(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showTimestamp.clear();
                                            if (!isLastMessage) {
                                              _showTimestamp[index] =
                                                  !(_showTimestamp[index] ??
                                                      false);
                                            }
                                          });
                                        },
                                        child: Align(
                                          alignment: isMe
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: isMe
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 8.h,
                                                  left: isMe ? 60.h : 0,
                                                  right: isMe ? 0 : 60.h,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.h,
                                                  vertical: 10.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isMe
                                                      ? const Color(0xFF007AFF)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.h),
                                                    topRight:
                                                        Radius.circular(20.h),
                                                    bottomLeft: Radius.circular(
                                                        isMe ? 20.h : 5.h),
                                                    bottomRight:
                                                        Radius.circular(
                                                            isMe ? 5.h : 20.h),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  message.content,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: isMe
                                                        ? Colors.white
                                                        : Colors.black,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              if (isLastMessage ||
                                                  _showTimestamp[index] == true)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 4.h,
                                                    left: isMe ? 60.h : 8.h,
                                                    right: isMe ? 8.h : 60.h,
                                                    bottom: 4.h,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        _formatTimestamp(
                                                            message.timestamp),
                                                        style: theme
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                          color: Colors.black54,
                                                          fontSize: 10.h,
                                                        ),
                                                      ),
                                                      if (isMe) ...[
                                                        SizedBox(width: 4.h),
                                                        Icon(
                                                          message.isRead
                                                              ? Icons.done_all
                                                              : Icons.done,
                                                          size: 14.h,
                                                          color: message.isRead
                                                              ? Color(
                                                                  0xFF0084FF)
                                                              : Colors.black54,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                child: Consumer<SocialProfileMessageFromProfileProvider>(
                  builder: (context, provider, _) => ProfilePictureWidget(
                    receiverId: provider.receiverId ?? '',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(38.h),
      child: Container(
        color: Colors.white,
        child: CustomAppBar(
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
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<SocialProfileMessageFromProfileProvider>(
            builder: (context, provider, child) {
              return Text(
                "${provider.recipientName} ${provider.recipientSurname}",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          Consumer<SocialProfileMessageFromProfileProvider>(
            builder: (context, provider, child) {
              return Text(
                "@${provider.recipientUsername}",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final bottomPadding = Platform.isAndroid
        ? MediaQuery.of(context)
            .viewPadding
            .bottom // Gets Android navigation bar height
        : 32.h;
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.h),
        ),
      ),
      child: Consumer<SocialProfileMessageFromProfileProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25.h),
                  ),
                  child: TextField(
                    controller: provider.messageoneController,
                    focusNode: _messageFocusNode,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: provider.messageoneController,
                builder: (context, value, child) {
                  final isNotEmpty = value.text.trim().isNotEmpty;
                  return Container(
                    decoration: BoxDecoration(
                      color: isNotEmpty
                          ? theme.colorScheme.primary
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      onPressed: isNotEmpty
                          ? () => provider.sendMessage(value.text)
                          : null,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDateHeader(DateTime messageDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay =
        DateTime(messageDate.year, messageDate.month, messageDate.day);

    if (messageDay == today) {
      return 'Today';
    } else if (messageDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${messageDate.day}/${messageDate.month}/${messageDate.year}';
    }
  }

  bool _shouldShowDateHeader(List<Message> messages, int index) {
    if (index == 0) return true;

    final currentMessageDate = messages[index].timestamp.toDate();
    final previousMessageDate = messages[index - 1].timestamp.toDate();

    return !_isSameDay(currentMessageDate, previousMessageDate);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class ProfilePictureWidget extends StatelessWidget {
  final String receiverId;

  const ProfilePictureWidget({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final profilePicture = userData['profilePicture'] as String?;

          if (profilePicture != null && profilePicture.isNotEmpty) {
            return Container(
              height: 70.h,
              width: 70.h,
              padding: EdgeInsets.all(4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.memory(
                    base64Decode(profilePicture),
                    fit: BoxFit.cover,
                    gaplessPlayback:
                        true, // Prevents flashing during image updates
                  ),
                ),
              ),
            );
          }
        }

        return Container(
          height: 70.h,
          width: 70.h,
          padding: EdgeInsets.all(4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CustomImageView(
            imagePath: ImageConstant.imgVectorOnerrorcontainer,
            height: 62.h,
            width: 62.h,
          ),
        );
      },
    );
  }
}
