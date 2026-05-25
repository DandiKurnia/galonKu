import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/user_profile_model.dart';
import 'package:galonku/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _imageFile;
  Data? _userProfile;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final response = await ProfileService().getProfile();
      if (!mounted) return;
      setState(() {
        _userProfile = response.data;
        _nameController.text = response.data.name;
        _emailController.text = response.data.email;
        _phoneController.text = response.data.phoneNumber ?? '';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ProfileService().updateProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _imageFile,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saveSuccess),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
      body: _loading || _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                SizedBox(height: 32.h),
                _saveButton(l10n),
                SizedBox(height: 24.h),
              ],
            ),
    );
  }

  Widget _avatarSection(AppLocalizations l10n) {
    final baseUrl = dotenv.env['APP_BACKEND'] ?? '';
    final remoteAvatar = _userProfile?.avatar;
    final hasRemote = remoteAvatar != null && remoteAvatar.isNotEmpty;

    ImageProvider? avatarImage;
    if (_imageFile != null) {
      avatarImage = FileImage(_imageFile!);
    } else if (hasRemote) {
      avatarImage = NetworkImage('$baseUrl$remoteAvatar');
    }

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
                    backgroundImage: avatarImage,
                    child: avatarImage == null
                        ? Icon(
                            Icons.person_rounded,
                            size: 56.h,
                            color: primaryColor,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
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
          GestureDetector(
            onTap: _pickImage,
            child: Text(
              l10n.changePhoto,
              style: headingBlueTextStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: semiBold,
              ),
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
        onPressed: _saving ? null : () => _save(l10n),
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: _saving
            ? SizedBox(
                width: 20.h,
                height: 20.h,
                child: CircularProgressIndicator(
                  color: whiteColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
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
