import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Calender(
            width: 200,
            height: 400,
            saturdayTextColor: Colors.blue,
            sundayTextColor: Colors.red,
            todayColor: Colors.green,
          ),
        ),
      ),
    );
  }
}

class Calender extends StatefulWidget {
  Calender({
    Key? key,
    required this.width,
    required this.height,
    this.saturdayTextColor = Colors.black,
    this.sundayTextColor = Colors.red,
    this.todayColor = Colors.blue,
  }) : super(key: key);

  double width;
  double height;
  Color? saturdayTextColor;
  Color? sundayTextColor;
  Color? todayColor;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  var week = ["일", "월", "화", "수", "목", "금", "토"];

  int year = 0;
  int month = 0;
  List days = [];
  int weekNumber = 0;

  setFirst(int setYear, int setMonth) {
    year = setYear;
    month = setMonth;
    insertDays(year, month);
  }

  insertDays(int year, int month) {
    days.clear();

    weekNumber = ((DateTime(year, month, 1).weekday % 7 +
                DateTime(year, month + 1, 0).day) /
            7.0)
        .ceil();

    int lastDay = DateTime(year, month + 1, 0).day;
    for (var i = 1; i <= lastDay; i++) {
      days.add({
        "year": year,
        "month": month,
        "day": i,
        "inMonth": true,
        "picked": false,
      });
    }

    if (DateTime(year, month, 1).weekday != 7) {
      var temp = [];
      int prevLastDay = DateTime(year, month, 0).day;
      for (var i = DateTime(year, month, 1).weekday - 1; i >= 0; i--) {
        temp.add({
          "year": year,
          "month": month - 1,
          "day": prevLastDay - i,
          "inMonth": false,
          "picked": false,
        });
      }
      days = [...temp, ...days];
    }

    var temp = [];
    for (var i = 1; i <= weekNumber * 7 - days.length; i++) {
      temp.add({
        "year": year,
        "month": month + 1,
        "day": i,
        "inMonth": false,
        "picked": false,
      });
    }

    days = [...days, ...temp];
  }

  Color? getDayOfWeekTextColor(int index) {
    if (index % 7 == 0) {
      return widget.sundayTextColor;
    } else if (index % 7 == 6) {
      return widget.saturdayTextColor;
    } else {
      return Colors.black;
    }
  }

  bool isToday(int year, int month, int day) {
    DateTime now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  @override
  void initState() {
    setFirst(DateTime.now().year, DateTime.now().month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.width / 25),
            height: widget.height / 14 + widget.width / 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < week.length; i++)
                  Text(
                    week[i],
                    style: TextStyle(
                      color: i == 0
                          ? widget.sundayTextColor
                          : i == week.length - 1
                              ? widget.saturdayTextColor
                              : Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: widget.width / 14,
                      height: (28 / 14),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: widget.width,
              child: GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  mainAxisExtent: (widget.height * 13 / 14) / weekNumber,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: widget.width / 7,
                        height: widget.width / 7,
                        decoration: isToday(days[index]["year"],
                                days[index]["month"], days[index]["day"])
                            ? BoxDecoration(
                                color: widget.todayColor,
                                borderRadius:
                                    BorderRadius.circular(widget.width / 14),
                              )
                            : null,
                        child: Center(
                          child: Text(
                            days[index]["day"].toString(),
                            style: TextStyle(
                              color: days[index]["inMonth"]
                                  ? getDayOfWeekTextColor(index)
                                  : Colors.grey,
                              fontSize: widget.width / 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
