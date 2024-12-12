import { Link, Section, Text } from '@react-email/components';
import * as React from 'react';
import { ImmichButton } from 'src/emails/components/button.component';
import ImmichLayout from 'src/emails/components/immich.layout';
import { ResetPasswordProps } from 'src/interfaces/notification.interface';

export const ResetPassword = ({ baseUrl, displayName, resetLink }: ResetPasswordProps) => (
  <ImmichLayout preview="Reset your password to regain access to your Immich account.">
    <Text className="m-0">
      Hello <strong>{displayName}</strong>,
    </Text>

    <Text>
      We received a request to reset your password for your Immich account. Click the button below to reset your password.
    </Text>

    <Section className="flex justify-center my-6">
      <ImmichButton href={resetLink}>Reset Password</ImmichButton>
    </Section>

    <Text className="text-xs">
      If you cannot click the button, use the link below to reset your password:
      <br />
      <Link href={resetLink}>{resetLink}</Link>
    </Text>

    <Text>
      If you did not request a password reset, please disregard this email. Your account is still secure.
    </Text>
  </ImmichLayout>
);

ResetPassword.PreviewProps = {
  baseUrl: 'https://demo.immich.app',
  displayName: 'Alan Turing',
  resetLink: 'https://demo.immich.app/auth/reset-password?token=exampletoken',
} as ResetPasswordProps;

export default ResetPassword;
