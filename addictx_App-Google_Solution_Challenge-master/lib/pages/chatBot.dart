import 'dart:math';
import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DexiChatBot extends StatefulWidget {
  @override
  _DexiChatBotState createState() => _DexiChatBotState();
}
class _DexiChatBotState extends State<DexiChatBot> {
  final List<Message> _messages = <Message>[];
  final TextEditingController _textController = TextEditingController();
  Map ask={
    'English':"Ask me a Question..",
    'Hindi':'मुझसे एक प्रश्न पूछें..',
    'Spanish':'Hazme una pregunta..',
    'German':'Fragen Sie mich etwas..',
    'French':"Posez-moi une question..",
    'Japanese':'質問してください..',
    'Russian':'Задайте мне вопрос..',
    'Chinese':'问我一个问题..',
    'Portuguese':'Pergunte-me alguma coisa..',
  };
  Map title={
    'English':"Chat Bot",
    'Hindi':'चैट बोट',
    'Spanish':'Bot de chat',
    'German':'Chat-Bot',
    'French':"Chat Bot",
    'Japanese':'チャットボット',
    'Russian':'Чат-бот',
    'Chinese':'聊天机器人',
    'Portuguese':'Bot de bate-papo',
  };

  @override
  void initState() {
    _getMessage("@J15R7D24");
    super.initState();
  }

  void _getMessage(text) async {
    _textController.clear();
    Message typing = Message(
      text: '',
      name: "Dexi",
      isMyMessage: false,
      isTyping: true,
    );
    setState(() {
      _messages.insert(0, typing);
    });
    AuthGoogle authGoogle = await AuthGoogle(
      fileJson: "assets/mumblebot-mhrt-720b3aa4ed78.json",
    ).build();

    Dialogflow dialogflow =
    Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(text);

    Message message = Message(
      text: response.getMessage() ??
          CardDialogflow(
            response.getListMessage()[0],
          ).title,
      name: "Dexi",
      isMyMessage: false,
      isTyping: false,
    );
    setState(() {
      _messages.replaceRange(0, 1, [message]);
    });
  }

  void _sendMessage(String text) {
    _textController.clear();
    Message message = Message(
      text: text,
      name: "You",
      isMyMessage: true,
      isTyping: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _getMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              title[lang]+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
          Container(
            padding: EdgeInsets.fromLTRB(4,5,4,2),
            color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xffffffff),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "  "+ask[lang],
                        hintStyle: TextStyle(
                          color: Color(0xff828282),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: _textController,
                      autocorrect: false,
                      enableSuggestions: false,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffffffff),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child:Transform.rotate(angle: -pi/26, child: IconButton(
                    icon: Transform(
                        transform: Matrix4.rotationX(50),
                        child: Icon(FontAwesomeIcons.paperPlane,color: Colors.black,)),
                    onPressed: () => _sendMessage(_textController.text),
                  ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final String name;
  final bool isMyMessage;
  final bool isTyping;

  Message({
    this.text,
    this.name,
    this.isMyMessage,
    this.isTyping,
  });

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child:  CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/bot.png"),
        ),
      ),
      Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6,),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0x0a000000),
        ),
        child: Text(text,
          style: TextStyle(fontSize: 18.0),),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0x3b9ad0e5),
        ),
        child: Text(text,
          style: TextStyle(fontSize: 18.0),),
      ),
    ];
  }

  List<Widget> typingMessage(context) {
    return <Widget>[
      JumpingDotsProgressIndicator(
        fontSize: 30.0,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: this.isMyMessage?MainAxisAlignment.end:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isTyping?typingMessage(context):(this.isMyMessage ? myMessage(context) : botMessage(context)),
      ),
    );
  }
}