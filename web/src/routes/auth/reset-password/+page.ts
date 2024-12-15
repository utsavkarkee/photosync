import { handleError } from '$lib/utils/handle-error';
import { getFormatter } from '$lib/utils/i18n';
import { validateToken } from '@photosync/sdk';
import type { PageLoad } from './$types';

export const load = (async () => {
  let email: string, token: string;
  let isValidToken = true;
  $: {
    const urlParams = new URLSearchParams(window.location.search);
    email = urlParams.get('email') as string;
    token = urlParams.get('token') as string;
  }
  const handleTokenValidation = async () => {
    try {
      isValidToken = await validateToken({ validateToken: { email: email, token: token, type: 'RESET' } });
    } catch (error) {
      handleError(error);
    }
  };
  await handleTokenValidation();
  const $t = await getFormatter();

  return {
    meta: {
      title: $t('reset_password'),
    },
    isValidToken: String(isValidToken),
  };
}) satisfies PageLoad;
