String getWeatherConditionImageUrl(String conditionCode) {
  switch (conditionCode) {
    case '01d': // clear sky (day)
      return 'https://cdn.shopify.com/s/files/1/0904/4526/articles/316942-blue-sky-with-clouds.jpg?v=1605136872';
    case '01n': // clear sky (night)
      return 'https://images.unsplash.com/photo-1648691962150-344586df7fd5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2xlYXIlMjBuaWdodCUyMHNreXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80';
    case '02d': // few clouds (day)
      return 'https://media.istockphoto.com/id/171225633/photo/deep-blue-view-on-a-lightly-clouded-day.jpg?s=612x612&w=0&k=20&c=KGV9ieDdP5wgx9unc_HwHmP5wuRmpgyDSA0h-3_gNNo=';
    case '02n': // few clouds (night)
      return 'https://motionarray.imgix.net/preview-74201-q74s767tIl_0009.jpg?w=660&q=60&fit=max&auto=format';
    case '03d': // scattered clouds (day)
      return 'https://c0.wallpaperflare.com/preview/532/447/657/scattered-white-clouds.jpg';
    case '03n': // scattered clouds (night)
      return 'https://i.pinimg.com/originals/8f/4b/87/8f4b8766a0f8b30a9aaab5438f18aec7.jpg';
    case '04d': // broken clouds (day)
      return 'https://qph.cf2.quoracdn.net/main-qimg-0a5c39ad8e91540277cefe6f984390e2-lq';
    case '04n': // broken clouds (night)
      return 'https://i.pinimg.com/originals/36/0f/f0/360ff076c9dff58b067937278dc87e3f.jpg';
    case '09d': // shower rain (day)
      return 'https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/images/weather/learn-about/weather/rain-storm.jpg';
    case '09n': // shower rain (night)
      return 'https://thumbs.dreamstime.com/b/rainy-evening-city-people-walking-umbrella-under-rain-tallinn-old-town-rainy-season-blur-light-rainy-evening-171060147.jpg';
    case '10d': // rain (day)
      return 'https://images.pexels.com/photos/1463530/pexels-photo-1463530.jpeg?cs=srgb&dl=pexels-bibhukalyan-acharya-1463530.jpg&fm=jpg';
    case '10n': // rain (night)
      return 'https://images.unsplash.com/photo-1518182170546-07661fd94144?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmFpbnklMjBuaWdodHxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80';
    case '11d': // thunderstorm (day)
      return 'https://cdn.britannica.com/62/158162-050-9FDE49B4/thunderstorm-and-lightning.jpg';
    case '11n': // thunderstorm (night)
      return 'https://images.twnmm.com/c55i45ef3o2a/2G5E2fF7Gq157ArpZ6rxLf/6d5618060811c55dc447c8245d845a60/noaa-QO4Y97jiVDQ-unsplash.jpg';
    case '13d': // snow (day)
      return 'https://images.unsplash.com/photo-1589218112660-81ef972e89e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c25vdyUyMGRheXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80';
    case '13n': // snow (night)
      return 'https://media.istockphoto.com/id/876950056/photo/free-area-in-winter-snowy-woods.jpg?s=612x612&w=0&k=20&c=0nL35r6G3xehWLzO80ivydiahBEb13YPmJrhJmDBIqk=';
    case '50d': // mist or fog
      return 'https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/weather/fog--mist/foggy-morning-in-a-meadow.jpg';
    case '50n': // mist or fog (night)
      return 'https://cdn.pixabay.com/photo/2021/02/13/08/07/fog-6010637_1280.jpg';
    case '51d': // drizzle (day)
      return 'https://cdn.pixabay.com/photo/2017/08/26/19/03/rain-2683964_1280.jpg';
    case '51n': // drizzle (night)
      return 'https://i1.sndcdn.com/artworks-X2RtUWfUHLw3yAtn-QXCITA-t500x500.jpg';
    case '52d': // heavy intensity drizzle (day)
      return 'https://www.livemint.com/lm-img/img/2023/06/24/600x338/rain_1687583948847_1687583949184.jpg';
    case '52n': // heavy intensity drizzle (night)
      return 'https://www.livemint.com/lm-img/img/2023/06/24/600x338/rain_1687583948847_1687583949184.jpg';
    case '53d': // mist (day)
      return 'https://images.freeimages.com/images/large-previews/11e/foggy-day-1335348.jpg';
    case '53n': // mist (night)
      return 'https://images.unsplash.com/photo-1514791376975-4b8607d32b8e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Zm9nZ3klMjBuaWdodHxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80';
    case '54d': // haze (day)
      return 'https://www.wate.com/wp-content/uploads/sites/42/2023/06/64826d08b44ba5.38802265.jpeg';
    case '54n': // haze (night)
      return 'https://media.istockphoto.com/id/1098154198/photo/haze-on-the-night-street.jpg?s=170667a&w=0&k=20&c=DEZeQfj-6uVWAopkyGrcGaDDPO8mffOGvRg20csAlms=';
    case '55d': // sand/dust whirls (day)
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Dust_devil.jpg/1200px-Dust_devil.jpg';
    case '55n': // sand/dust whirls (night)
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Dust_devil.jpg/1200px-Dust_devil.jpg';
    default:
      return 'https://img.freepik.com/premium-photo/field_87394-32838.jpg';
  }
}
