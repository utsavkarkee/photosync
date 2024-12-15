<script lang="ts">
  import { goto } from '$app/navigation';
  import FullscreenContainer from '$lib/components/shared-components/fullscreen-container.svelte';
  import { AppRoute } from '$lib/constants';
  import { resetSavedUser, user } from '$lib/stores/user.store';
  import { logout } from '@photosync/sdk';
  import type { PageData } from './$types';
  import { t } from 'svelte-i18n';
  import ResetPasswordForm from '$lib/components/forms/reset-password-form.svelte';
  import ForgetPasswordForm from '$lib/components/forms/forget-password-form.svelte';
  import {
    notificationController,
    NotificationType,
  } from '$lib/components/shared-components/notification/notification';

  export let data: PageData;

  const onSuccess = async () => {
    await goto(AppRoute.AUTH_LOGIN);
 
    notificationController.show({
      message: 'A password reset token has been sent to your email. Please check your inbox to reset your password.',
      type: NotificationType.Info,
    });
  };
</script>

<FullscreenContainer title={data.meta.title}>
  <!-- <p slot="message">
    {$t('hi_user', { values: { name: $user.name, email: $user.email } })}
    <br />
    <br />
    {$t('change_password_description')}
  </p> -->

  <ForgetPasswordForm {onSuccess} />

  <button on:click={() => goto('login')}> Back to Login </button>
</FullscreenContainer>
