import 'package:systemreader9/shared/finishedprocess.dart';
import 'package:systemreader9/shared/lockprocess.dart';
import 'package:systemreader9/shared/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../shared/shared.dart';
class TopicsScreen extends StatefulWidget {
  createState() => TopicsScreenState();
}

class TopicsScreenState  extends State<TopicsScreen> {
  @override
  Widget build(BuildContext context) {

          List<Topic> topics = Provider.of<List<Topic>>(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text('Topics'),
              actions: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.userCircle,
                      color: Colors.pink[200]),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
            ),
            drawer: TopicDrawer(topics: topics),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
            bottomNavigationBar: AppBottomNav(),
          );
        }


}


class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LockReport lockReport = Provider.of<LockReport>(context);
    List<TopicFinished> topicFinished =
    Provider.of<List<TopicFinished>>(context);
    print(topicFinished);
    return Container(
      child: Hero(
        tag: topic.img,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              var entry= FinishedProcess.getState().getFinishEntry(topicFinished, topic.id);
              if (entry!=null) {
                showAlertDialog(context, "💎 Define bulundu!", "Define avcısı " + entry.user + " defineyi buldu! Tebrikler!");
              }else if (LockProcess.getState().isLocked(lockReport, topic.id)) {
                showAlertDialog(context, "🔒 Kilitli", "Bu bulmaca 3 adet yanlış cevap verdiğiniz için kitlenmiştir." );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TopicScreen(topic: topic),
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    '${topic.img}',
                    fit: BoxFit.contain,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            topic.title,
                            style: TextStyle(
                                height: 1.5, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ),
                      if (LockProcess.getState().isLocked(lockReport, topic.id))
                        Icon(
                          FontAwesomeIcons.lock,
                          size: 18,
                          color: Colors.red,
                        ),
                      if (FinishedProcess.getState()
                          .isFinished(topicFinished, topic.id))
                        Text(
                          "💎",
                        )
                    ],
                  ),
                  // )
                  TopicProgress(topic: topic),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopicScreen extends StatelessWidget {
  final Topic topic;

  TopicScreen({this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: topic.img,
          child: Image.network('${topic.img}',
              width: MediaQuery.of(context).size.width),
        ),
        Text(
          topic.title,
          style:
          TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        QuizList(topic: topic)
      ]),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;
  QuizList({Key key, this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: topic.quizzes.map((quiz) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 4,
            margin: EdgeInsets.all(4),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    quiz.description,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  leading: QuizBadge(topic: topic, quizId: quiz.id),
                ),
              ),
            ),
          );
        }).toList());
  }
}

class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  TopicDrawer({Key key, this.topics});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: topics.length,
          itemBuilder: (BuildContext context, int idx) {
            Topic topic = topics[idx];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    topic.title,
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                QuizList(topic: topic)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int idx) => Divider()),
    );
  }
}
