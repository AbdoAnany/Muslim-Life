import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
import 'package:azkar/Features/widget/title_appbar.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'azkar_widget/azkar_item.dart';

class AzkarIndexScreen extends StatelessWidget {
  const AzkarIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AzkarCubit, AzkarState>(
      listener: (context, state) {},
      builder: (context, state) {
        AzkarCubit azkarCubit = AzkarCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: TitleAppBar(title: 'أذكار حصن المسلم'),

                backgroundColor:  Colors.white,
                body: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      bottom: -200,
                      left: -200,
                      child: Opacity(
                          opacity: .2, child: Image.asset(StaticAssets.arabic)),
                    ),
                    Positioned(
                      left: 20,top: 0,
                      child: Opacity(
                      opacity: .3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child:  Hero(
                            tag: StaticAssets.pray,
                            child: Image.asset(
                              StaticAssets.pray,
                              height:SizeConfig.screenHeight* 0.22,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.012,
                        left:SizeConfig.screenWidth  * 0.05,
                        right: SizeConfig.screenWidth  * 0.05,
                      ),
                      child: TextFormField(
                        controller: azkarCubit.azkarController,
                        onChanged: (value) {
                          azkarCubit.searchState();
                        },
                        onSaved: (e){
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (e){
                          FocusScope.of(context).unfocus();
                        },
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03,),
                        decoration: InputDecoration(
                          hintText: 'أبحث عن الذكر هنا',
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02,),
                          prefixIcon: Icon(Icons.search,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                        ),
                      ),
                    ),
                    if (azkarCubit.azkarNewList!.isNotEmpty)
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.08,
                          ),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => AzkarItemNew(
                                item: azkarCubit.filteredNewList![index]),
                            itemCount: azkarCubit.filteredNewList!.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3),
                          )),
                  ],
                ),
              )),
        );
      },
    );
  }
}
