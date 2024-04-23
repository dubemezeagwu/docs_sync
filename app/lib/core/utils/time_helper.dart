class TimeHelper {
  static getTImeOfTheDay(DateTime time) {

    if (time.hour >= 0 && time.hour < 6) {
      return "Night";
    } else if (time.hour >= 6 && time.hour < 12) {
      return "Morning";
    } else if (time.hour >= 12 && time.hour < 18) {
      return "Afternoon";
    } else {
      return "Evening";
    }
  }
}
