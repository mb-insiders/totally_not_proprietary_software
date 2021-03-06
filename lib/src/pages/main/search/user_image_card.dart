import 'package:flutter/material.dart';

import 'package:involio/src/shared/config/app_config.dart';
import 'package:involio/src/theme/app_theme.dart';
import 'package:involio/src/theme/colors.dart';

class UserImageCard extends StatelessWidget {
  final String? name;
  late final String avatar;

  UserImageCard({
    Key? key,
    required this.name,
    required String? avatar,
  }) : super(key: key) {
    this.avatar = avatar ?? "";
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${AppConfig().baseUrl}api/user/files/get_s3_image/$avatar";

    double height = 114;
    double width = 117;
    double radius = 7;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              name ?? "",
              style: AppFonts.bodySmall
                  .copyWith(color: AppColors.involioWhiteShades100),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
