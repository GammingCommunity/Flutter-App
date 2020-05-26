import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/hive_models/member.dart';
import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart' as pathProvider;

Future hiveInit() async {
  var appDocumentDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  
  Hive.registerAdapter(GroupMessageAdapter());
  Hive.registerAdapter(GMessageAdapter());
  Hive.registerAdapter(GroupChatAdapter());
  Hive.registerAdapter(GameInfoAdapter());
  Hive.registerAdapter(GroupChatsAdapter());
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(MembersAdapter());
  await Hive.openBox<Member>('member');
  await Hive.openBox<Members>('members');
  await Hive.openBox<GroupMessage>('groupMessage');
  await Hive.openBox<GroupChat>('groupChat');
}
