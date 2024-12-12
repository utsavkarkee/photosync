import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsEmail, IsEnum, IsNotEmpty, IsString, MinLength } from 'class-validator';
import { APIKeyEntity } from 'src/entities/api-key.entity';
import { SessionEntity } from 'src/entities/session.entity';
import { SharedLinkEntity } from 'src/entities/shared-link.entity';
import { UserEntity } from 'src/entities/user.entity';
import { ImmichCookie } from 'src/enum';
import { toEmail } from 'src/validation';

export type CookieResponse = {
  isSecure: boolean;
  values: Array<{ key: ImmichCookie; value: string }>;
};

export class AuthDto {
  user!: UserEntity;

  apiKey?: APIKeyEntity;
  sharedLink?: SharedLinkEntity;
  session?: SessionEntity;
}

export class LoginCredentialDto {
  @IsEmail({ require_tld: false })
  @Transform(toEmail)
  @IsNotEmpty()
  @ApiProperty({ example: 'testuser@email.com' })
  email!: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty({ example: 'password' })
  password!: string;
}

export class LoginResponseDto {
  accessToken!: string;
  userId!: string;
  userEmail!: string;
  name!: string;
  profileImagePath!: string;
  isAdmin!: boolean;
  shouldChangePassword!: boolean;
}

export function mapLoginResponse(entity: UserEntity, accessToken: string): LoginResponseDto {
  return {
    accessToken,
    userId: entity.id,
    userEmail: entity.email,
    name: entity.name,
    isAdmin: entity.isAdmin,
    profileImagePath: entity.profileImagePath,
    shouldChangePassword: entity.shouldChangePassword,
  };
}

export class LogoutResponseDto {
  successful!: boolean;
  redirectUri!: string;
}

export class SignUpDto extends LoginCredentialDto {
  @IsString()
  @IsNotEmpty()
  @ApiProperty({ example: 'Admin' })
  name!: string;
}

export class ChangePasswordDto {
  @IsString()
  @IsNotEmpty()
  @ApiProperty({ example: 'password' })
  password!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @ApiProperty({ example: 'password' })
  newPassword!: string;
}

export class ResetPasswordDto {
  @IsString()
  @IsNotEmpty()
  token!: string;

  @IsString()
  @IsNotEmpty()
  email!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @ApiProperty({ example: 'password' })
  newPassword!: string;
}

export class VerifyEmailDto {
  @IsString()
  @IsNotEmpty()
  token!: string;

  @IsString()
  @IsNotEmpty()
  email!: string;
}

export class ForgetPasswordDto {
  @IsString()
  @IsNotEmpty()
  email!: string;
}
export class ValidateTokenDto {
  @IsString()
  @IsNotEmpty()
  token!: string;

  @IsString()
  @IsNotEmpty()
  email!: string;

  @IsEnum(['RESET', 'VERIFYEMAIL'])
  @IsNotEmpty()
  @ApiProperty({ example: 'RESET', enum: ['RESET', 'VERIFYEMAIL'] })
  type!: 'RESET' | 'VERIFYEMAIL';
}

export class ValidateAccessTokenResponseDto {
  authStatus!: boolean;
}

export class OAuthCallbackDto {
  @IsNotEmpty()
  @IsString()
  @ApiProperty()
  url!: string;
}

export class OAuthConfigDto {
  @IsNotEmpty()
  @IsString()
  redirectUri!: string;
}

export class OAuthAuthorizeResponseDto {
  url!: string;
}
