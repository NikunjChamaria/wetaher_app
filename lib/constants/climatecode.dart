String getWeatherConditionImageasset(String conditionCode) {
  switch (conditionCode) {
    case '01d': // clear sky (day)
      return 'assets/clearsky(day).webp';
    case '01n': // clear sky (night)
      return 'assets/clearsky(night).jpeg';
    case '02d': // few clouds (day)
      return 'assets/fewclouds(day).jpg';
    case '02n': // few clouds (night)
      return 'assets/fewclouds(night).jpg';
    case '03d': // scattered clouds (day)
      return 'assets/scatteredclouds(day).jpg';
    case '03n': // scattered clouds (night)
      return 'assets/scatteredclouds(night).jpg';
    case '04d': // broken clouds (day)
      return 'assets/brokenclouds(day).jpeg';
    case '04n': // broken clouds (night)
      return 'assets/brokenclouds(night).jpg';
    case '09d': // shower rain (day)
      return 'assets/showerrain(day).jpg';
    case '09n': // shower rain (night)
      return 'assets/showerrain(night).webp';
    case '10d': // rain (day)
      return 'assets/rain(day).jpg';
    case '10n': // rain (night)
      return 'assets/rain(night).jpeg';
    case '11d': // thunderstorm (day)
      return 'assets/thunderstorm(day).webp';
    case '11n': // thunderstorm (night)
      return 'assets/thunderstorm(night).jpg';
    case '13d': // snow (day)
      return 'assets/snow(day).jpeg';
    case '13n': // snow (night)
      return 'assets/snow(night).jpg';
    case '50d': // mist or fog
      return 'assets/mistorfog.jpg';
    case '50n': // mist or fog (night)
      return 'assets/mistorfog(night).jpg';
    case '51d': // drizzle (day)
      return 'assets/drizzle(day).jpg';
    case '51n': // drizzle (night)
      return 'assets/drizzle(night).jpg';
    case '52d': // heavy intensity drizzle (day)
      return 'assets/heavyintensitydrizzle(day).jpg';
    case '52n': // heavy intensity drizzle (night)
      return 'assets/heavyintensitydrizzle(night).jpg';
    case '53d': // mist (day)
      return 'assets/mist(day).jpg';
    case '53n': // mist (night)
      return 'assets/mist(night).jpeg';
    case '54d': // haze (day)
      return 'assets/haze(day).jpeg';
    case '54n': // haze (night)
      return 'assets/haze(night).jpg';
    case '55d': // sand/dust whirls (day)
      return 'assets/sanddustwhirls(day).jpg';
    case '55n': // sand/dust whirls (night)
      return 'assets/sanddustwhirls(night).jpg';
    default:
      return 'assets/images/default.jpg';
  }
}
