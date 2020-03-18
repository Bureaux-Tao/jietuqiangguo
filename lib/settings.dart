import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xdqg/flutter_counter.dart';
import 'package:xdqg/winnie.dart';

int tp;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BuildContext context;
  bool isDark;
  var brightColor = Colors.white;
  var brightTitleColor = Colors.white10;
  var darkColor = Colors.black;
  var darkTitleColor = Color.fromARGB(255, 30, 30, 30);
  var darkBgColor = Color.fromARGB(255, 53, 53, 53);

  int generalPoint;
  int todayPoint;
  int dw = 9;
  DateTime time = DateTime.now();
  SharedPreferences prefs;

  _MainScreenState();

  initData() async {
    prefs = await SharedPreferences.getInstance();
    int g = prefs.getInt('general');
    generalPoint = (g is int) ? g : 10000;
    int t = prefs.getInt('today');
    todayPoint = (t is int) ? t : 35;
    tp = todayPoint;
    int d = prefs.getInt('dw');
    dw = (d is int) ? d : 9;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    isDark = brightnessValue == Brightness.dark;

    return MaterialApp(
        theme: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
        home: Scaffold(
          backgroundColor: isDark
              ? Color.fromARGB(255, 29, 29, 29)
              : Color.fromARGB(255, 239, 239, 244),
          body: new Builder(
            builder: (context) => NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CupertinoSliverNavigationBar(
                      backgroundColor: isDark ? darkColor : brightColor,
                      largeTitle: Padding(
                        padding: const EdgeInsets.only(left: 7.5),
                        child: Text("截图强国",
                            style: TextStyle(
                                color: isDark ? brightColor : darkColor)),
                      ),
                    ),
                  ];
                },
                body: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return mainContent();
                      }),
                )),
          ),
        ));
  }

  Widget mainContent() {
    return Container(
      color: isDark ? darkColor : Color.fromARGB(255, 239, 239, 244),
      height: ScreenUtil.getInstance().screenHeight,
      child: Column(
        children: <Widget>[
          Container(
            height: 520,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: '设置',
                  tiles: [
                    SettingsTile(
                      title: '总积分',
                      subtitle: generalPoint.toString(),
                      leading: Icon(Icons.all_inclusive),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return PlatformAlertDialog(
                              title: Text('总积分'),
                              content: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 2.5, right: 2.5),
                                child: CupertinoTextField(
                                  maxLength: 5,
                                  onChanged: (value) {
                                    setState(() {
                                      generalPoint = int.parse(value);
                                    });
                                  },
                                  style: (TextStyle(
                                      color: isDark ? brightColor : darkColor)),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                ),
                              ),
                              actions: <Widget>[
                                PlatformDialogAction(
                                  child: Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PlatformDialogAction(
                                  child: Text('确定'),
                                  actionType: ActionType.Preferred,
                                  onPressed: () async {
                                    await prefs.setInt('general', generalPoint);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SettingsTile(
                      title: '今日积累',
                      subtitle: todayPoint.toString(),
                      leading: Icon(Icons.today),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return PlatformAlertDialog(
                              title: Text('今日积分'),
                              content: Center(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: Stepper()),
                              ),
                              actions: <Widget>[
                                PlatformDialogAction(
                                  child: Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PlatformDialogAction(
                                  child: Text('确定'),
                                  actionType: ActionType.Preferred,
                                  onPressed: () async {
                                    await prefs.setInt('today', tp);
                                    setState(() {
                                      todayPoint = tp;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SettingsTile(
                      title: '段位',
                      subtitle: convert(dw),
                      leading: Icon(Icons.ev_station),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return PlatformAlertDialog(
                              title: Text('段位'),
                              content: Center(
                                child: Container(
                                    height: 200,
                                    child: CupertinoPicker(
                                      backgroundColor: isDark
                                          ? Color.fromARGB(255, 26, 26, 26)
                                          : Color.fromARGB(255, 216, 216, 216),
                                      itemExtent: 40,
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          dw = value + 1;
                                        });
                                      },
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: dw - 1),
                                      children: [
                                        Text("一心一意",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("再接再厉",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("三省吾身",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("名扬四海",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("学富五车",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("六韬三略",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("七步才华",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("才高八斗",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("九天揽月",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                        Text("十年磨剑",
                                            style: TextStyle(
                                                color: isDark
                                                    ? brightColor
                                                    : darkColor)),
                                      ],
                                    )),
                              ),
                              actions: <Widget>[
                                PlatformDialogAction(
                                  child: Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PlatformDialogAction(
                                  child: Text('确定'),
                                  actionType: ActionType.Preferred,
                                  onPressed: () async {
                                    await prefs.setInt('dw', dw);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: '操作',
                  tiles: [
                    SettingsTile(
                      leading: Icon(Icons.vertical_align_top),
                      title: '增加今日积分',
                      onTap: () async {
                        generalPoint = generalPoint + todayPoint;
                        await prefs.setInt('general', generalPoint);
                        setState(() {});
                      },
                    ),
                    SettingsTile(
                      leading: Icon(Icons.vertical_align_bottom),
                      title: '减去今日积分',
                      onTap: () async {
                        generalPoint = generalPoint - todayPoint;
                        await prefs.setInt('general', generalPoint);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: '时间',
                  tiles: [
                    SettingsTile(
                      leading: Icon(Icons.access_time),
                      title: '截图时间',
                      subtitle: time.hour.toString() +
                          ":" +
                          (time.minute >= 10
                              ? time.minute.toString()
                              : "0" + time.minute.toString()),
                      onTap: () {
                        CupertinoRoundedDatePicker.show(
                          context,
                          textColor: isDark ? brightColor : darkColor,
                          background: isDark
                              ? darkBgColor
                              : Color.fromARGB(255, 249, 244, 246),
                          borderRadius: 16,
                          initialDatePickerMode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (newDateTime) {
                            setState(() {
                              time = newDateTime;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: '预览',
                  tiles: [
                    SettingsTile(
                      title: '预览',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Pic(
                            general: generalPoint.toString(),
                            today: todayPoint.toString(),
                            dw: dw,
                            time: time.hour.toString() +
                                ":" +
                                (time.minute >= 10
                                    ? time.minute.toString()
                                    : "0" + time.minute.toString()),
                            isPreview: true,
                          ),
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: isDark ? darkColor : brightTitleColor,
            width: ScreenUtil.getInstance().screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: CupertinoButton(
                color: CupertinoColors.systemBlue,
                child: Text(
                  "生  成",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  try {
                    dynamic path =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Pic(
                        general: generalPoint.toString(),
                        today: todayPoint.toString(),
                        dw: dw,
                        time: time.hour.toString() +
                            ":" +
                            (time.minute >= 10
                                ? time.minute.toString()
                                : "0" + time.minute.toString()),
                        isPreview: false,
                      ),
                    ));
                    if (path is String) {
                      print(path);
                      ShareExtend.share(path, "image");
                    } else {
                      showFailedTip();
                    }
                  } catch (e) {
                    print(e);
                    showFailedTip();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
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

  void showFailedTip() {
    showDialog<void>(
      context: this.context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: Text("失败"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("请检查访问相册权限"),
              ],
            ),
          ),
          actions: <Widget>[
            PlatformDialogAction(
              child: Text('OK'),
              actionType: ActionType.Preferred,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Stepper extends StatefulWidget {
  @override
  _StepperState createState() => _StepperState();
}

class _StepperState extends State<Stepper> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Counter(
          initialValue: tp,
          minValue: 0,
          maxValue: 100,
          step: 1,
          decimalPlaces: 1,
          onChanged: (value) {
            // get the latest value from here
            setState(() {
              tp = value;
            });
          },
        ),
      ),
    );
  }
}
