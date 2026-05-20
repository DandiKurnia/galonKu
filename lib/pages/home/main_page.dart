import 'package:flutter/material.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/pages/home/home_page.dart';
import 'package:galonku/pages/home/location_page.dart';
import 'package:galonku/pages/home/profile_page.dart';
import 'package:galonku/pages/home/transaction_page.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softColor,
      resizeToAvoidBottomInset: false,
      floatingActionButton: scanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customeBottomNav(),
      body: body(),
    );
  }

  Widget body() {
    return switch (currentIndex) {
      0 => const HomePage(),
      1 => const LocationPage(),
      2 => const TransactionPage(),
      3 => const ProfilePage(),
      _ => const HomePage(),
    };
  }

  Widget customeBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        clipBehavior: Clip.antiAlias,
        color: whiteColor,
        child: Container(
          height: 85,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home),
                  const SizedBox(width: 20),
                  _buildNavItem(
                    1,
                    Icons.location_on_outlined,
                    Icons.location_on,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNavItem(2, Icons.receipt_outlined, Icons.receipt),
                  const SizedBox(width: 20),
                  _buildNavItem(3, Icons.person_outline, Icons.person),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
  ) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        logger.d('Bottom nav tapped: $index');
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? primaryColor : secondaryTextColor,
          size: 28,
        ),
      ),
    );
  }

  FloatingActionButton scanButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(Icons.qr_code_scanner, color: backgroundColor1),
    );
  }
}
