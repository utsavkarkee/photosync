import { QueryParameter } from '$lib/constants';
import type { MetadataSearchDto } from '@photosync/sdk';

export function getMetadataSearchQuery(metadata: MetadataSearchDto) {
  const searchParams = new URLSearchParams({
    [QueryParameter.QUERY]: JSON.stringify(metadata),
  });
  return searchParams.toString();
}
