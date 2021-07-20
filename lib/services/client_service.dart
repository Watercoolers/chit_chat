import 'package:at_chat_flutter/services/chat_service.dart';
import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';

import 'package:path_provider/path_provider.dart';
import 'package:chit_chat/utils/constants.dart';

class ClientService {
  ClientService._internal();
  static final ClientService _singleton = ClientService._internal();
  factory ClientService.getInstance() => _singleton;

  Map<String?, AtClientService?> _atClientServiceMap = {};
  Map<String, bool> _clientIsInitialized = {};
  String? path;

  //* Post onboard variables
  String? _atsign;
  AtClientPreference? _atClientPreference;
  AtClientService? _atClientServiceInstance;
  AtClientImpl? _atClientInstance;

  //* AtClientService Getters
  AtClientService _getClientServiceForAtsign({String? atsign}) =>
      _atClientServiceInstance ??=
          _atClientServiceMap[atsign] ?? AtClientService();

  AtClientImpl _getClientForAtsign({String? atsign}) => _atClientInstance ??=
      _getClientServiceForAtsign(atsign: atsign).atClient!;

  //* Onboarding process
  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    path ??= (await getApplicationSupportDirectory()).path;
    return AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = AtConstants.NAMESPACE
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = AtConstants.ROOT_DOMAIN
      ..rootPort = AtConstants.ROOT_PORT
      ..hiveStoragePath = path;
  }

  void resetInstance() {
    _atClientServiceInstance = null;
    _atClientInstance = null;
  }

  void postOnboard(Map<String?, AtClientService> value, String? atsign) {
    _atClientServiceMap = value;
    _atsign = atsign!;
    var instance = _getClientForAtsign(atsign: _atsign);
    initializeContactsService(
      instance,
      atsign,
      rootDomain: AtConstants.ROOT_DOMAIN,
    );

    //* This prevents starting multiple monitors for at_chat_flutter
    if (_clientIsInitialized[atsign] ?? false) {
      var chatService = ChatService();
      chatService.currentAtSign = atsign;
      chatService.atClientInstance = instance;
    } else {
      initializeChatService(
        instance,
        atsign,
        rootDomain: AtConstants.ROOT_DOMAIN,
      );
      print('initialized chat service for $atsign');
      _clientIsInitialized[atsign] = true;
    }
  }

  //* GETTERS (should only be called after onboarding)
  String get atsign => _atsign!;
  AtClientPreference get atClientPreference => _atClientPreference!;
  AtClientService get atClientServiceInstance => _atClientServiceInstance!;
  AtClientImpl get atClientInstance => _atClientInstance!;
}
