
import 'package:azkar/core/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key, required this.animationController}) : super(key: key);
final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
  //  App.init(context);
    final appProvider = AppProvider.get(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: width * 0.835,
        height: height,
        child: Material(
          color: appProvider.isDark ? Colors.grey[800] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
              //    Center(child: const DrawerAppName()),
          //         ListView.builder(
          //           itemCount: DrawerUtils.items.length,
          //            itemBuilder: (context,index){
          //              return Card(
          //                color: appProvider.isDark ? Colors.grey[700] : Colors.white,
          //                child: ListTile(
          //                  title: Text( DrawerUtils.items[index]['title']),
          //                  leading: Icon(DrawerUtils.items[index]['icon']),
          //                  onTap: (){
          //                    animationController.reverse();
          //                    MainBloc.get(context).setCurrIndex(DrawerUtils.items[index]['route']);
          //                  },
          //                ),
          //              );
          //            },
          // shrinkWrap: true,
          //           // children: <Widget>[
          //           //
          //           //   Space.y1!,
          //           //   ...DrawerUtils.items.map(
          //           //     (e) => Card(
          //           //       color: appProvider.isDark ? Colors.grey[700] : Colors.white,
          //           //       child: ListTile(
          //           //         title: Text(e['title']),
          //           //         leading: Icon(e['icon']),
          //           //         onTap: (){
          //           //           animationController.reverse();
          //           //           MainBloc.get(context).setCurrIndex(e['route']);
          //           //         },
          //           //       ),
          //           //     ),
          //           //   ),
          //           //   Space.ym!,
          //           //
          //           // ],
          //         ),
              //    Row(children: [const AppVersion(),],)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
