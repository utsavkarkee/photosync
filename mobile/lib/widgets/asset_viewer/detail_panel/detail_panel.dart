import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/widgets/asset_viewer/description_input.dart';
import 'package:mediab/widgets/asset_viewer/detail_panel/asset_date_time.dart';
import 'package:mediab/widgets/asset_viewer/detail_panel/asset_details.dart';
import 'package:mediab/widgets/asset_viewer/detail_panel/asset_location.dart';
import 'package:mediab/widgets/asset_viewer/detail_panel/people_info.dart';
import 'package:mediab/entities/asset.entity.dart';

class DetailPanel extends HookConsumerWidget {
  final Asset asset;

  const DetailPanel({super.key, required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              AssetDateTime(asset: asset),
              asset.isRemote ? DescriptionInput(asset: asset) : const SizedBox.shrink(),
              PeopleInfo(asset: asset),
              AssetLocation(asset: asset),
              AssetDetails(asset: asset),
            ],
          ),
        ),
      ],
    );
  }
}
