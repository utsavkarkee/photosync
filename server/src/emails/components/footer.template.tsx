import { Column, Img, Link, Row, Text } from '@react-email/components';
import * as React from 'react';

export const ImmichFooter = () => (
  <>
    <Row className="h-18 w-full">
      <Column align="center" className="w-6/12 sm:w-full">
        <Link href="https://app.photosync.me/">
          <Img className="h-full max-w-full" src={`https://immich.app/img/google-play-badge.png`} />
        </Link>
      </Column>
      <Column align="center" className="w-6/12 sm:w-full">
        <div className="h-full p-3">
          <Link href="https://app.photosync.me">
            <Img src={`https://immich.app/img/ios-app-store-badge.png`} alt="Immich" className="max-w-full" />
          </Link>
        </div>
      </Column>
    </Row>

    <Text className="text-center text-sm text-immich-footer">
      <Link href="https://app.photosync.me/">Photosync</Link> project is available under GNU AGPL v3 license.
    </Text>
  </>
);
