import { Link, Section, Text } from '@react-email/components';
import * as React from 'react';
import { ImmichButton } from 'src/emails/components/button.component';
import ImmichLayout from 'src/emails/components/immich.layout';
import { VerifyEmailProps } from 'src/interfaces/notification.interface';

export const VerifyEmail = ({ baseUrl, displayName, code }: VerifyEmailProps) => (
  <ImmichLayout preview="Verify your email to activate your Photosync account.">
    <Text className="m-0">
      Hello <strong>{displayName}</strong>,
    </Text>

    <Text>Thank you for signing up for Photosync! Please verify your email address to activate your account.</Text>

    <div className="flex items-center mt-4 gap-x-4">
      {Array.from(code).map((x) => (
        <p className="flex items-center justify-center w-10 h-10 text-2xl font-medium text-[#365CCE] border border-[#365CCE] rounded-md">
          {x}
        </p>
      ))}
    </div>

    <Text>If you did not sign up for an Photosync account, please disregard this email.</Text>
  </ImmichLayout>
);

VerifyEmail.PreviewProps = {
  baseUrl: 'https://demo.immich.app',
  displayName: 'Alan Turing',
  code: '234',
} as VerifyEmailProps;

export default VerifyEmail;
