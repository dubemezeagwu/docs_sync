import 'package:docs_sync/screens/app_screens.dart';
import "package:intl/intl.dart";

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);
  NavigatorState get navigator => Navigator.of(this);
  FocusScopeNode get focusScope => FocusScope.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
}

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final num elapsed = DateTime.now().difference(this).inMilliseconds;

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    if (seconds < 45) {
      return "Now";
    } else if (seconds < 90) {
      return '1 minute ago';
    } else if (minutes < 45) {
      return '${minutes.round()} minutes ago';
    } else if (minutes < 90) {
      return '1 hour ago';
    } else if (hours < 24) {
      return '${hours.round()} hours ago';
    } else if (hours < 48) {
      return '1 day ago';
    } else if (days < 30) {
      return '${days.round()} days ago';
    } else if (days < 60) {
      return '1 month ago';
    } else if (days < 365) {
      return '${months.round()} months ago';
    } else if (years < 2) {
      return '1 year ago';
    } else {
      return '${years.round()} years ago';
    }
  }

  String get timeOfDay {
    if (hour >= 0 && hour < 6) {
      return "Night";
    } else if (hour >= 6 && hour < 12) {
      return "Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Afternoon";
    } else {
      return "Evening";
    }
  }
}

extension DateFormatExtension on String {
  String get formatDate {
    final date = DateTime.parse(this);
    final month = DateFormat.MMMM().format(date);
    final day = DateFormat.d().format(date);
    final year = DateFormat.y().format(date);
    return '$year $month $day';
  }
}

extension WidgetExtensions on int {
  SizedBox get kH {
    return SizedBox(
      height: toDouble(),
    );
  }

  SizedBox get kW {
    return SizedBox(
      width: toDouble(),
    );
  }
}

extension RadianFromDegrees on double {
  double get rad {
    const double unitRadian = 57.295779513;
    return this / unitRadian;
  }
}
