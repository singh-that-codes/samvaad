// ignore_for_file: unused_local_variable, unused_field
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/enum/view_state.dart';
import 'package:samvaad/models/message.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/provider/image_upload_provider.dart';
import 'package:samvaad/resources/auth_methods.dart' as auth;
import 'package:samvaad/resources/chat_methods.dart';
import 'package:samvaad/resources/storage_methods.dart';
import 'package:samvaad/screens/callscreens/pickup/pickup_layout.dart';

import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/utils/call_utilities.dart';
import 'package:samvaad/utils/permissions.dart';
import 'package:samvaad/utils/universal_variables.dart';
import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/utils/voice_call_utilities.dart';
import 'package:samvaad/widgets/appbar.dart';
import 'package:samvaad/widgets/custom_tile.dart';
enum UserState { Online, Offline, Waiting }
class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ImageUploadProvider _imageUploadProvider;

  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  late User sender;
  late String _currentUserId;
  bool isWriting = false;
  bool showEmojiPicker = false;

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    permi(); // Call the permission function
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user!.uid;

      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName ?? '',
          profilePhoto: user.photoURL ?? '',
          email: '',
          username: '',
          status: '',
          state: 0, password: '',
        );
      });
    });
  }
Future<void> permi() async {
  var storagePermissionStatus = await Permission.storage.request();
  setState(() {
  });
}


  

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      var showEmojiPicker = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
  //void setState(Null Function() param0) {
  }

 /*showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }*/

  @override
Widget build(BuildContext context) {
  var _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
  var getViewState = _imageUploadProvider.getViewState;

  return WillPopScope(
    onWillPop: () async {
      print('backk');
      await FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(_currentUserId as String?)
          .collection(widget.receiver.uid)
          .get()
          .then((snapshot) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      Navigator.pop(context);
      return true;
    },
    child: PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_chat.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                child: messageList(),
              ),
              if (getViewState == ViewState.LOADING)
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator(),
                ),
              chatControls(),
            ],
          ),
        ),
      ),
    ),
  );
}

customAppBar(BuildContext context) {
}

chatControls() {
}

