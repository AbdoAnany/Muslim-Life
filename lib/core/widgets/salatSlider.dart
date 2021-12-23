import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khushoo3/Features/home/presentation/manager/home_bloc/prayer_cubit/prayer_cubit.dart';
import 'package:khushoo3/core/shared/colors.dart';

import '../../Features/home/presentation/widget/azkarTapped.dart';

class sliderr1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrayerCubit, PrayerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return sliderwidget(state, context);
      },
    );
  }

  countTime(item) {
    var hours = DateTime.now().hour * 60 + DateTime.now().minute;

    var h = ((int.parse(
                '${item["Time"].toString().replaceAll('(EET)', '').split(":").first}') -
            DateTime.now().hour +
            24) %
        24);
    var m = ((int.parse(
                '${item["Time"].toString().replaceAll('(EET)', '').split(":")[1]}') -
            DateTime.now().minute +
            60) %
        60);
    var h1 = ((int.parse(
        '${item["Time"].toString().replaceAll('(EET)', '').split(":").first}')));
    var m1 = ((int.parse(
        '${item["Time"].toString().replaceAll('(EET)', '').split(":")[1]}')));
    print(h1);
    print(m1);
    print(m1 + h1 * 60);
    int a = (m1 + h1 * 60) - hours;
    if (a / 60 < 0)
      print("${(a / 60).toInt() + 24} : ${a % 60}");
    else
      print("${(a / 60).toInt()} : ${a % 60}");
    if (h == '0' && m == '0') return 'الأن حن وقت الصلاة';
    // if (h == '0') return 'باقي$mدقيقة';
    // if (m == '0') return 'باقي$h ساعة';
    return 'باقي$h ساعةو$mدقيقة';
  }

  //SliderWidget
  Widget sliderwidget(state, context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 180,
              floating: true,
              pinned: false,
              flexibleSpace: Container(child: (() {
                if (PrayerCubit.get(context).model.length > 0) {
                  return CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: false,
                        height: 170,
                        reverse: true,
                        initialPage: 0,
                        enlargeCenterPage: true,
                      ),
                      items: PrayerCubit.get(context)
                          .model
                          .map((item) => InkWell(
                                onTap: () {
                                  countTime(item);
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          Image.asset(item['Image'],
                                              fit: BoxFit.cover, width: 1000.0),
                                          Positioned(
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            200, 255, 255, 255),
                                                        Color.fromARGB(
                                                            2, 255, 255, 255)
                                                      ],
                                                      begin:
                                                          Alignment.bottomRight,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0),
                                                      child: Text(
                                                          countTime(item),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            //     fontFamily: 'GaliModern'
                                                          )),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0),
                                                      child: Text(
                                                          "${item["Salat"]}",
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'GaliModern')),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(5.0)),
                                                color: Golden.withOpacity(.6),
                                              ),
                                              child: Text(
                                                  item['Time']
                                                      .toString()
                                                      .replaceAll('(EET)', ''),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ))),
                                        ],
                                      )),
                                ),
                              ))
                          .toList());
                } else {
                  return Container(
                    height: 170,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              })()),
            ),
          ];
        },
        body: Directionality(
            textDirection: TextDirection.rtl, child: SliderList()));
  }
  //Header Time

}
