import { Link, Section, Text } from '@react-email/components';
import * as React from 'react';
import { ImmichButton } from 'src/emails/components/button.component';
import ImmichLayout from 'src/emails/components/immich.layout';
import { VerifyEmailProps } from 'src/interfaces/notification.interface';

export const VerifyEmail = ({ baseUrl, displayName, verificationLink }: VerifyEmailProps) => (
  <ImmichLayout preview="Verify your email to activate your Immich account.">
    <Text className="m-0">
      Hello <strong>{displayName}</strong>,
    </Text>

    <Text>
      Thank you for signing up for Immich! Please verify your email address to activate your account.
    </Text>

    <Section className="flex justify-center my-6">
      <ImmichButton href={verificationLink}>Verify Email</ImmichButton>
    </Section>

    <Text className="text-xs">
      If you cannot click the button, use the link below to verify your email:
      <br />
      <Link href={verificationLink}>{verificationLink}</Link>
    </Text>

    <Text>
      If you did not sign up for an Immich account, please disregard this email.
    </Text>
  </ImmichLayout>
);

VerifyEmail.PreviewProps = {
  baseUrl: 'https://demo.immich.app',
  displayName: 'Alan Turing',
  verificationLink: 'https://demo.immich.app/auth/verify-email?token=exampletoken',
} as VerifyEmailProps;

export default VerifyEmail;
