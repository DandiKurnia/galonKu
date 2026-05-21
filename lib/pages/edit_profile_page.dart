import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Budi Santoso');
  final _emailController = TextEditingController(
    text: 'budi.santoso@email.com',
  );
  final _phoneController = TextEditingController(text: '+62 812 3456 7890');
  final _addressController = TextEditingController(
    text: 'Jl. Pendidikan No. 123, Jakarta Timur',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: softColor,
      appBar: AppBar(
        backgroundColor: softColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryTextColor,
            size: 20.h,
          ),
        ),
        title: Text(
          l10n.editProfileTitle,
          style: primaryTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        children: [
          _avatarSection(l10n),
          SizedBox(height: 24.h),
          _inputField(
            label: l10n.name,
            icon: Icons.person_outline_rounded,
            controller: _nameController,
          ),
          SizedBox(height: 16.h),
          _inputField(
            label: l10n.email,
            icon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),
          _inputField(
            label: l10n.phoneNumber,
            icon: Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          _inputField(
            label: l10n.address,
            icon: Icons.location_on_outlined,
            controller: _addressController,
            maxLines: 2,
          ),
          SizedBox(height: 32.h),
          _saveButton(l10n),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _avatarSection(AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(3.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundColor: whiteColor,
                  child: CircleAvatar(
                    radius: 46.r,
                    backgroundColor: softColor,
                    child: Icon(
                      Icons.person_rounded,
                      size: 56.h,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: softColor, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: whiteColor,
                      size: 16.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.changePhoto,
            style: headingBlueTextStyle.copyWith(
              fontSize: 13.sp,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: primaryTextStyle.copyWith(
            fontSize: 13.sp,
            fontWeight: semiBold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: primaryColor, size: 20.h),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  style: primaryTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: medium,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _saveButton(AppLocalizations l10n) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.saveSuccess),
              backgroundColor: successColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Text(
          l10n.save,
          style: headingTextStyle.copyWith(
            fontSize: 13.sp,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }
}
