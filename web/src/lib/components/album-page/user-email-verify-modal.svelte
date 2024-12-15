<script lang="ts">
  import Button from '$lib/components/elements/buttons/button.svelte';
  import FullScreenModal from '$lib/components/shared-components/full-screen-modal.svelte';
  import { user } from '$lib/stores/user.store';
  import { handleError } from '$lib/utils/handle-error';
  import { sendVerificationEmail, verifyEmailToken, type AlbumResponseDto } from '@photosync/sdk';
  import { onMount } from 'svelte';
  import { t } from 'svelte-i18n';
  import { writable } from 'svelte/store';
  import SvelteOtp from '@k4ung/svelte-otp';
  import { fade, fly } from 'svelte/transition';
  import { cubicOut } from 'svelte/easing';
  export let onClose: () => void;
  enum ViewMode {
    EMAIL_VERIFICATION_REQUEST = 'email-verification-request', // Requesting verification email
    EMAIL_VERIFICATION_SENT = 'email-verification-sent', // Email verification sent
    EMAIL_VERIFICATION_SUCCESS = 'email-verification-success', // Verification success
    EMAIL_VERIFICATION_FAILED = 'email-verification-failed', // Verification failed
  }

  let currentViewMode = writable<ViewMode>(ViewMode.EMAIL_VERIFICATION_REQUEST);
  let value = '';
  let isLoading = false;
  let errormsg = '';
  onMount(async () => {});

  const handleSendVerificationEmail = async () => {
    try {
      isLoading = true;
      await sendVerificationEmail({});
      currentViewMode.set(ViewMode.EMAIL_VERIFICATION_SENT);
      isLoading = false;
    } catch (error) {
      errormsg = handleError(error) || '';
      isLoading = false;
    }
  };
  const handleVerifyEmailToken = async () => {
    try {
      isLoading = true;
      await verifyEmailToken({ verifyEmail: { email: $user.email, token: value } });
      currentViewMode.set(ViewMode.EMAIL_VERIFICATION_SUCCESS);
    } catch (error) {
      isLoading = false;
      handleError(error);
    }
  };
  const gotoHome = () => {
    window.location.reload();
  };
</script>

<FullScreenModal title={$t('verify_email')} showLogo {onClose}>
  {#if $currentViewMode === ViewMode.EMAIL_VERIFICATION_REQUEST}
    <div>
      <div>
        <p class="text-md">To unlock storage, please verify your email</p>
      </div>
      <div class="text-left flex-grow py-4">
        <p class="text-immich-fg dark:text-immich-dark-fg">
          {$user.name}
        </p>
        <p class="text-xs">
          {$user.email}
        </p>
      </div>
    </div>
    <div class="py-3">
      <Button disabled={isLoading} size="sm" onclick={handleSendVerificationEmail} fullwidth rounded="full"
        >{$t('send')}</Button
      >
    </div>
  {:else if $currentViewMode === ViewMode.EMAIL_VERIFICATION_SENT}
    <div>
      <div class="flex justify-center py-2" transition:fly={{ y: 50, duration: 300, easing: cubicOut }}>
        <SvelteOtp
          numberOnly
          numOfInputs={4}
          bind:value
          separator="-"
          placeholder="----"
          inputClass="rounded-md bg-white mx-2 py-4 border-immich-primary"
          separatorClass="border-immich-primary text-xl font-bold"
        />
      </div>
      <div>
        {errormsg}
      </div>

      <div class="pt-4 flex gap-2">
        <Button disabled={isLoading} color="secondary" size="sm" onclick={onClose} fullwidth rounded="full"
          >{$t('cancel')}</Button
        >
        <Button disabled={isLoading} size="sm" onclick={handleVerifyEmailToken} fullwidth rounded="full"
          >{$t('Verify')}</Button
        >
      </div>
      <div class="text-center py-2">
        <button
          disabled={isLoading}
          class="text-immich-primary text-sm text-center"
          onclick={handleSendVerificationEmail}
        >
          Didn't get a code? Click to resend
        </button>
      </div>
    </div>
  {:else if $currentViewMode === ViewMode.EMAIL_VERIFICATION_SUCCESS}
    <div class="flex items-center justify-center">
      <div class="p-4 rounded" transition:fade={{ duration: 500, delay: 300 }}>
        <div class="flex flex-col items-center space-y-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="text-green-600 w-28 h-28"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="1"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <h1 class="text-4xl font-bold">Success!</h1>
          <p>Thank you for verifying your email! You can now access all the features. Enjoy using our service!</p>

          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-3 h-3 mr-2"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M7 16l-4-4m0 0l4-4m-4 4h18" />
          </svg>
          <Button class="text-sm font-medium" onclick={gotoHome}>Home</Button>
        </div>
      </div>
    </div>
  {/if}
</FullScreenModal>
