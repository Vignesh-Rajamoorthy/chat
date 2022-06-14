import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // void initFirebase() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   var token = await messaging.getToken();
  //   debugPrint("token: ");
  //   debugPrint(token);
  // }

  @override
  void initState() {
    super.initState();
    const appid = String.fromEnvironment('AppId');
    const appkey = String.fromEnvironment('AppKey');
    const domain = String.fromEnvironment('Domain');

    Freshchat.init(appid,appkey,domain);

    var restoreStream = Freshchat.onRestoreIdGenerated;
    restoreStream.listen((event) async {
      FreshchatUser user = await Freshchat.getUser;
      var restoreId = user.getRestoreId();
      debugPrint(restoreId);
      var externalId = user.getExternalId();
      debugPrint(externalId);
    });

    var freshevent = Freshchat.onFreshchatEvents;
    freshevent.listen((event) {
      debugPrint(event.toString());
    });

    // initFirebase();
  }

  var items = ["category", "article"];
  String dropVal = "category";
  TextEditingController tagsController = TextEditingController();
  String tags = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Flutter'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Freshchat.showConversations(
                        filteredViewTitle: "TEEEst", tags: ["test", "mob"]);
                  },
                  child: const Text("Show Conversation")),
              DropdownButton<String>(
                // Initial Value
                value: dropVal,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  setState(() {
                    dropVal = newValue!;
                  });
                },
              ),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tags',
                ),
                onChanged: (text) {
                  setState(() {
                    tags = text;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    Freshchat.showFAQ(
                        faqTags: tagsController.text.split(","),
                        faqFilterType: dropVal == "category"
                            ? FaqFilterType.Category
                            : FaqFilterType.Article);
                  },
                  child: const Text("Show FAQs")),
              ElevatedButton(
                  onPressed: () async {
                    dynamic val = await Freshchat.getUnreadCountAsync;
                    debugPrint("Message count $val");
                  },
                  child: const Text("Get Unread Message Count")),
              ElevatedButton(
                  onPressed: () async {
                    FreshchatUser freshchatUser = await Freshchat.getUser;
                    freshchatUser.setFirstName("Johnn");
                    freshchatUser.setLastName("Doe");
                    freshchatUser.setEmail("johndoe@dead.man");
                    freshchatUser.setPhone("+91", "1234234123");
                    Freshchat.setUser(freshchatUser);
                    Freshchat.identifyUser(externalId: "johndoe@dead.man");
                  },
                  child: const Text("Set User")),
              ElevatedButton(
                  onPressed: () async {
                    FreshchatUser freshchatUser = await Freshchat.getUser;
                    debugPrint(freshchatUser.getFirstName());
                  },
                  child: const Text("Get User")),
              ElevatedButton(
                  onPressed: () async {
                    Freshchat.resetUser();
                  },
                  child: const Text("Reset User")),
              ElevatedButton(
                  onPressed: () async {
                    Freshchat.identifyUser(
                        externalId: "johndoe@dead.man",
                        restoreId: "f6d8d8af-03b4-482d-932f-6323423bb77f");
                  },
                  child: const Text("Identify user")),
              ElevatedButton(
                  onPressed: () async {
                    String tag = "premiummm";
                    String message = "text message";
                    Freshchat.sendMessage(tag, message);
                  },
                  child: const Text("Send Message")),
            ],
          )),
    );
  }
}


// "c69641e9-8a85-4da1-858e-77169b0c76a7",
//         "23d7240c-0176-4de1-acc4-d63c534b59be", "msdk.freshchat.com"