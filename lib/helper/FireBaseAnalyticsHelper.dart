
import 'package:firebase_analytics/firebase_analytics.dart';

class FireBaseAnalyticsHelper{
  static FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  static void TrackCurrentScreen(String screen){
    _firebaseAnalytics.setCurrentScreen(screenName: screen);
  }

  static void TrackClickEvent(String screen, String event, String userId){
    _firebaseAnalytics.logEvent(name: 'click_event', parameters: {
      'click_event' : event,
      'screen' : screen,
      'userId' : userId
    });
  }
}