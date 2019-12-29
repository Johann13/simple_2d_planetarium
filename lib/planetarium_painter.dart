import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations/animation_progress.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';
import 'package:simple_animations/simple_animations/rendering.dart';

class Planetarium extends StatefulWidget {
  @override
  _PlanetariumState createState() => _PlanetariumState();
}

class _PlanetariumState extends State<Planetarium>
    with SingleTickerProviderStateMixin {
  double r = 1.0;
  double s = 0.0;
  List<System> list;

  @override
  void initState() {
    super.initState();
    list = generateSystems(duration: Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Rendering(
            startTime: Duration(seconds: 30),
            onTick: _reset,
            builder: (context, time) {
              return CustomPaint(
                painter: _PPainter(list, time, r, s),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.of(context).size.width * (1 / 3),
          height: MediaQuery.of(context).size.height * 0.9,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Text('Distance to the Sun'),
              Row(
                children: <Widget>[
                  Text('Less Realistic'),
                  Slider(
                    label: 'Distance to the Sun',
                    value: r,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() {
                        r = v;
                      });
                    },
                  ),
                  Text('Somewhat Realisic'),
                ],
              ),
              Text('Planet Radius'),
              Row(
                children: <Widget>[
                  Text('Less Realistic'),
                  Slider(
                    label: 'Planet Radius',
                    value: s,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() {
                        s = v;
                      });
                    },
                  ),
                  Text('Somewhat Realisic'),
                ],
              ),
              Text('This is a very simplefied Planetarium. '
                  'It shows the motion of the 8 Planets in the Solar System relative to each other. '
                  'Earth needs 5 seconed for one orbit.'),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  System sys = list[index];
                  SystemData sysData = sys.system;
                  PlanetData data = sysData.data;
                  return ListTile(
                    title: Text('${data.name}'),
                    subtitle: Text(
                        'Orbital Period: ${sysData.duration.inSeconds}s\n'
                            'Real Orbital Periode: ${data.orbitalPeriodInDays}days'),
                    isThreeLine: true,
                  );
                },
                itemCount: list.length,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<System> generateSystems(
      {Duration duration = const Duration(seconds: 5)}) {
    return [
      System(
        SystemData(
          PlanetData(
            'Mercury',
            planetRadius: 2440,
            orbitalPeriodInDays: 87.969,
            orbitalSpeedInKms: 35.02,
          ),
          color: Colors.orangeAccent,
          relativeDistanceToSun: 0.5,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Venus',
            planetRadius: 6051.8,
            orbitalPeriodInDays: 224.701,
            orbitalSpeedInKms: 35.02,
          ),
          color: Colors.orangeAccent[100],
          relativeDistanceToSun: 1.0,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Earth',
            planetRadius: 6371.0,
            orbitalPeriodInDays: 365.256363004,
            orbitalSpeedInKms: 29.78,
          ),
          color: Colors.blue,
          relativeDistanceToSun: 1.5,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Mars',
            planetRadius: 3389.5,
            orbitalPeriodInDays: 686.971,
            orbitalSpeedInKms: 24.007,
          ),
          color: Colors.red,
          relativeDistanceToSun: 2.0,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Jupiter',
            planetRadius: 69911,
            orbitalPeriodInDays: 4332.59,
            orbitalSpeedInKms: 13.07,
          ),
          color: Colors.amber,
          relativeDistanceToSun: 2.5,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Saturn',
            planetRadius: 58232,
            orbitalPeriodInDays: 10759.22,
            orbitalSpeedInKms: 9.68,
          ),
          color: Colors.amber[700],
          relativeDistanceToSun: 3.0,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Uranus',
            planetRadius: 25362,
            orbitalPeriodInDays: 30688.5,
            orbitalSpeedInKms: 6.80,
          ),
          color: Colors.lightBlueAccent[200],
          relativeDistanceToSun: 3.5,
          standardDuration: duration,
        ),
      ),
      System(
        SystemData(
          PlanetData(
            'Neptune',
            planetRadius: 24622,
            orbitalPeriodInDays: 60182,
            orbitalSpeedInKms: 5.43,
          ),
          color: Colors.lightBlue[800],
          standardDuration: duration,
          relativeDistanceToSun: 4,
        ),
      ),
    ];
  }

  _reset(Duration time) {
    list.forEach((d) => d.maintainRestart(time));
  }
}

