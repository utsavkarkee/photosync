<script lang="ts">
  import { goto } from '$app/navigation';
  import FullscreenContainer from '$lib/components/shared-components/fullscreen-container.svelte';
  import { AppRoute } from '$lib/constants';
  import { resetSavedUser, user } from '$lib/stores/user.store';
  import { logout } from '@immich/sdk';
  import type { PageData } from './$types';
  import { t } from 'svelte-i18n';
  import ResetPasswordForm from '$lib/components/forms/reset-password-form.svelte';
  import {
    notificationController,
    NotificationType,
  } from '$lib/components/shared-components/notification/notification';

  export let data: PageData;
  let tokenValid: boolean = Boolean(data.isValidToken);

  const onSuccess = async () => {
    notificationController.show({
      message: 'Your password has been reset successfully. You can now log in with your new password.',
      type: NotificationType.Info,
    });
    await goto(AppRoute.AUTH_LOGIN);
    resetSavedUser();
    await logout();
  };
</script>

{#if data.isValidToken =="false"}
  <FullscreenContainer title={data.meta.title}>
    <div class="error-container">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="50" height="50" fill="red">
        <path
          d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12S18.627 0 12 0zm0 22C6.48 22 2 17.52 2 12S6.48 2 12 2s10 4.48 10 10-4.48 10-10 10zM13 9V7h-2v2h2zm0 4v-2h-2v2h2z"
        />
      </svg>
      <p>Invalid token !!</p>
    </div>
    <button on:click={() => goto('login')}> Back to Login </button>
  </FullscreenContainer>
{:else}
  <FullscreenContainer title={data.meta.title}>
    <ResetPasswordForm {onSuccess} />
  </FullscreenContainer>
{/if}

<style>
  .error-container {
    text-align: center;
    color: red;
    font-size: 1.2em;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .error-container svg {
    margin-bottom: 1em;
  }
</style>
