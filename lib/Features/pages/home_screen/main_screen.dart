import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:azkar/Bloc/app_cubit.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/model/prayer_times_model.dart';
import 'package:azkar/Features/pages/home_screen/widgets/home_location_label.dart';
import 'package:azkar/app_routes.dart';
import 'package:azkar/core/updates/app_update_checker.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_menu_tile.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:azkar/features/prayer/prayer_times_screen.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _animationController1 = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _animationController2 = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _animationController3 = AnimationController(
      duration: const Duration(seconds: 35),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _startCountdownTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateChecker.checkIfNeeded(context);
    });
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppHomeShell(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final MainBloc prayer = MainBloc.get(context);
          HijriCalendar.setLocal('ar');
          final HijriCalendar today = HijriCalendar.now();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFDFDFD),
                    Color(0xFFF8F9FA),
                    Color(0xFFF3F4F6),
                    Color(0xFFECF0F1),
                    Color(0xFFE8EAED),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BasePatternPainter(),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _animationController1,
                        _animationController2,
                        _animationController3,
                        _pulseController,
                        _sparkleController,
                      ]),
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _EnhancedBackgroundPainter(
                            animation1: _animationController1.value,
                            animation2: _animationController2.value,
                            animation3: _animationController3.value,
                            pulseAnimation: _pulseController.value,
                            sparkleAnimation: _sparkleController.value,
                          ),
                          size: Size.infinite,
                        );
                      },
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildMainPrayerCard(prayer, today),
                          const SizedBox(height: 32),
                          _buildNavigationGrid(context),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, _) {
        final List<ApiModel> menu = AppCubit.get(context).menuList;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: menu.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) =>
              _buildNavigationItem(context, menu[index]),
        );
      },
    );
  }

  Widget _buildNavigationItem(BuildContext context, ApiModel item) {
    final imagePath = 'assets/images/${item.photo}';
    return AppMenuTile(
      label: item.title,
      imagePath: imagePath,
      onTap: () => AppRoutes.openAction(context, item),
    );
  }

  Widget _buildMainPrayerCard(MainBloc prayer, HijriCalendar today) {
    final DateTime nowDate = DateTime.now();

    if (prayer.prayList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTokens.brand,
              AppTokens.brandDark,
              Color(0xFF066666),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
        child: Text(
          prayer.textState,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PrayerTimesScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTokens.brand,
              AppTokens.brandDark,
              Color(0xFF066666),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppTokens.brand.withOpacity(0.3),
              blurRadius: 15,
              offset: ui.Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _IslamicPatternPainter(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            formatPrayerLocationLabel(
                              prayer.prayList.first.meta?.timezone,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${today.hDay} ${today.getLongMonthName()} ${today.hYear} هـ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'اليوم: ${today.getDayName()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Text(
                            'الموافق: ${nowDate.day}/${nowDate.month}/${nowDate.year} م',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  MainBloc.currentPray?.arabicName ?? 'الفجر',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  _formatTimeTo12Hour(
                                    MainBloc.currentPray?.time ?? '00:00',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getTimeRemaining(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Text(
                                'متبقي للصلاة التالية',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (prayer.timingsList.length > 5)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: prayer.timingsList
                            .sublist(0, 6)
                            .map(
                              (timings) => Expanded(
                                child: _buildCompactPrayerTime(timings!),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactPrayerTime(PrayerTimeModel prayer) {
    final bool isCurrentPrayer =
        MainBloc.currentPray?.englishName == prayer.englishName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          prayer.arabicName!,
          style: TextStyle(
            color: isCurrentPrayer ? Colors.white : Colors.white70,
            fontSize: 10,
            fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          _formatTimeTo12Hour(prayer.time!),
          style: TextStyle(
            color: isCurrentPrayer ? Colors.white : Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getTimeRemaining() {
    if (MainBloc.nextPray == null) return 'غير متاح';

    try {
      final timeStr = MainBloc.sanitizePrayerTime(MainBloc.nextPray!.time);
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) return 'غير متاح';

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) return 'غير متاح';

      final now = DateTime.now();
      var nextPrayerDateTime =
          DateTime(now.year, now.month, now.day, hour, minute);

      if (nextPrayerDateTime.isBefore(now)) {
        nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
      }

      final difference = nextPrayerDateTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      if (hours > 0) {
        return '$hours س $minutes د';
      } else if (minutes > 0) {
        return '$minutes د $seconds ث';
      } else {
        return '$seconds ث';
      }
    } catch (e) {
      return 'غير متاح';
    }
  }

  String _formatTimeTo12Hour(String time24) {
    try {
      final timeStr = MainBloc.sanitizePrayerTime(time24);
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) return time24;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) return time24;

      final period = hour >= 12 ? 'م' : 'ص';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final minuteStr = minute.toString().padLeft(2, '0');
      final hour12Str = hour12.toString().padLeft(2, '0');
      return '$hour12Str:$minuteStr $period';
    } catch (e) {
      return time24;
    }
  }
}

class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity( 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
      ui.Offset(size.width * 0.8, size.height * 0.2),
      30,
      paint,
    );

    canvas.drawCircle(
      ui.Offset(size.width * 0.2, size.height * 0.8),
      20,
      paint,
    );

    paint.strokeWidth = 0.5;
    final path = Path();
    path.moveTo(size.width - 40, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 40);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BasePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4DB6AC).withOpacity( 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 60.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        ui.Offset(i, 0),
        ui.Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        ui.Offset(0, i),
        ui.Offset(size.width, i),
        paint,
      );
    }

    paint.color = const Color(0xFF26A69A).withOpacity( 0.12);
    _drawIslamicGeometry(canvas, size, paint);
  }

  void _drawIslamicGeometry(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final x = centerX + 100 * math.cos(angle);
      final y = centerY + 100 * math.sin(angle);
      canvas.drawCircle(ui.Offset(x, y), 60, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EnhancedBackgroundPainter extends CustomPainter {
  final double animation1;
  final double animation2;
  final double animation3;
  final double pulseAnimation;
  final double sparkleAnimation;

  _EnhancedBackgroundPainter({
    required this.animation1,
    required this.animation2,
    required this.animation3,
    required this.pulseAnimation,
    required this.sparkleAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint1 = Paint()
      ..color = const Color(0xFF4DB6AC)
          .withOpacity( 0.12 + 0.08 * pulseAnimation)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final glowPaint2 = Paint()
      ..color = const Color(0xFF26A69A)
          .withOpacity( 0.10 + 0.06 * pulseAnimation)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final orb1 = ui.Offset(
      size.width * 0.2 + math.sin(animation1 * 2 * math.pi) * 80,
      size.height * 0.3 + math.cos(animation1 * 2 * math.pi) * 50,
    );
    canvas.drawCircle(orb1, 60 + 20 * pulseAnimation, glowPaint1);

    final orb2 = ui.Offset(
      size.width * 0.8 + math.cos(animation2 * 2 * math.pi) * 90,
      size.height * 0.7 + math.sin(animation2 * 2 * math.pi) * 60,
    );
    canvas.drawCircle(orb2, 70 + 15 * pulseAnimation, glowPaint2);

    final particlePaint = Paint()
      ..color = const Color(0xFF00796B).withOpacity( 0.25)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final starOffset = ui.Offset(
        size.width * (0.1 + 0.8 * ((i + sparkleAnimation) % 1)),
        size.height * (0.1 + 0.8 * ((i * 0.7 + sparkleAnimation) % 1)),
      );
      _drawStar(canvas, starOffset,
          2 + 1 * math.sin(sparkleAnimation * 2 * math.pi + i), particlePaint);
    }

    final wavePaint = Paint()
      ..color = const Color(0xFF4DB6AC).withOpacity( 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x += 15) {
      final y = size.height * 0.5 +
          20 * math.sin((x / size.width + animation3) * 3 * math.pi) +
          10 * math.sin((x / size.width + animation3 * 1.2) * 6 * math.pi);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, wavePaint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x += 15) {
      final y = size.height * 0.7 +
          15 * math.sin((x / size.width - animation3) * 4 * math.pi) +
          8 * math.sin((x / size.width - animation3 * 1.5) * 8 * math.pi);
      path2.lineTo(x, y);
    }
    canvas.drawPath(path2, wavePaint);
  }

  void _drawStar(Canvas canvas, ui.Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const outerRadius = 1.0;
    const innerRadius = 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points - math.pi / 2;
      final r = (i % 2 == 0) ? outerRadius : innerRadius;
      final x = center.dx + radius * r * math.cos(angle);
      final y = center.dy + radius * r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
