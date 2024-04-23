import 'package:docs_sync/core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Time Helper", () {
    group("get time of the day", () {
      test("should return Night", () {
        // arrange
        DateTime currentTime = DateTime(2024, 3, 6, 2);

        // act
        String timeOfDay = TimeHelper.getTImeOfTheDay(currentTime);

        // assert
        expect(timeOfDay, "Night");
      });
      test("should return Morning", () {
        // arrange
        DateTime currentTime = DateTime(2024, 3, 6, 8);

        // act
        String timeOfDay = TimeHelper.getTImeOfTheDay(currentTime);

        // assert
        expect(timeOfDay, "Morning");
      });
      test("should return Afternoon", () {
        // arrange
        DateTime currentTime = DateTime(2024, 3, 6, 14);

        // act
        String timeOfDay = TimeHelper.getTImeOfTheDay(currentTime);

        // assert
        expect(timeOfDay, "Afternoon");
      });
      test("should return Evening", () {
        // arrange
        DateTime currentTime = DateTime(2024, 3, 6, 21);

        // act
        String timeOfDay = TimeHelper.getTImeOfTheDay(currentTime);

        // assert
        expect(timeOfDay, "Evening");
      });
    });
  });
}
