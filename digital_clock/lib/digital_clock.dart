// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(seconds: 1),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final sec = DateFormat('ss').format(_dateTime);

    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return _myTimeWidget(hour, minute, sec, defaultStyle, colors);
//    return Container(
//      color: colors[_Element.background],
//      child: Center(
//        child: DefaultTextStyle(
//          style: defaultStyle,
//          child: Stack(
//            children: <Widget>[
//              Positioned(left: offset, top: 0, child: Text(hour)),
//              Positioned(right: offset, bottom: offset, child: Text(minute)),
//            ],
//          ),
//        ),
//      ),
//    );
  }

  Widget _myTimeWidget(String hour, String minute, String sec,
      TextStyle defaultStyle, Map<_Element, Color> colors) {
    return new Container(
      color: colors[_Element.background],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: _timeWidget(
                  hour, Colors.lightBlueAccent, "Hour", Colors.black12)),
          Expanded(
              child: _timeWidget(
                  minute, Colors.lightBlueAccent, "Minute", Colors.black12)),
          Expanded(
              child: _timeWidget(
                  sec, Colors.pinkAccent, "Second", Colors.black12)),
        ],
      ),
    );
  }

  Widget _timeWidget(
      String time, Color colors, String bottonText, Color bottomOpticity) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16.0),
        child: Card(
          color: colors,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      showTimeText(time),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      showBottomText(bottomOpticity, bottonText)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Container showBottomText(Color bottomOpticity, String bottonText) {
    return Container(
      alignment: Alignment.bottomCenter,
      color: bottomOpticity,
      padding: EdgeInsets.all(16.0),
      child: Text(
        bottonText,
        style: TextStyle(
            color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.w200),
      ),
    );
  }

  Container showTimeText(String time) {
    return Container(
      child: Text(
        time.length == 1 ? "0" + time : time,
        style: TextStyle(
          fontSize: 122.0,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
      ),
    );
  }
}
