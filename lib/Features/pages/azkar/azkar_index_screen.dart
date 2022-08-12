import 'dart:ui';

import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/widgets/custom_image.dart';
import 'package:azkar/core/widgets/flare.dart';
import 'package:azkar/core/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


import 'azkar_widget/azkar_item.dart';

class AzkarIndexScreen extends StatelessWidget {
  const AzkarIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //App.init(context);
    final appProvider = Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<AzkarCubit, AzkarState>(
      listener: (context, state) {},
      builder: (context, state) {
        AzkarCubit azkarCubit = AzkarCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor:
                    appProvider.isDark ? Colors.grey[850] : Colors.white,
                body: Stack(

                  children: <Widget>[

                    Positioned(bottom:-200 ,left: -200,
                      child: Opacity(opacity: .2,
                          child: Image.asset(StaticAssets.arabic)),
                    ),
                    Opacity(
                      opacity: .3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Hero(
                            tag:   StaticAssets.pray,
                            child: Image.asset(
                              StaticAssets.pray,
                              height: MediaQuery.of(context).size.height * 0.22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const CustomTitle(
                      title: 'أذكار حصن المسلم',

                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.17,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: TextFormField(
                        controller:azkarCubit.Azkarcontroller ,
                        onChanged: (value) {
                          azkarCubit.searchstate();
                        },style:      TextStyle(
                        fontSize:  MediaQuery.of(context).size.height * 0.03,
                      ),
                        decoration: InputDecoration(
                          //  contentPadding: Space.h,


                          hintText: 'أبحث عن الذكر هنا',
                          hintStyle:  TextStyle(
                            fontSize:  MediaQuery.of(context).size.height * 0.02,
                          ),

                          //   hintStyle: AppText.b2!.copyWith(

                          //    color: AppTheme.c!.textSub2,
                          //  ),
                          prefixIcon: Icon(
                            Icons.search,
                            //  color: AppTheme.c!.textSub2,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              //   color: AppTheme.c!.textSub2!,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              //     color: AppTheme.c!.textSub2!,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),


                    if (azkarCubit.azkarCategoriesList!.isNotEmpty)
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.25,
                          ),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => AzkarItem(
                                item:azkarCubit.Azkarcontroller.text.isEmpty? azkarCubit.azkarCategoriesList![index]:
                                azkarCubit.filteredList[index]
                            ),

                            itemCount: azkarCubit.Azkarcontroller.text.isEmpty? azkarCubit.azkarCategoriesList!.length:
                            azkarCubit.filteredList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,crossAxisSpacing: 3),
                          )

                      ),
                    Positioned(   top: 20,right: 0,

                        child:   Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            IconButton(icon: Icon(Icons.arrow_back_outlined,color: kMainColor),onPressed: (){Navigator.of(context).pop();},),

                            Slider(
                              onChanged: (value) {


                                appProvider.fontSize  = value;
                                azkarCubit.emit(AzkarSearchLoading());
                              },
                              max: 0.07,
                              min: 0.01,
                              value:   appProvider.fontSize,
                            ),
                          ],
                        )),

                  ],
                ),
              )),
        );
      },
    );
  }
}
