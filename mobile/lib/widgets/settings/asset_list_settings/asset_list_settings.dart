import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/providers/app_settings.provider.dart';
import 'package:mediab/services/app_settings.service.dart';
import 'package:mediab/widgets/settings/asset_list_settings/asset_list_group_settings.dart';
import 'package:mediab/widgets/settings/settings_sub_page_scaffold.dart';
import 'package:mediab/widgets/settings/settings_switch_list_tile.dart';
import 'package:mediab/utils/hooks/app_settings_update_hook.dart';
import 'asset_list_layout_settings.dart';

class AssetListSettings extends HookConsumerWidget {
  const AssetListSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showStorageIndicator = useAppSettingsState(AppSettingsEnum.storageIndicator);

    final assetListSetting = [
      SettingsSwitchListTile(
        valueNotifier: showStorageIndicator,
        title: 'theme_setting_asset_list_storage_indicator_title'.tr(),
        onChanged: (_) => ref.invalidate(appSettingsServiceProvider),
      ),
      const LayoutSettings(),
      const GroupSettings(),
    ];

    return SettingsSubPageScaffold(
      settings: assetListSetting,
      showDivider: true,
    );
  }
}
