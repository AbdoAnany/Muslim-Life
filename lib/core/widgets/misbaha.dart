import 'package:azkar/Features/bloc/Sibha_cubit/misbaha_cubit.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Misbaha extends StatelessWidget {
  const Misbaha({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MisbahaCubit, MisbahaState>(builder: (context, state) {
        final vm = MisbahaCubit.get(context);
        return AppScaffold(
          title: 'السبحة',
          body: Stack(
            children: [
              Positioned(
                bottom: -250,
                left: -200,
                child: Opacity(
                    opacity: .2, child: Image.asset(StaticAssets.arabic)),
              ),
              Positioned(
                top: 50,
                left: -75,
                child: Opacity(
                  opacity: .5,
                  child: Hero(
                      tag: StaticAssets.tasbih,
                      child: Image.asset(
                        StaticAssets.tasbih,
                        width: SizeConfig.screenHeight * .4,
                      )),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(
                    horizontal: 40, vertical: SizeConfig.screenHeight * .12),
                child: Tooltip(
                    message: 'أضغط مطولا  لتصفير السبحة',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),height: 50,
                          onLongPress: () {
                            _showGroupDialog(context, vm);
                          },
                          onPressed: () {},
                          child: Text(
                            'عدد التسبيحات في المجموعة ${vm.GroubCounter}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: SizeConfig.screenHeight * .05,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'الهدف: ${vm.targetCount} — لتغير المجموعة اضغط مطولاً',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.screenHeight * .02,
                            color: Colors.black,
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),height: 50,
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight * .1),
                          onLongPress: () {
                            _showGroupDialog(context, vm);
                          },
                          onPressed: () {},
                          child: Center(
                            child: Text(
                              '${vm.Groub} عدد المجموعات ',
                              style: TextStyle(
                                  fontSize: SizeConfig.screenHeight * .035,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),height: 50,
                              padding: EdgeInsets.only(top:  SizeConfig.screenHeight * .025),
                              onLongPress: () {
                                vm.ButtonCounter = -1;
                                vm.Counter = -1;
                                vm.Clicked();
                              },
                              onPressed: () {
                                vm.Clicked();
                              },
                              child: Center(
                                child: Text(
                                  '${vm.ButtonCounter}',
                                  style: TextStyle(
                                      fontSize: SizeConfig.screenHeight * .06,
                                      color: AppTokens.brand,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),height: 50,
                              onLongPress: () {
                                vm.ButtonCounter = -1;
                                vm.Counter = -1;
                                vm.Groub = 0;
                                vm.Clicked();
                              },
                              onPressed: () {
                                vm.ButtonCounter = -1;
                                vm.Counter = -1;
                                vm.Groub = 0;
                                vm.Clicked();
                              },
                              child: Center(
                                child: Text(
                                  'صفر',
                                  style: TextStyle(
                                      fontSize: SizeConfig.screenHeight * .03,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        );
      });
  }

  void _showGroupDialog(BuildContext context, MisbahaCubit vm) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('عدد التسبحات في كل مجموعة'),
            content: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                ),
              ),
              initialValue: vm.GroubCounter.toString(),
              keyboardType: TextInputType.number,
              onChanged: (e) {
                final n = int.tryParse(e);
                if (n == null) return;
                vm.GroubCounter = n;
                vm.Changing();
              },
            ),
          );
        });
  }
}
