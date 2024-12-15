import * as sdk from '@photosync/sdk';
import type { Mock, MockedObject } from 'vitest';

vi.mock('@photosync/sdk', async (originalImport) => {
  const module = await originalImport<typeof import('@photosync/sdk')>();

  const mocks: Record<string, Mock> = {};
  for (const [key, value] of Object.entries(module)) {
    if (typeof value === 'function') {
      mocks[key] = vi.fn();
    }
  }

  const mock = { ...module, ...mocks };
  return { ...mock, default: mock };
});

export const sdkMock = sdk as MockedObject<typeof sdk>;
