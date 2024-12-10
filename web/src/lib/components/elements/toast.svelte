<!-- Toast.svelte -->
<script lang="ts">
  export let message: string = 'User Registered Successfully!';
  export let visible: boolean = false;
  export let duration: number = 3000; // Duration for the toast to be visible in milliseconds
  let timer: NodeJS.Timeout;

  // Automatically hide the toast after the specified duration
  import { onDestroy } from 'svelte';

  onDestroy(() => {
    if (timer) {
      clearTimeout(timer);
    }
  });

  // Automatically hide the toast after the duration
  $: if (visible) {
    timer = setTimeout(() => {
      visible = false;
    }, duration);
  }
</script>

{#if visible}
  <div class="toast">
    {message}
  </div>
{/if}

<style>
  .toast {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background-color: #28a745;
    color: white;
    padding: 10px 20px;
    border-radius: 5px;
    font-size: 16px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    animation:
      slideIn 0.5s ease-in-out,
      fadeOut 0.5s 2.5s ease-in-out;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      bottom: 0;
    }
    to {
      opacity: 1;
      bottom: 20px;
    }
  }

  @keyframes fadeOut {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }
</style>
