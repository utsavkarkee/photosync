import type { ServerStorageResponseDto } from '@photosync/sdk';
import { writable } from 'svelte/store';

export const serverInfo = writable<ServerStorageResponseDto>();
