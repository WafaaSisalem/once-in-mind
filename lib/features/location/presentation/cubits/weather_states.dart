abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String formattedCelsius;
  WeatherLoaded(this.formattedCelsius);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
