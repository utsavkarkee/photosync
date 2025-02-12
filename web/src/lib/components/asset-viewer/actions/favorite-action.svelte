<script lang="ts">
  import { shortcut } from '$lib/actions/shortcut';
  import CircleIconButton from '$lib/components/elements/buttons/circle-icon-button.svelte';
  import {
    NotificationType,
    notificationController,
  } from '$lib/components/shared-components/notification/notification';
  import { AssetAction } from '$lib/constants';
  import { handleError } from '$lib/utils/handle-error';
  import { updateAsset, type AssetResponseDto } from '@photosync/sdk';
  import { mdiHeart, mdiHeartOutline } from '@mdi/js';
  import { t } from 'svelte-i18n';
  import type { OnAction } from './action';

  export let asset: AssetResponseDto;
  export let onAction: OnAction;

  const toggleFavorite = async () => {
    try {
      const data = await updateAsset({
        id: asset.id,
        updateAssetDto: {
          isFavorite: !asset.isFavorite,
        },
      });

      asset.isFavorite = data.isFavorite;
      onAction({ type: asset.isFavorite ? AssetAction.FAVORITE : AssetAction.UNFAVORITE, asset });

      notificationController.show({
        type: NotificationType.Info,
        message: asset.isFavorite ? $t('added_to_favorites') : $t('removed_from_favorites'),
      });
    } catch (error) {
      handleError(error, $t('errors.unable_to_add_remove_favorites', { values: { favorite: asset.isFavorite } }));
    }
  };
</script>

<svelte:window use:shortcut={{ shortcut: { key: 'f' }, onShortcut: toggleFavorite }} />

<CircleIconButton
  color="opaque"
  icon={asset.isFavorite ? mdiHeart : mdiHeartOutline}
  title={asset.isFavorite ? $t('unfavorite') : $t('to_favorite')}
  on:click={toggleFavorite}
/>
