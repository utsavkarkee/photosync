<script lang="ts">
  import { goto } from '$app/navigation';
  import { AppRoute } from '$lib/constants';
  import { signUpUser } from '@immich/sdk';
  import { handleError } from '../../utils/handle-error';
  import Button from '../elements/buttons/button.svelte';
  import PasswordField from '../shared-components/password-field.svelte';
  import { notificationController, NotificationType } from '../shared-components/notification/notification';

  import { t } from 'svelte-i18n';
  import { retrieveServerConfig } from '$lib/stores/server-config.store';
  export let onSuccess: () => unknown | Promise<unknown>;
  let email = '';
  let password = '';
  let confirmPassword = '';
  let name = '';

  let errorMessage: string;
  let canRegister = false;

  $: {
    if (password !== confirmPassword && confirmPassword.length > 0) {
      errorMessage = $t('password_does_not_match');
      canRegister = false;
    } else {
      errorMessage = '';
      canRegister = true;
    }
  }

  async function registerAdmin() {
    try {
      await signUpUser({ signUpDto: { email, password, name, notify: true , shouldChangePassword:false} });
      await retrieveServerConfig();
      onSuccess();
      notificationController.show({
        message: 'Welcome aboard! Your registration is complete. Please log in with your credentials to get started',
        type: NotificationType.Info,
      });
      await goto(AppRoute.AUTH_LOGIN);
    } catch (error) {
      handleError(error, $t('errors.unable_to_create_user_account'));
      errorMessage = $t('errors.unable_to_create_user_account');
    }
  }
</script>

<form on:submit|preventDefault={registerAdmin} method="post" class="mt-5 flex flex-col gap-5">
  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="name">{$t('name')}</label>
    <input class="immich-form-input" id="name" bind:value={name} type="text" autocomplete="name" required />
  </div>
  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="email">{$t('email')}</label>
    <input class="immich-form-input" id="email" bind:value={email} type="email" autocomplete="email" required />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="password">{$t('password')}</label>
    <PasswordField id="password" bind:password autocomplete="new-password" />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="confirmPassword">{$t('confirm_password')}</label>
    <PasswordField id="confirmPassword" bind:password={confirmPassword} autocomplete="new-password" />
  </div>

  {#if errorMessage}
    <p class="text-red-400">{errorMessage}</p>
  {/if}

  <div class="my-5 flex w-full">
    <Button type="submit" size="lg" fullwidth>{$t('sign_up')}</Button>
  </div>
</form>
