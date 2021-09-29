import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_client/at_client.dart';
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
  AtClientManager? _atClientInstance;

  //* AtClientService Getters
  AtClientService _getClientServiceForAtsign({String? atsign}) =>
      _atClientServiceInstance ??=
          _atClientServiceMap[atsign] ?? AtClientService();

  AtClientManager _getClientForAtsign({String? atsign}) => _atClientInstance ??=
      _getClientServiceForAtsign(atsign: atsign).atClientManager;

  //* Onboarding process
  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    path ??= (await getApplicationSupportDirectory()).path;
    return AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = AtConstants.NAMESPACE
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
    print(_atClientServiceMap);
    _atsign = atsign!;
    var instance = _getClientForAtsign(atsign: _atsign);
    print(instance.atClient.getCurrentAtSign());
    initializeContactsService(rootDomain: AtConstants.ROOT_DOMAIN);

    //* This prevents starting multiple monitors for at_chat_flutter
    initializeChatService(
      instance,
      atsign,
      rootDomain: AtConstants.ROOT_DOMAIN,
    );
    print('initialized chat service for $atsign');
    _clientIsInitialized[atsign] = true;
  }

  //* GETTERS (should only be called after onboarding)
  String get atsign => _atsign!;
  AtClientPreference get atClientPreference => _atClientPreference!;
  AtClientService get atClientServiceInstance => _atClientServiceInstance!;
  AtClientImpl get atClientInstance =>
      _atClientInstance!.atClient as AtClientImpl;
}
