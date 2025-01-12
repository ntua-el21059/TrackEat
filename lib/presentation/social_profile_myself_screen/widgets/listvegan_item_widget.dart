import '../../../core/app_export.dart';
import '../models/listvegan_item_model.dart';

class ListveganItemWidget extends StatelessWidget {
  final ListveganItemModel model;

  const ListveganItemWidget(this.model, {Key? key}) : super(key: key);

  Widget _buildContainer(BuildContext context, String text, Color color) {
    bool hasDietEmoji = text.contains('🌱') || text.contains('🥩') || 
                       text.contains('🥗') || text.contains('🐟') || 
                       text.contains('🥑') || text.contains('🍎');
    bool hasStarEmoji = text.contains('⭐️');
    bool hasEmoji = hasDietEmoji || hasStarEmoji;
    
    String displayText = text;
    String? emoji;
    if (hasDietEmoji) {
      displayText = text.substring(0, text.length - 2);
      emoji = text.substring(text.length - 2);
    } else if (hasStarEmoji) {
      displayText = text.substring(0, text.length - 3);
      emoji = text.substring(text.length - 3);
    }

    return Container(
      width: 160.h,
      height: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: hasEmoji
          ? RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: displayText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  TextSpan(
                    text: emoji,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? dietText = model.title;
    Color boxColor;

    if (dietText?.contains("been thriving") == true || dietText?.contains("'s been thriving") == true || dietText?.contains("thriving") == true) {
      boxColor = const Color(0xFFFFD700); // Yellow for thriving message
    } else {
      switch (dietText) {
        case 'Vegan🌱':
          boxColor = const Color(0xFF4CAF50); // Green
          break;
        case 'Carnivore🥩':
          boxColor = const Color(0xFFB84C4C); // Red
          break;
        case 'Vegetarian🥗':
          boxColor = const Color(0xFF8BC34A); // Light Green
          break;
        case 'Pescatarian🐟':
          boxColor = const Color(0xFF03A9F4); // Light Blue
          break;
        case 'Keto🥑':
          boxColor = const Color(0xFF9C27B0); // Purple
          break;
        case 'Fruitarian🍎':
          boxColor = const Color(0xFFFF9800); // Orange
          break;
        default:
          boxColor = const Color(0xFFFFD700); // Yellow for default/unknown diet
      }
    }
    return _buildContainer(context, dietText ?? "", boxColor);
  }
}