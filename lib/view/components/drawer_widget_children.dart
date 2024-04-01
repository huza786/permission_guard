import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class NavigationDrawerHomePage extends StatelessWidget {
  const NavigationDrawerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      backgroundColor: Colors.black,
      indicatorColor: Colors.black,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 42.h, left: 90.w),
          child: Text(
            'About Us',
            //TODO:Dart mode and light mode optimization
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 181.h, left: 20.w),
          child: Text(
            softWrap: true,
            'Empowering You\nTo Control Your Privacy',
            //TODO:Dart mode and light mode optimization
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 48.h, left: 20.w, right: 10.w),
          child: Text(
            """Welcome to Privacy Guard, your trusted ally in the quest for digital privacy protection. In an era where personal data is increasingly valuable, our mission is to empower you with the tools and knowledge to safeguard your privacy on mobile devices """,
            //TODO:Dart mode and light mode optimization
            style: TextStyle(
                color: Color(0xffA5A5A5),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () async {
            //TODO:add your app link
            await Share.share('Your App Link');
          },
          child: Padding(
            padding: EdgeInsets.only(left: 85.w, right: 85.w, top: 228.h),
            child: CustomShareButton(),
          ),
        )
      ],
    );
  }
}

class CustomShareButton extends StatelessWidget {
  const CustomShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      width: 147.w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.share,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.h),
            child: Text(
              'Share',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
/**
 *  Padding(
          padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
          child: Container(
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all()),
            child: Text(
              'App Info',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: GestureDetector(
            onTap: () async {
              await Share.share('Your App Link');
            },
            child: Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all()),
              child: Text(
                'Share',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
          ),
        ), */