class _PPainter extends CustomPainter {
  final Duration time;
  final List<System> systems;
  final double r;
  final double s;

  _PPainter(this.systems, this.time, this.r, this.s);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        Paint()..color = Colors.black);
    _drawSun(canvas, size);
    systems.forEach((d) => d.draw(canvas, size, time, r, s));
  }

  void _drawSun(Canvas canvas, Size size) {
    double radius = (0.1 * 109.3 * s) + (10 * (1 - s));
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10,
        Paint()..color = Colors.yellow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class System {
  final SystemData system;
  Animatable tween;
  AnimationProgress animationProgress;

  System(this.system) {
    restart();
  }

  void draw(Canvas canvas, Size size, Duration time, double r, double s) {
    _drawCircle(canvas, size, r);
    _drawPlanet(canvas, size, time, r, s);
  }

  void _drawPlanet(
      Canvas canvas, Size size, Duration time, double r, double s) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = system.color;
    Offset center = Offset(size.width / 2, size.height / 2);
    var progress = animationProgress.progress(time);
    final animation = tween.transform(progress);
    double p = animation['progress'];
    double x = -math.sin(math.pi * p) * system.getDistanceToSun(r: r);
    double y = -math.cos(math.pi * p) * system.getDistanceToSun(r: r);
    canvas.drawCircle(center + Offset(x, y), system.getRadius(r: s), paint);
  }

  void _drawCircle(Canvas canvas, Size size, double r) {
    final Paint _paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1;
    Offset offset = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(offset, system.getDistanceToSun(r: r), _paint);
  }

  void restart({Duration time = Duration.zero}) {
    tween = MultiTrackTween([
      Track("progress").add(
        system.duration,
        Tween<double>(
          begin: -1,
          end: 1,
        ),
        curve: Curves.linear,
      ),
    ]);
    animationProgress = AnimationProgress(
      duration: system.duration,
      startTime: time,
    );
  }

  void maintainRestart(Duration time) {
    if (animationProgress != null) {
      if (animationProgress.progress(time) == 1.0) {
        restart(time: time);
      }
    }
  }
}

class SystemData {
  final PlanetData data;
  final Color color;
  final double _astronomicalUnitKm = 149597870.700;
  final double _earthRadius = 6371.0;
  final double _earthDuration = 365.256363004;
  final double relativeRadius;
  final double relativeDistanceToSun;
  final Duration standardDuration;

  SystemData(
    this.data, {
    this.relativeRadius = 10.0,
    this.color = Colors.white,
    this.relativeDistanceToSun = 1.0,
    this.standardDuration = const Duration(seconds: 5),
  });

  double get earthDistanceToSun => data.distanceToSun / _astronomicalUnitKm;

  double get earthRadius => data.planetRadius / _earthRadius;

  double getDistanceToSun({double r = 1.0}) {
    return (100 * earthDistanceToSun * r) +
        (50 * relativeDistanceToSun * (1 - r));
  }

  double getRadius({double r = 1.0}) {
    return (10.0 * earthRadius * r) + (relativeRadius * (1 - r));
  }

  Duration get duration =>
      standardDuration * (data.orbitalPeriodInDays / _earthDuration);
}

class PlanetData {
  final String name;
  final double orbitalPeriodInDays;
  final double orbitalSpeedInKms;
  final double planetRadius;

  PlanetData(
    this.name, {
    @required this.planetRadius,
    @required this.orbitalPeriodInDays,
    @required this.orbitalSpeedInKms,
  });

  double get _orbitalSpeedInKmd => orbitalSpeedInKms * (60 * 60 * 24);

  double get circumference => _orbitalSpeedInKmd * orbitalPeriodInDays;

  double get distanceToSun => circumference / (2 * math.pi);

  @override
  String toString() {
    return '$name, planetRadius:$planetRadius, distanceToSun:$distanceToSun';
  }
}
