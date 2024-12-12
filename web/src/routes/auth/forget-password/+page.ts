import { AppRoute } from '$lib/constants';
import { user } from '$lib/stores/user.store';
import { authenticate } from '$lib/utils/auth';
import { getFormatter } from '$lib/utils/i18n';
import { redirect } from '@sveltejs/kit';
import { get } from 'svelte/store';
import type { PageLoad } from './$types';

export const load = (async () => {
  const $t = await getFormatter();

  return {
    meta: {
      title: $t('Forget password'),
    },
  };
}) satisfies PageLoad;
