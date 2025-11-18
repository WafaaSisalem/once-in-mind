import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/toast.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';
import 'package:onceinmind/features/location/presentation/cubits/location_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/features/location/presentation/cubits/location_states.dart';
import 'package:onceinmind/features/location/presentation/cubits/weather_cubit.dart';

class LocationButton extends StatelessWidget {
  final Function(LocationModel location) onPressed;
  const LocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationCubit = context.read<LocationCubit>();

    return BlocConsumer<LocationCubit, LocationStates>(
      listener: (context, state) {
        if (state is LocationError) {
          showMyToast(message: state.message, context: context);
        }
        if (state is LocationLoaded) {
          onPressed(state.location);
          context.read<WeatherCubit>().getWeather(
            state.location.lat,
            state.location.lng,
          );
        }
      },
      builder: (context, state) => CustomChildFab(
        heroTag: 'btn_location',
        onPressed: () async {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Set Your Location...'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      context.pop();
                      final selected = await context.pushNamed<LocationModel>(
                        AppRoutes.location,
                      );
                      if (selected != null) {
                        await locationCubit.setSelectedLocation(
                          selected.lat,
                          selected.lng,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add_location_alt_rounded,
                      color: theme.primaryColor,
                    ),
                    label: Text(
                      'Pick a Place',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      //set up gps
                      context.pop();
                      await locationCubit.getCurrentLocation();
                    },
                    icon: Icon(Icons.gps_fixed, color: theme.primaryColor),
                    label: Text(
                      'Setup GPS',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  if (state is LocationLoaded)
                    TextButton.icon(
                      onPressed: () {
                        locationCubit.clearLocation();
                        context.pop();
                      },
                      icon: Icon(Icons.location_off, color: theme.primaryColor),
                      label: Text(
                        'Remove Location',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        child: state is LocationLoaded
            ? AppAssets.svgMapDone
            : AppAssets.svgMap,
      ),
    );
  }
}
