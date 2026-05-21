import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: Text(
          l10n.profileAppbar,
          style: primaryTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: semiBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context, l10n),
            icon: Icon(Icons.logout_rounded, color: errorColor, size: 22.h),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        children: [
          _profileHeader(),
          SizedBox(height: 24.h),
          _sectionTitle(l10n.profileAccount),
          SizedBox(height: 8.h),
          _menuCard(children: [
            _menuItem(
              icon: Icons.person_outline_rounded,
              label: l10n.editProfile,
              onTap: () => Navigator.pushNamed(context, '/edit-profile'),
            ),
          ]),
          SizedBox(height: 20.h),
          _sectionTitle(l10n.profileGeneral),
          SizedBox(height: 8.h),
          _menuCard(children: [
            _menuItem(
              icon: Icons.help_outline_rounded,
              label: l10n.help,
              onTap: () {},
            ),
            _divider(),
            _menuItem(
              icon: Icons.lock_outline_rounded,
              label: l10n.privacyPolicy,
              onTap: () {},
            ),
            _divider(),
            _menuItem(
              icon: Icons.description_outlined,
              label: l10n.termsOfService,
              onTap: () {},
            ),
            _divider(),
            _menuItem(
              icon: Icons.star_outline_rounded,
              label: l10n.rateApp,
              onTap: () {},
            ),
          ]),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
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
              radius: 32.r,
              backgroundColor: whiteColor,
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: softColor,
                child: Icon(
                  Icons.person_rounded,
                  size: 36.h,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budi Santoso',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  'budi.santoso@email.com',
                  style: secondaryTextStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: secondaryTextStyle.copyWith(
          fontSize: 12.sp,
          fontWeight: semiBold,
        ),
      ),
    );
  }

  Widget _menuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, size: 18.h, color: primaryColor),
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: primaryTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.h,
              color: secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(height: 1, color: backgroundColor3),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        title: Text(
          l10n.logoutConfirmTitle,
          style: primaryTextStyle.copyWith(
            fontSize: 15.sp,
            fontWeight: bold,
          ),
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: secondaryTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: regular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.cancel,
              style: secondaryTextStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: semiBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/sign-in',
                (route) => false,
              );
            },
            child: Text(
              l10n.logout,
              style: errorTextStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
