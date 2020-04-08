import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/viewmodels/chat_list_view_model.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_schrollListeler);
  }


  @override
  Widget build(BuildContext context) {
    final _chatListViewModel = Provider.of<ChatListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(_chatListViewModel.talkingUser.profilURL,),
            ),
            SizedBox(width: 10,),
            Text(_chatListViewModel.talkingUser.userName),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          MessageListWidget(),
           EnterTextSaveWidget()
        ],
      ),
    );
  }

  Consumer<ChatListViewModel> MessageListWidget() {
    return Consumer<ChatListViewModel>(
          builder: (context, chatViewModel, child){
           return Expanded(
             child: ListView.builder(
                         reverse: true,
                         controller: _scrollController,
                         itemCount: chatViewModel.hasMoreLoading ? chatViewModel.allMessage.length+1 : chatViewModel.allMessage.length,
                         itemBuilder: (context, index) {
                           if(chatViewModel.hasMoreLoading && chatViewModel.allMessage.length == index){
                             return _newMessagesLoadingIndicator();
                           }
                           return _chatChipsCreate(chatViewModel.allMessage[index]);
                         }),
           );
          },
        );
  }

  EnterTextSaveWidget()  {
    final _chatListViewModel = Provider.of<ChatListViewModel>(context);
    var _textfieldController = TextEditingController();
    return Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textfieldController =
                        TextEditingController(),
                    cursorColor: Colors.blueGrey,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.cyan.shade300,
                    child: Icon(Icons.send),
                    onPressed: () async {
                      if (_textfieldController.text.trim().length > 0) {

                        if (await _chatListViewModel.sendMessage(_textfieldController.text)) {
                          _textfieldController.clear();
                          _scrollController.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          );
  }

  Widget _chatChipsCreate(Message message) {
    Color myMessageColor = Colors.cyan.shade300;
    Color newMessageColor = Colors.greenAccent.shade200;
    var time = _showTimeMinute(message.dateTime);

    if (message.isMy) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        color: myMessageColor),
                    child: Text(message.content),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                  ),
                ),
                Text(time ?? '')
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        color: newMessageColor),
                    child: Text(message.content),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                  ),
                ),
                Text(time ?? '')
              ],
            ),
          ],
        ),
      );
    }
  }

  String _showTimeMinute(Timestamp dateTime) {

    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(dateTime.toDate());
      return _formatlanmisTarih;
  }

  void _schrollListeler(){
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange){
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async{
    await getOldMessages();
  }

  Widget _newMessagesLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> getOldMessages()async{
    final _chatViewModel = Provider.of<ChatListViewModel>(context, listen: false);

      await _chatViewModel.getMoreMessages();
    }

}
