import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insidersapp/src/pages/main/search/bloc/trending_strategy_cubit.dart';
import 'package:insidersapp/src/pages/main/search/trending_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:insidersapp/src/theme/app_theme.dart';
import 'package:insidersapp/src/theme/colors.dart';

class StrategiesTopTwentyPage extends StatelessWidget {
  const StrategiesTopTwentyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.top20Strategies,
          style: AppFonts.body.copyWith(color: AppColors.involioWhiteShades80),
        ),
      ),
      body: BlocProvider(
        create: (context) => TrendingStrategyCubit(pageSize: 20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    AppLocalizations.of(context)!.trendingStrategies,
                    style: AppFonts.headline6
                        .copyWith(color: AppColors.involioWhiteShades60),
                  )),
              const Expanded(
                child: TrendingStrategyList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
