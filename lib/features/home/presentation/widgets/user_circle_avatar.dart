import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:lottie/lottie.dart';

class UserCircleAvatar extends StatelessWidget {
  final UserEntity user;
  final String defaultProfileImagePath;
  final double? radius;

  const UserCircleAvatar({
    super.key,
    required this.user,
    required this.defaultProfileImagePath,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colorScheme.primaryContainer,
      child: CachedNetworkImage(
        imageUrl: user.profilePicture?['url'] ?? '',
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: radius,
          backgroundColor: context.colorScheme.primaryContainer,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 50,
          backgroundColor: context.colorScheme.primaryContainer,
          backgroundImage: AssetImage(defaultProfileImagePath),
        ),
      ),
    );
  }
}
