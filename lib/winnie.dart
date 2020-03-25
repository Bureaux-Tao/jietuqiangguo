import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:native_screenshot/native_screenshot.dart';

class Pic extends StatelessWidget {
  String general;
  String today;
  int dw;
  bool isPreview;
  String time;
  Pic({this.general, this.today, this.dw, this.time, this.isPreview});

  @override
  Widget build(BuildContext context) {
    if (isPreview != true) {
      takeScreenShot(context);
    }
    List<Widget> groupStar = [];
    for (int i = 0; i < 10; i++) {
      if (i < dw)
        groupStar.add(Image(
          height: 11.4,
          width: 11.4,
          image: AssetImage("assets/s.png"),
        ));
      else
        groupStar.add(Image(
          height: 11.4,
          width: 11.4,
          image: AssetImage("assets/uns.png"),
        ));
    }
    Row row = Row(
      children: groupStar.toList(),
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
          height: ScreenUtil.getInstance().screenHeight,
          width: ScreenUtil.getInstance().screenWidth,
          child: Stack(
            children: <Widget>[
              Image(
                height: ScreenUtil.getInstance().screenHeight,
                width: ScreenUtil.getInstance().screenWidth,
                image: AssetImage("assets/IMG_6405.jpg"),
              ),
              Positioned(
                left: (int.parse(general) >= 10000)
                    ? 130
                    : (int.parse(general) >= 1000) ? 140 : 152,
                top: 122,
                child: Text(general,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 248, 243, 221),
                      fontSize: 45,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                      fontWeight: FontWeight.w300,
                    )),
              ),
              Positioned(
                left: 180,
                top: 175,
                child: Text(convert(dw),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 248, 243, 221),
                      fontSize: 12.5,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                      fontWeight: FontWeight.w300,
                    )),
              ),
              Positioned(
                left: 319,
                top: 331,
                child: Text(today + "积分",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
//                        fontWeight: FontWeight.w100,
                        fontFamily: "FZTYSJW")),
              ),
              Positioned(left: 129, top: 192, child: row),
              Positioned(
                left: 30,
                top: 15,
                child: Text(time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.5,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      decorationColor: Colors.transparent,
                    )),
              ),
            ],
          )),
    );
  }

  takeScreenShot(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 500), () async {
      String path = await NativeScreenshot.takeScreenshot();
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pop(path);
      });
    });
  }

  String convert(int value) {
    String r = "";
    switch (value) {
      case 1:
        r = "一心一意";
        break;
      case 2:
        r = "再接再厉";
        break;
      case 3:
        r = "三省吾身";
        break;
      case 4:
        r = "名扬四海";
        break;
      case 5:
        r = "学富五车";
        break;
      case 6:
        r = "六韬三略";
        break;
      case 7:
        r = "七步才华";
        break;
      case 8:
        r = "才高八斗";
        break;
      case 9:
        r = "九天揽月";
        break;
      case 10:
        r = "十年磨剑";
        break;
    }
    return r;
  }
}
