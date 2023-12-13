import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../style/styles.dart';
import '../controller/auth_controller.dart';
import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';


class ProfileSummeryCard extends StatefulWidget {
  final bool onTapStatus;

  const ProfileSummeryCard({
    super.key,
    this.onTapStatus = true,
  });

  @override
  State<ProfileSummeryCard> createState() => _ProfileSummeryCardState();
}

class _ProfileSummeryCardState extends State<ProfileSummeryCard> {
  String imageFormat = Auth.user?.photo ?? '';

  @override
  Widget build(BuildContext context) {
    if (imageFormat.startsWith('data:image')) {
      imageFormat =
          imageFormat.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    }
    Uint8List imageInBytes = const Base64Decoder().convert(imageFormat);
    return ListTile(
      onTap: () {
        if (widget.onTapStatus == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UpdateProfileScreen()),
          );
        }
      },
      leading: Visibility(
        visible: imageInBytes.isNotEmpty,
        replacement: const CircleAvatar(
          backgroundColor: Colors.lightGreen,
          child: Icon(Icons.account_circle_outlined),
        ),
        child: CircleAvatar(
          backgroundImage: Image.memory(
            imageInBytes,
            fit: BoxFit.cover,
          ).image,
          backgroundColor: Colors.lightGreen,
        ),
      ),
      title: Text(
        userFullName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        Auth.user?.email ?? '',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: IconButton(
        onPressed: () async {
          await Auth.clearUserAuthState();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
                  (route) => false,
            );
          }
        },
        icon: const Icon(Icons.logout,color: Colors.white,),
      ),
      tileColor: PrimaryColor.color,
    );
  }

  String get userFullName {
    return '${Auth.user?.firstName ?? ''} ${Auth.user?.lastName ?? ''}';
  }
}