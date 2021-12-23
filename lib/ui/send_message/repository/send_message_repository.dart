import 'package:file_picker/file_picker.dart';

import 'send_message_api_client.dart';

class SendMessageRepository {
  final SendMessageApiClient sendMessageApiClient;

  SendMessageRepository(this.sendMessageApiClient);

  Future<dynamic> getContactsList() async {
    return await sendMessageApiClient.getContactsList();
  }

  Future<dynamic> getCommitteeList() async {
    return await sendMessageApiClient.getCommitteeList();
  }

  Future<dynamic> getSearchCommitteeList(strscreach) async {
    return await sendMessageApiClient.getCommitteeSearchList(strscreach);
  }

  Future<dynamic> getSearchContactsList(String str) async {
    return await sendMessageApiClient.getSearchContactsList(str);
  }

  Future<dynamic> getGroupList() async {
    return await sendMessageApiClient.getGroupList();
  }

  Future<dynamic> getSearchGroupList(String str) async {
    return await sendMessageApiClient.getSearchGroupList(str);
  }

  Future<dynamic> sendMessage(
    Map messageData,
  ) async {
    return await sendMessageApiClient.sendMessage(messageData: messageData);
  }

  Future<dynamic> sendMessageWithAttachments(
      Map messageData, List<PlatformFile> attachments) async {
    return await sendMessageApiClient.sendMessageWithAttachments(
        messageData: messageData, attachments: attachments);
  }
}
