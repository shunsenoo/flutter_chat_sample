// Replace the code in main.dart with the following.

import 'package:flutter/material.dart';

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 下で設定したchatmessagesクラスを複数縦に並べる
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  @override
  // アプリの見た目を作成する
  Widget build(BuildContext context) {
    return new Scaffold(
      // navigation bar
      appBar: new AppBar(title: new Text("FriendlyChat")),
      // body: 縦に長く連なる（メッセージのlistviewとtextField）
      body: new Column(
        children: <Widget>[
          // 長さが柔軟なwidget：今回はlistviewが入る
          new Flexible(
              child: new ListView.builder(
                // 全ての方向に8のpadding
                padding: new EdgeInsets.all(8.0),
                reverse: true,
               // cell for row at
               itemBuilder:  (_, int index) => _messages[index],
               // number of cells
               itemCount: _messages.length,
          )),
          // 間に1.0の境界線
          new Divider(height: 1.0),
          // textFieldが入るcontainer（サイズが固定化された箱）
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            // textfieldを作るメソッド
            child: _buildTextComposer(),
          )
        ],
      )
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
         margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
            // サイズが柔軟に変わる（buttonのサイズによってサイズが変わる）:textfield
               new Flexible(
                child: new TextField(
                 controller: _textController,
                 onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                   hintText: "Send a message"),
                ),
               ),
              // サイズが固定の箱：送信ボタン
                new Container(                                                 //new
                 margin: new EdgeInsets.symmetric(horizontal: 4.0),           //new
                   child: new IconButton(                                       //new
                    icon: new Icon(Icons.send),                                //new
                     onPressed: () => _handleSubmitted(_textController.text)),  //new
                ),
             ],
         ),
        ),
        );

  }
// 送信ボタンが押された時に呼ばれるメソッド
  void _handleSubmitted(String text) {
    // textfieldを畳む
    _textController.clear();
    // リストに追加されたメッセージを追加する
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(microseconds: 700),
          vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0 , message);
    });
    message.animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController  animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(parent: animationController , curve: Curves.easeOut),
      axisAlignment: 0.0,
      // 送信テキストのcontainer
      child: new Container(
      // 上下に10pxのmargin
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      // 横一列の箱
      child: new Row(
        // 左寄せ
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // アイコンが入った箱
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            // アイコン
            child: new CircleAvatar(child: new Text(_name[0])),
          ),
          // usernameとtextが入った縦の箱
          new Column(
            // 左寄せ
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    ),

    );
  }
}
// コンパイル時定数
const String _name = "your name";