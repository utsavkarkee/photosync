<script lang="ts">
  import { goto } from '$app/navigation';
  import LoginForm from '$lib/components/forms/login-form.svelte';
  import Toast from '$lib/components/elements/toast.svelte';
  import FullscreenContainer from '$lib/components/shared-components/fullscreen-container.svelte';
  import { AppRoute } from '$lib/constants';
  import { featureFlags, serverConfig } from '$lib/stores/server-config.store';
  import type { PageData } from './$types';
  import UserSignUpForm from '$lib/components/forms/user-registration-form.svelte';

  export let data: PageData;
  let isLogin = true;
  let isUserCreated = false;
</script>

{#if $featureFlags.loaded}
  <FullscreenContainer
    title={isLogin ? data.meta.title : data.meta.titleSignUp}
    showMessage={!!$serverConfig.loginPageMessage}
  >
    <p slot="message">
      <!-- eslint-disable-next-line svelte/no-at-html-tags -->
      {@html $serverConfig.loginPageMessage}
    </p>

    {#if isLogin}
      <LoginForm
        onSuccess={async () => await goto(AppRoute.PHOTOS, { invalidateAll: true })}
        onFirstLogin={async () => await goto(AppRoute.AUTH_CHANGE_PASSWORD)}
        onOnboarding={async () => await goto(AppRoute.AUTH_ONBOARDING)}
      />
    {:else}
      <UserSignUpForm
        onSuccess={() => {
          (isLogin = !isLogin), (isUserCreated = true);
        }}
      />
    {/if}
    <!-- <Toast message={'this is my msg'} visible={isUserCreated} duration={3000} /> -->

    <button on:click={() => (isLogin = !isLogin)}>
      {isLogin ? "Don't have an account? Sign Up" : 'You already have an accoount?Sign In '}
    </button>
  </FullscreenContainer>
{/if}
