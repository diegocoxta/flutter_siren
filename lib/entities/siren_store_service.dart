import 'package:flutter_siren/entities/siren_store_response.dart';

abstract class SirenStoreService {
  Future<SirenStoreResponse> getStoreUpdate({required String from});
}
