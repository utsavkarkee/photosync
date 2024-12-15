import type { MemoryLaneResponseDto } from '@photosync/sdk';
import { writable } from 'svelte/store';

export const memoryStore = writable<MemoryLaneResponseDto[]>();
