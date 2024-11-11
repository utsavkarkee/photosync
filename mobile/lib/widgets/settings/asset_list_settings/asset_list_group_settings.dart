import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/widgets/asset_grid/asset_grid_data_structure.dart';
import 'package:mediab/providers/app_settings.provider.dart';
import 'package:mediab/services/app_settings.service.dart';
import 'package:mediab/widgets/settings/settings_radio_list_tile.dart';
import 'package:mediab/widgets/settings/settings_sub_title.dart';
import 'package:mediab/utils/hooks/app_settings_update_hook.dart';

class GroupSettings extends HookConsumerWidget {
  const GroupSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupByIndex = useAppSettingsState(AppSettingsEnum.groupAssetsBy);
    final groupBy = GroupAssetsBy.values[groupByIndex.value];

    void changeGroupValue(GroupAssetsBy? value) {
      if (value != null) {
        groupByIndex.value = value.index;
        ref.watch(appSettingsServiceProvider).setSetting(
              AppSettingsEnum.groupAssetsBy,
              value.index,
            );
        ref.invalidate(appSettingsServiceProvider);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubTitle(title: "asset_list_group_by_sub_title".tr()),
        SettingsRadioListTile(
          groups: [
            SettingsRadioGroup(
              title: 'asset_list_layout_settings_group_by_month_day'.tr(),
              value: GroupAssetsBy.day,
            ),
            SettingsRadioGroup(
              title: 'asset_list_layout_settings_group_by_month'.tr(),
              value: GroupAssetsBy.month,
            ),
            SettingsRadioGroup(
              title: 'asset_list_layout_settings_group_automatically'.tr(),
              value: GroupAssetsBy.auto,
            ),
          ],
          groupBy: groupBy,
          onRadioChanged: changeGroupValue,
        ),
      ],
    );
  }
}
