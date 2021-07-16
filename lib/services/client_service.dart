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
  String? path;
  bool isOnboarded = false;

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

  void postOnboard(Map<String?, AtClientService> value, String? atsign) {
    _atClientServiceMap = value;
    _atsign = atsign!;
    isOnboarded = true;
    var instance = _getClientForAtsign(atsign: _atsign);
    initializeContactsService(
      instance,
      atsign,
      rootDomain: AtConstants.ROOT_DOMAIN,
    );
    initializeChatService(
      instance,
      atsign,
      rootDomain: AtConstants.ROOT_DOMAIN,
    );
  }

  //* GETTERS (should only be called after onboarding)
  String get atsign => _atsign!;
  AtClientPreference get atClientPreference => _atClientPreference!;
  AtClientService get atClientServiceInstance => _atClientServiceInstance!;
  AtClientImpl get atClientInstance => _atClientInstance!;

  //* VERBS
  Future<void> sync() async {
    await _getClientForAtsign().getSyncManager()!.sync();
    _syncToProvider(await getAtKeys());
  }

  void _syncToProvider(List<AtKey> keys) {}

  Future<String> get(AtKey atKey) async =>
      (await _getClientForAtsign().get(atKey)).value;

  Future<bool> put(AtKey atKey, String value) async =>
      await _getClientForAtsign().put(atKey, value);

  Future<bool?> delete(AtKey atKey) async =>
      await _getClientForAtsign().delete(atKey);

  Future<List<AtKey>> getAtKeys({String? regex, String? sharedBy}) async {
    regex ??= AtConstants.NAMESPACE_REGEX;
    return await _getClientForAtsign()
        .getAtKeys(regex: regex, sharedBy: sharedBy);
  }

  Future<bool> notify(
      AtKey atKey, String value, OperationEnum operation) async {
    return await _getClientForAtsign().notify(atKey, value, operation);
  }
}
