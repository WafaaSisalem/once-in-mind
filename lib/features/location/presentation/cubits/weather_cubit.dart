import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onceinmind/features/location/presentation/cubits/weather_states.dart';
import 'package:weather/weather.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> getWeather(double lat, double lng) async {
    emit(WeatherLoading());
    try {
      WeatherFactory wf = WeatherFactory(dotenv.env['WEATHER_API_KEY']!);
      Weather w = await wf.currentWeatherByLocation(lat, lng);

      double? celsius = w.temperature?.celsius;
      String formattedCelsius = '${celsius?.round()}\u2103';

      emit(WeatherLoaded(formattedCelsius));
    } catch (e) {
      emit(WeatherError("Error loading weather: $e"));
    }
  }

  setWeather(String weather) {
    if (weather.isNotEmpty) {
      emit(WeatherLoaded(weather));
    } else {
      emit(WeatherInitial());
    }
  }

  clearWeather() {
    emit(WeatherInitial());
  }
}
