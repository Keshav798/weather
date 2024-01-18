import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/Modal/weather_modal.dart';
import 'package:weather/Services/card.dart';
import 'package:weather/Services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherPage extends StatefulWidget {
	const WeatherPage({super.key});

	@override
	State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

	
	final _weatherService = WeatherService("30aa2853d742acc9ed5dc403cd489ca2");
	
	// fetch weather
	Future<WeatherClass> fetchWeather() async {
		String cityName = await _weatherService.getCurrentCity();
		final weather = await _weatherService.getWeather(cityName);
		return weather;

	}

	String getWeatherAnimation(String? main){
		if(main==null){
			return "assets/two.json";
		}

		switch(main.toLowerCase()){
			case "clouds" :
			return  "assets/three.json";
			case "fog" :
			return  "assets/three.json";
			case "rain" :
			return  "assets/one.json";
			case "thunderstorm" :
			return  "assets/four.json";
			case "clear" :
			return  "assets/two.json";
			default :
			return  "assets/two.json";
		}
	}

	String _formatTime(int? timestamp) {
		if(timestamp==null){
			return "00:00";
		}
		DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
		return '${dateTime.hour}:${dateTime.minute}';
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: FutureBuilder(
				future: fetchWeather(),
				builder: (context,snapshot){
					if(snapshot.hasData==false){
						return Center(child: Container(child: CircularProgressIndicator(),),);
						}else if(snapshot.hasError){
							return Center(child: Text(snapshot.error.toString()));
							}else{
								WeatherClass? _weather=snapshot.data;
								return SingleChildScrollView(
										child: Container(
									padding: EdgeInsets.all(16.0),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
										WeatherInfoCard(
											title: 'Location',
											value: _weather!.name.toString(),
											icon: Icons.my_location,
											),
										WeatherInfoCard(
											title: 'Main',
											value: _weather.weather![0].main.toString(),
											icon: Icons.sunny,
											),
										Lottie.asset(getWeatherAnimation(_weather.weather![0].main.toString())),
										WeatherInfoCard(
											title: 'Temperature',
											value: _weather!.main!.temp.toString(),
											icon: WeatherIcons.thermometer,
											),
										SizedBox(height: 16),
										WeatherInfoCard(
											title: 'Description',
											value: _weather.weather![0].description.toString(),
											icon: WeatherIcons.day_fog,
											),
										SizedBox(height: 16),
										WeatherInfoCard(
											title: 'Humidity',
											value: _weather.main!.humidity.toString(),
											icon: WeatherIcons.humidity,
											),
										SizedBox(height: 16),
										WeatherInfoCard(
											title: 'Wind Speed',
											value: '${_weather.wind!.speed.toString()} m/s',
											icon: WeatherIcons.strong_wind,
											),
										SizedBox(height: 16),
										WeatherInfoCard(
											title: 'Sunrise',
											value: _formatTime(_weather.sys!.sunrise),
											icon: WeatherIcons.sunrise,
											),
										SizedBox(height: 16),
										WeatherInfoCard(
											title: 'Sunset',
											value: _formatTime(_weather.sys!.sunset),
											icon: WeatherIcons.sunset,
											),
										],
										),
									),
									);
							}
						}
						),
			);
	}
}