class _currentUserId {
}



  
  class _imageUploadProvider {
  static var getViewState;
  }

  /*mojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }*/

  Widget messageList() {
    var _currentUserId;
    var widget;
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut,
        //   );
        // });

        Widget messageList() {
  var Firestore;
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection(MESSAGES_COLLECTION)
        .document(_currentUserId)
        .collection(widget.receiver.uid)
        .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      final documents = snapshot.data?.documents;
      if (documents == null || documents.isEmpty) {
        return Center(child: Text("No messages available."));
      }

      return ListView.builder(
        padding: EdgeInsets.all(10),
        reverse: true,
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return chatMessageItem(documents[index]);
        },
      );
    },
  );
}


  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data as Map<String, dynamic>);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    var chatAlignment = Alignment.topRight;
    var chatnip = BubbleNip.rightTop;
    var bubbleMargin = BubbleEdges.only(top: 0, left: 40);
    var chatColor = Color.fromRGBO(225, 255, 199, 1.0);
    var chatMsgAlgn = TextAlign.right;
    return Bubble(
      margin: bubbleMargin,
      alignment: chatAlignment,
      nip: chatnip,
      // color: Color.fromRGBO(225, 255, 199, 1.0),
      color: chatColor,
      child: getMessage(message),
    );

    // return Container(
    //   margin: EdgeInsets.only(top: 12),
    //   constraints:
    //       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
    //   decoration: BoxDecoration(
    //     color: UniversalVariables.senderColor,
    //     borderRadius: BorderRadius.only(
    //       topLeft: messageRadius,
    //       topRight: messageRadius,
    //       bottomLeft: messageRadius,
    //     ),
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.all(10),
    //     child: getMessage(message),
    //   ),
    // );
  }

  getMessage(Message message) {
    // final dir = await getApplicationDocumentsDirectory();
    // final ff = File('${dir.path}/${message.photoUrl}');

    print(message.type);

    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? TextButton(
                onPressed: () async {
                  print(message.photoUrl);

                  // var httpClient = new HttpClient();
                  // Future<File> _downloadFile(
                  //     String url, String filename) async {
                  //   var request = await httpClient.getUrl(Uri.parse(url));
                  //   var response = await request.close();
                  //   var bytes =
                  //       await consolidateHttpClientResponseBytes(response);
                  //   String dir =
                  //       (await getApplicationDocumentsDirectory()).path;
                  //   // File file = new File('$dir/$filename');
                  //   File file =
                  //       new File('/storage/emulated/0/Download/$filename');
                  //
                  //   print('$dir/$filename');
                  //   await file.writeAsBytes(bytes);
                  //   print(file.absolute);
                  //   return file;
                  // }

                  // await FlutterDownloader.initialize();

                  Future<String> _findLocalPath() async {
                    final platform = Theme.of(context).platform;
                    final directory = platform == TargetPlatform.android
                        ? await getExternalStorageDirectory()
                        : await getApplicationDocumentsDirectory();
                    return directory?.path;
                  }

                  String localPath = (await _findLocalPath()) +
                      Platform.pathSeparator +
                      'Download';
                  final savedDir = Directory(localPath);
                  bool hasExisted = await savedDir.exists();
                  if (!hasExisted) {
                    savedDir.create();
                  }

                  print(message.type);

                  final taskId = await FlutterDownloader.enqueue(
                      url: message.photoUrl,
                      savedDir: localPath,
                      fileName: message.name,
                      showNotification: true,
                      openFileFromNotification:
                          true // show download progress in status bar (for Android)
                      // click on notification to open downloaded file (for Android)
                      );

                  // _downloadFile(message.photoUrl, 'a111.jpg');
                },
                child: CachedImage(
                  message.photoUrl,
                  name: message.name,
                  height: 250,
                  width: 250,
                  radius: 10, 
                ),
              )
            : Text("Url was null");
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    var chatAlignment = Alignment.topLeft;
    var chatnip = BubbleNip.leftTop;
    var bubbleMargin = BubbleEdges.only(top: 0, right: 40);
    var chatColor = Colors.white70;
    var chatMsgAlgn = TextAlign.right;
    return Bubble(
      margin: bubbleMargin,
      alignment: chatAlignment,
      nip: chatnip,
      // color: Color.fromRGBO(225, 255, 199, 1.0),

      child: getMessage(message),
    );

    // return Container(
    //   margin: EdgeInsets.only(top: 12),
    //   constraints:
    //       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
    //   decoration: BoxDecoration(
    //     color: UniversalVariables.receiverColor,
    //     borderRadius: BorderRadius.only(
    //       bottomRight: messageRadius,
    //       topRight: messageRadius,
    //       bottomLeft: messageRadius,
    //     ),
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.all(10),
    //     child: getMessage(message),
    //   ),
    // );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        var isWriting = val;
      });
    }
  

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Attachments",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                        onTap: () => pickImage(source: ImageSource.gallery),
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab,
                        onTap: () {
                          pickFiles();
                        },
                      ),
                      // ModalTile(
                      //   title: "Contact",
                      //   subtitle: "Share contacts",
                      //   icon: Icons.contacts,
                      // ),
                      // ModalTile(
                      //   title: "Location",
                      //   subtitle: "Share a location",
                      //   icon: Icons.add_location,
                      // ),
                      // ModalTile(
                      //   title: "Schedule Call",
                      //   subtitle: "Arrange a skype call and get reminders",
                      //   icon: Icons.schedule,
                      // ),
                      // ModalTile(
                      //   title: "Create Poll",
                      //   subtitle: "Share polls",
                      //   icon: Icons.poll,
                      // )
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      var textFieldController;
      var text = textFieldController.text;

      var sender;
      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text', type1: '', photoUrl: '', name: '', messageType: '', imageUrl: '',
      );

      

      textFieldController.text = "";

      var _chatMethods;
      _chatMethods.addMessageToDb(_message);
    }
    
    void setState(Null Function() param0) {
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.teal,
                // gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      //showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      //hideEmojiContainer();
                    }
                  },
                  icon: Icon(
                    Icons.face,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  // child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey.shade700,
                  ),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  void pickImage({required ImageSource source}) async {
    File selectedImage = (await ImagePicker.pickImage(source: source)) as File;
    print('selectedImage $selectedImage');
    var tt = selectedImage.toString().split('.').last;
    var nn = selectedImage.toString().split('/').last;
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        type1: tt,
        name: nn,
        imageUploadProvider: _imageUploadProvider);
  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      print(file.path);

      var nn = file.path.toString().split('/').last;
      var tt = file.path.toString().split('.').last;

      _storageMethods.uploadImage(
          image: file,
          type1: tt,
          receiverId: widget.receiver.uid,
          senderId: _currentUserId,
          name: nn,
          imageUploadProvider: _imageUploadProvider);
    } else {
      // User canceled the picker
    }
  }

  CustomAppBar customAppBar(context) {
    var sender;
    var widget;
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () async {
          var _currentUserId;
          var widget;
          await Firestore.instance
              .collection(MESSAGES_COLLECTION)
              .document(_currentUserId)
              .collection(widget.receiver.uid)
              .getDocuments()
              .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.documents) {
              doc.reference.delete();
            }
          });
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender,
                      to: widget.receiver,
                      context: context,
                    )
                  : {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? VoiceCallUtils.dial(
                      from: sender,
                      to: widget.receiver,
                      context: context,
                    )
                  : {},
        )
      ], key: null,
    );
  }


  @override
   import 'package:flutter/material.dart';
import 'package:samvaad/utils/universal_variables.dart';
import 'package:samvaad/widgets/custom_tile.dart'; // Import the required library for CustomTile

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap; // Pass the onTap function as a parameter

  const ModalTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData? trailing; // Initialize trailing icon data type
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap, // Pass the onTap function directly
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: Icon(
          trailing, // Use trailing directly without Icon widget
          color: UniversalVariables.greyColor,
        ),
        onLongPress: () {
          // Define your onLongPress functionality here
        },
      ),
    );
  }
}

// Define the onTap function outside the Widget class
void onTap() {
  // Your onTap functionality here
}

// Define the PermissionHandler function outside the Widget class (if needed)
void PermissionHandler() {
  // Your PermissionHandler functionality here
}};),}
