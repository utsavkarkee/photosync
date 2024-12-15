<script lang="ts">
  import { goto } from '$app/navigation';
  import { AppRoute } from '$lib/constants';
  import { login, signUpUser } from '@photosync/sdk';
  import { getServerErrorMessage, handleError } from '../../utils/handle-error';
  import Button from '../elements/buttons/button.svelte';
  import PasswordField from '../shared-components/password-field.svelte';
  import { notificationController, NotificationType } from '../shared-components/notification/notification';
  import { featureFlags, serverConfig } from '$lib/stores/server-config.store';
  import { oauth } from '$lib/utils';
  import { t } from 'svelte-i18n';
  import { retrieveServerConfig } from '$lib/stores/server-config.store';
  import { onMount } from 'svelte';
  import LoadingSpinner from '$lib/components/shared-components/loading-spinner.svelte';
  import { fade } from 'svelte/transition';

  export let onSuccess: () => unknown | Promise<unknown>;
  export let onFirstLogin: () => unknown | Promise<unknown>;

  let email = '';
  let password = '';
  let confirmPassword = '';
  let name = '';

  let oauthError = '';
  let loading = false;
  let oauthLoading = true;

  let errorMessage: string;
  let canRegister = false;

  onMount(async () => {
    if (!$featureFlags.oauth) {
      oauthLoading = false;
      return;
    }

    if (oauth.isCallback(window.location)) {
      try {
        await oauth.login(window.location);
        await onSuccess();
        return;
      } catch (error) {
        console.error('Error [login-form] [oauth.callback]', error);
        oauthError = getServerErrorMessage(error) || $t('errors.unable_to_complete_oauth_login');
        oauthLoading = false;
      }
    }

    try {
      if ($featureFlags.oauthAutoLaunch && !oauth.isAutoLaunchDisabled(window.location)) {
        await goto(`${AppRoute.AUTH_LOGIN}?autoLaunch=0`, { replaceState: true });
        await oauth.authorize(window.location);
        return;
      }
    } catch (error) {
      handleError(error, $t('errors.unable_to_connect'));
    }

    oauthLoading = false;
  });

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
      await signUpUser({ signUpDto: { email, password, name, notify: true, shouldChangePassword: false } });
      await retrieveServerConfig();

      await handleLogin();
    } catch (error) {
      handleError(error, $t('errors.unable_to_create_user_account'));
      errorMessage = $t('errors.unable_to_create_user_account');
    }
  }

  const handleLogin = async () => {
    try {
      errorMessage = '';
      loading = true;
      const user = await login({ loginCredentialDto: { email, password } });

      if (user.isAdmin && !$serverConfig.isOnboarded) {
        // await onOnboardi();
        return;
      }

      if (!user.isAdmin && user.shouldChangePassword) {
        await onFirstLogin();
        return;
      }
      await onSuccess();
      return;
    } catch (error) {
      errorMessage = getServerErrorMessage(error) || $t('errors.incorrect_email_or_password');
      loading = false;
      return;
    }
  };

  const handleOAuthLogin = async () => {
    oauthLoading = true;
    oauthError = '';
    const success = await oauth.authorize(window.location);
    if (!success) {
      oauthLoading = false;
      oauthError = $t('errors.unable_to_login_with_oauth');
    }
  };
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
{#if $featureFlags.oauth}
  {#if $featureFlags.passwordLogin}
    <div class="inline-flex w-full items-center justify-center">
      <hr class="my-4 h-px w-3/4 border-0 bg-gray-200 dark:bg-gray-600" />
      <span
        class="absolute left-1/2 -translate-x-1/2 bg-white px-3 font-medium text-gray-900 dark:bg-immich-dark-gray dark:text-white"
      >
        {$t('or')}
      </span>
    </div>
  {/if}
  <div class="my-5 flex flex-col gap-5">
    {#if oauthError}
      <p class="text-center text-red-400" transition:fade>{oauthError}</p>
    {/if}
    <Button
      type="button"
      disabled={loading || oauthLoading}
      size="lg"
      fullwidth
      color={$featureFlags.passwordLogin ? 'secondary' : 'primary'}
      on:click={handleOAuthLogin}
    >
      {#if oauthLoading}
        <span class="h-6">
          <LoadingSpinner />
        </span>
      {:else}
        {$serverConfig.oauthButtonText}
      {/if}
    </Button>
  </div>
{/if}

{#if !$featureFlags.passwordLogin && !$featureFlags.oauth}
  <p class="p-4 text-center dark:text-immich-dark-fg">{$t('login_has_been_disabled')}</p>
{/if}
