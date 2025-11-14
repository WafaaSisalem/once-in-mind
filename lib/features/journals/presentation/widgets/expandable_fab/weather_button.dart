import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/toast.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';
import 'package:onceinmind/features/location/presentation/cubits/weather_cubit.dart';
import 'package:onceinmind/features/location/presentation/cubits/weather_states.dart';

class WeatherButton extends StatelessWidget {
  final Function(String temperature)? onWeatherLoaded;
  const WeatherButton({super.key, this.onWeatherLoaded});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String temp = '';

        if (state is WeatherLoaded) {
          temp = state.formattedCelsius;
          onWeatherLoaded != null
              ? onWeatherLoaded!(state.formattedCelsius)
              : null;
        }
        if (state is WeatherError) {
          temp = '';
          showMyToast(message: state.message, context: context);
        }

        return CustomChildFab(
          heroTag: 'btn3',
          onPressed: () {},
          child: temp.isEmpty
              ? ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                  child: AppAssets.svgWeather,
                )
              : Text(
                  temp,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
        );
      },
    );
  }
}
