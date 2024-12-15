<script lang="ts">
  import { notificationController } from '$lib/components/shared-components/notification/notification';
  import { getServerErrorMessage, handleError } from '$lib/utils/handle-error';
  import Button from '../elements/buttons/button.svelte';
  import PasswordField from '../shared-components/password-field.svelte';
  import { resetPassword, updateMyUser } from '@photosync/sdk';
  import { t } from 'svelte-i18n';
  let email: string, token: string;

  $: {
    const urlParams = new URLSearchParams(window.location.search);
    email = urlParams.get('email') as string;
    token = urlParams.get('token') as string;
  }
  export let onSuccess: () => void;

  let errorMessage: string;
  let success: string;

  let password = '';
  let passwordConfirm = '';

  let valid = false;

  $: {
    if (password !== passwordConfirm && passwordConfirm.length > 0) {
      errorMessage = $t('password_does_not_match');
      valid = false;
    } else {
      errorMessage = '';
      valid = true;
    }
  }

  async function changePassword() {
    if (valid) {
      errorMessage = '';
      try {
        await resetPassword({ resetPassword: { newPassword: String(password), email: email, token: token } });

        onSuccess();
      } catch (error) {
        handleError(error);

        return;
      }
    }
  }
</script>

<form on:submit|preventDefault={changePassword} method="post" class="mt-5 flex flex-col gap-5">
  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="password">{$t('new_password')}</label>
    <PasswordField id="password" bind:password autocomplete="new-password" />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="confirmPassword">{$t('confirm_password')}</label>
    <PasswordField id="confirmPassword" bind:password={passwordConfirm} autocomplete="new-password" />
  </div>

  {#if errorMessage}
    <p class="text-sm text-red-400">{errorMessage}</p>
  {/if}

  {#if success}
    <p class="text-sm text-immich-primary">{success}</p>
  {/if}
  <div class="my-5 flex w-full">
    <Button type="submit" size="lg" fullwidth>{$t('to_reset_password')}</Button>
  </div>
</form>
