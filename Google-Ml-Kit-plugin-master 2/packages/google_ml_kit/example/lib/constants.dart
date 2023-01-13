import 'package:flutter/material.dart';

const double kCanvasSize = 200.0;
const double kStrokeWidth = 12.0;
const Color kBlackBrushColor = Colors.black;
const bool kIsAntiAlias = true;

const int kModelInputSize = 28;
const double kCanvasInnerOffset = 40.0;

const Color kBrushBlack = Colors.black;
const Color kBrushWhite = Colors.white;

const Color kBarColor = Colors.blue;
const Color kBarBackgroundColor = Colors.transparent;
const double kChartBarWidth = 22;

const String kWaitingForInputHeaderString =
    '请在下面手写数字';
const String kWaitingForInputFooterString = '猜数字';
const String kGuessingInputString = '猜测数字是';

final Paint kDrawingPaint = Paint()
  ..strokeCap = StrokeCap.square
  ..isAntiAlias = kIsAntiAlias
  ..color = kBrushBlack
  ..strokeWidth = kStrokeWidth;

final Paint kWhitePaint = Paint()
  ..strokeCap = StrokeCap.square
  ..isAntiAlias = kIsAntiAlias
  ..color = kBrushWhite
  ..strokeWidth = kStrokeWidth;

final kBackgroundPaint = Paint()..color = kBrushBlack;
