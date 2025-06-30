String mapDescriptionToTag(String description) {
  final desc = description.toLowerCase();

  // SUNNY
  if (desc.contains("clear") ||
      desc.contains("sun") ||
      desc.contains("few clouds") ||
      desc.contains("mostly sunny")) {
    return "Sunny";
  }

  // CLOUDY
  if (desc.contains("cloud") ||
      desc.contains("overcast") ||
      desc.contains("partly cloudy") ||
      desc.contains("mostly cloudy") ||
      desc.contains("fog") ||
      desc.contains("mist") ||
      desc.contains("haze")) {
    return "Cloudy";
  }

  // RAINY
  if (desc.contains("rain") ||
      desc.contains("drizzle") ||
      desc.contains("shower") ||
      desc.contains("thunderstorm") ||
      desc.contains("storm") ||
      desc.contains("freezing rain")) {
    return "Rainy";
  }

  // SNOWY
  if (desc.contains("snow") ||
      desc.contains("sleet") ||
      desc.contains("blizzard") ||
      desc.contains("ice") ||
      desc.contains("hail") ||
      desc.contains("freezing")) {
    return "Snowy";
  }

  return "Unknown";
}
