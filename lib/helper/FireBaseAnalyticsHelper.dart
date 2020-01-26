
import 'package:firebase_analytics/firebase_analytics.dart';

class FireBaseAnalyticsHelper{
  FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  void TrackCurrentScreen(String screen){
    _firebaseAnalytics.setCurrentScreen(screenName: screen);
  }

  void TrackClickEvent(String screen, String event, String userId){
    _firebaseAnalytics.logEvent(name: 'click_event', parameters: {
      'click_event' : event,
      'screen' : screen,
      'userId' : userId
    });
  }
}