<script lang="ts">
  import type { SystemConfigDto } from '@photosync/sdk';
  import { isEqual } from 'lodash-es';
  import { fade } from 'svelte/transition';
  import type { SettingsResetEvent, SettingsSaveEvent } from '../admin-settings';
  import SettingInputField, {
    SettingInputFieldType,
  } from '$lib/components/shared-components/settings/setting-input-field.svelte';
  import SettingButtonsRow from '$lib/components/shared-components/settings/setting-buttons-row.svelte';
  import { t } from 'svelte-i18n';

  export let savedConfig: SystemConfigDto;
  export let defaultConfig: SystemConfigDto;
  export let config: SystemConfigDto; // this is the config that is being edited
  export let disabled = false;
  export let onReset: SettingsResetEvent;
  export let onSave: SettingsSaveEvent;
</script>

<div>
  <div in:fade={{ duration: 500 }}>
    <form autocomplete="off" on:submit|preventDefault>
      <div class="mt-4 ml-4">
        <SettingInputField
          inputType={SettingInputFieldType.TEXT}
          label={$t('admin.server_external_domain_settings')}
          desc={$t('admin.server_external_domain_settings_description')}
          bind:value={config.server.externalDomain}
          isEdited={config.server.externalDomain !== savedConfig.server.externalDomain}
        />

        <SettingInputField
          inputType={SettingInputFieldType.TEXT}
          label={$t('admin.server_welcome_message')}
          desc={$t('admin.server_welcome_message_description')}
          bind:value={config.server.loginPageMessage}
          isEdited={config.server.loginPageMessage !== savedConfig.server.loginPageMessage}
        />

        <div class="ml-4">
          <SettingButtonsRow
            onReset={(options) => onReset({ ...options, configKeys: ['server'] })}
            onSave={() => onSave({ server: config.server })}
            showResetToDefault={!isEqual(savedConfig.server, defaultConfig.server)}
            {disabled}
          />
        </div>
      </div>
    </form>
  </div>
</div>
