import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systemreader9/main.dart';
import 'package:systemreader9/services/globals.dart';

class FinishedProcess{
  static FinishedProcess _instance;

  static FinishedProcess getState() {
    if (_instance == null) {
      _instance = new FinishedProcess();
    }

    return _instance;
  }

  bool isFinished(topicFinished, topic){
    return (getFinishEntry(topicFinished, topic)!= null);
  }
  getFinishEntry(topicFinished, topic){
  var entry;
  if(topicFinished != null){
      entry = topicFinished.firstWhere((topicExist) => topicExist.id == topic, orElse: () => null);

    }
     return entry;
  }


}
