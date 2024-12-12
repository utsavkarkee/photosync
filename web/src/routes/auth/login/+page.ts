import { AppRoute } from '$lib/constants';
import { serverConfig } from '$lib/stores/server-config.store';
import { getFormatter } from '$lib/utils/i18n';

import { user } from '$lib/stores/user.store';
import { authenticate } from '$lib/utils/auth';
import { redirect } from '@sveltejs/kit';
import { isEmpty } from 'lodash-es';
import { get } from 'svelte/store';
import type { PageLoad } from './$types';

export const load = (async ({ parent }) => {

  await parent();
  const { isInitialized } = get(serverConfig);

  if (!isInitialized) {
    // Admin not registered
    redirect(302, AppRoute.AUTH_REGISTER);
  }

  const $t = await getFormatter();
  return {
    meta: {
      title: $t('login'),
      titleSignUp: $t('signup'),
    },
  };
}) satisfies PageLoad;
