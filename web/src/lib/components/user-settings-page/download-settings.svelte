<script lang="ts">
  import {
    notificationController,
    NotificationType,
  } from '$lib/components/shared-components/notification/notification';
  import { updateMyPreferences } from '@photosync/sdk';
  import { fade } from 'svelte/transition';
  import { handleError } from '../../utils/handle-error';

  import { preferences } from '$lib/stores/user.store';
  import Button from '../elements/buttons/button.svelte';
  import { t } from 'svelte-i18n';
  import SettingInputField, {
    SettingInputFieldType,
  } from '$lib/components/shared-components/settings/setting-input-field.svelte';
  import { ByteUnit, convertFromBytes, convertToBytes } from '$lib/utils/byte-units';
  import SettingSwitch from '$lib/components/shared-components/settings/setting-switch.svelte';

  let archiveSize = convertFromBytes($preferences?.download?.archiveSize || 4, ByteUnit.GiB);
  let includeEmbeddedVideos = $preferences?.download?.includeEmbeddedVideos || false;

  const handleSave = async () => {
    try {
      const newPreferences = await updateMyPreferences({
        userPreferencesUpdateDto: {
          download: {
            archiveSize: Math.floor(convertToBytes(archiveSize, ByteUnit.GiB)),
            includeEmbeddedVideos,
          },
        },
      });
      $preferences = newPreferences;

      notificationController.show({ message: $t('saved_settings'), type: NotificationType.Info });
    } catch (error) {
      handleError(error, $t('errors.unable_to_update_settings'));
    }
  };
</script>

<section class="my-4">
  <div in:fade={{ duration: 500 }}>
    <form autocomplete="off" on:submit|preventDefault>
      <div class="ml-4 mt-4 flex flex-col gap-4">
        <SettingInputField
          inputType={SettingInputFieldType.NUMBER}
          label={$t('archive_size')}
          desc={$t('archive_size_description')}
          bind:value={archiveSize}
        />
        <SettingSwitch
          title={$t('download_include_embedded_motion_videos')}
          subtitle={$t('download_include_embedded_motion_videos_description')}
          bind:checked={includeEmbeddedVideos}
        ></SettingSwitch>
        <div class="flex justify-end">
          <Button type="submit" size="sm" on:click={() => handleSave()}>{$t('save')}</Button>
        </div>
      </div>
    </form>
  </div>
</section>
