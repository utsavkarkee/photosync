import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/entities/user.entity.dart';
import 'package:mediab/interfaces/partner_api.interface.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:mediab/repositories/api.repository.dart';
import 'package:openapi/api.dart';

final partnerApiRepositoryProvider = Provider(
  (ref) => PartnerApiRepository(
    ref.watch(apiServiceProvider).partnersApi,
  ),
);

class PartnerApiRepository extends ApiRepository implements IPartnerApiRepository {
  final PartnersApi _api;

  PartnerApiRepository(this._api);

  @override
  Future<List<User>> getAll(Direction direction) async {
    final response = await checkNull(
      _api.getPartners(
        direction == Direction.sharedByMe ? PartnerDirection.by : PartnerDirection.with_,
      ),
    );
    return response.map(User.fromPartnerDto).toList();
  }

  @override
  Future<User> create(String id) async {
    final dto = await checkNull(_api.createPartner(id));
    return User.fromPartnerDto(dto);
  }

  @override
  Future<void> delete(String id) => _api.removePartner(id);

  @override
  Future<User> update(String id, {required bool inTimeline}) async {
    final dto = await checkNull(
      _api.updatePartner(
        id,
        UpdatePartnerDto(inTimeline: inTimeline),
      ),
    );
    return User.fromPartnerDto(dto);
  }
}
