class ReadTwoItemWidget extends StatelessWidget {
  // The constructor takes a model object that contains the notification data
  ReadTwoItemWidget(this.readTwoItemModelObj, {Key? key})
      : super(
          key: key,
        );
        
  // This holds the data for the notification being displayed
  ReadTwoItemModel readTwoItemModelObj;

  @override
  Widget build(BuildContext context) {
    // The root container defines the overall shape and padding of the notification
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
        vertical: 8.h,
      ),
      // This gives the notification a light grey background with rounded corners
      decoration: AppDecoration.lightGreyButtonsPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      // The Row arranges the notification text and Add button side by side
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The notification message text
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              readTwoItemModelObj.miabrooksier!,
              style: CustomTextStyles.titleSmallBold,
            ),
          ),
          // The Add button (built by a separate method)
          _buildAdd(context)
        ],
      ),
    );
  }