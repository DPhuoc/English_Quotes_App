import 'package:english_memory_app/values/app_assets.dart';
import 'package:english_memory_app/values/app_colors.dart';
import 'package:english_memory_app/values/app_styles.dart';
import 'package:english_memory_app/values/share_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initDefault();
  }

  void initDefault() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        elevation: 0,
        title: Text('Your control', style: AppStyles.h4.copyWith(color: AppColors.textColor, fontSize: 36)),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.counter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              Text('How much a number word at once',
                  style: AppStyles.h4.copyWith(
                    color: AppColors.lightGray,
                    fontSize: 18,
                  )),
              const Spacer(),
              Text('${sliderValue.toInt()}',
                  style: AppStyles.h1.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                  )),
              Slider(
                  value: sliderValue,
                  min: 5,
                  max: 100,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.primaryColor.withOpacity(0.3),
                  divisions: 95,
                  onChanged: (value) => setState(() => sliderValue = value)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.centerLeft,
                child: Text('slide to set',
                    style: AppStyles.h5.copyWith(
                      color: AppColors.textColor,
                    )),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
            ],
          )),
    );
  }
}
