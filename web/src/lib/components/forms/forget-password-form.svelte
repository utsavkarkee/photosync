<script lang="ts">
  import Button from '../elements/buttons/button.svelte';
  import PasswordField from '../shared-components/password-field.svelte';
  import { login, forgetPassword } from '@photosync/sdk';
  import { t } from 'svelte-i18n';

  export let onSuccess: () => void;
  import { page } from '$app/stores';
  import { handleError } from '$lib/utils/handle-error';

  let errorMessage: string;
  let success: string;

  let email = '';

  let valid = false;

  // Email regex for basic validation
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

  // Reactive statement to check if email is valid
  $: {
    if (email.length > 0 && !emailRegex.test(email)) {
      errorMessage = 'Invalid email address';
      valid = false;
    } else {
      errorMessage = '';
      valid = true;
    }
  }

  async function handleSubmit() {
    if (valid) {
      errorMessage = '';
      try {
        await forgetPassword({ forgetPassword: { email: String(email) } });

        onSuccess();
      } catch (error) {
        handleError(error);
      }
    }
  }
</script>

<form on:submit|preventDefault={handleSubmit} method="post" class="mt-5 flex flex-col gap-5">
  <div class="my-4 flex flex-col gap-2">
    <label class="immich-form-label" for="email">{$t('email')}</label>
    <input class="immich-form-input" id="email" bind:value={email} type="email" required />
  </div>

  {#if errorMessage}
    <p class="text-sm text-red-400">{errorMessage}</p>
  {/if}

  {#if success}
    <p class="text-sm text-immich-primary">{success}</p>
  {/if}
  <div class="my-5 flex w-full">
    <Button type="submit" size="lg" fullwidth>{$t('send')}</Button>
  </div>
</form>
