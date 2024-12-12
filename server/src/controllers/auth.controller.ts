import { Body, Controller, HttpCode, HttpStatus, Post, Req, Res } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Request, Response } from 'express';
import {
  AuthDto,
  ChangePasswordDto,
  ForgetPasswordDto,
  LoginCredentialDto,
  LoginResponseDto,
  LogoutResponseDto,
  ResetPasswordDto,
  SignUpDto,
  ValidateAccessTokenResponseDto,
  ValidateTokenDto,
  VerifyEmailDto,
} from 'src/dtos/auth.dto';
import { UserAdminCreateDto, UserAdminResponseDto } from 'src/dtos/user.dto';
import { AuthType, ImmichCookie } from 'src/enum';
import { Auth, Authenticated, GetLoginDetails } from 'src/middleware/auth.guard';
import { AuthService, LoginDetails } from 'src/services/auth.service';
import { UserAdminService } from 'src/services/user-admin.service';
import { respondWithCookie, respondWithoutCookie } from 'src/utils/response';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(
    private service: AuthService,
    private userAdminService: UserAdminService,
  ) {}

  @Post('login')
  async login(
    @Body() loginCredential: LoginCredentialDto,
    @Res({ passthrough: true }) res: Response,
    @GetLoginDetails() loginDetails: LoginDetails,
  ): Promise<LoginResponseDto> {
    const body = await this.service.login(loginCredential, loginDetails);
    return respondWithCookie(res, body, {
      isSecure: loginDetails.isSecure,
      values: [
        { key: ImmichCookie.ACCESS_TOKEN, value: body.accessToken },
        { key: ImmichCookie.AUTH_TYPE, value: AuthType.PASSWORD },
        { key: ImmichCookie.IS_AUTHENTICATED, value: 'true' },
      ],
    });
  }

  @Post('admin-sign-up')
  signUpAdmin(@Body() dto: SignUpDto): Promise<UserAdminResponseDto> {
    return this.service.adminSignUp(dto);
  }

  @Post('user-sign-up')
  createUserAdmin(@Body() createUserDto: UserAdminCreateDto): Promise<UserAdminResponseDto> {
    return this.userAdminService.create(createUserDto);
  }

  @Post('validateToken')
  @HttpCode(HttpStatus.OK)
  @Authenticated()
  validateAccessToken(): ValidateAccessTokenResponseDto {
    return { authStatus: true };
  }

  @Post('change-password')
  @HttpCode(HttpStatus.OK)
  @Authenticated()
  changePassword(@Auth() auth: AuthDto, @Body() dto: ChangePasswordDto): Promise<UserAdminResponseDto> {
    return this.service.changePassword(auth, dto);
  }

  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  resetPassword(@Body() dto: ResetPasswordDto): Promise<UserAdminResponseDto> {
    return this.service.resetPassword(dto);
  }

  @Post('forget-password')
  @HttpCode(HttpStatus.OK)
  forgetPassword(@Body() dto: ForgetPasswordDto): Promise<Boolean> {
    return this.service.forgetPassword(dto);
  }

  @Post('validate-token')
  @HttpCode(HttpStatus.OK)
  validateToken(@Body() dto: ValidateTokenDto): Promise<Boolean> {
    return this.service.validateTokenInfo(dto);
  }

  @Post('send-verification-email')
  @HttpCode(HttpStatus.OK)
  @Authenticated()
  sendVerificationEmail(@Auth() auth: AuthDto): Promise<Boolean> {
    return this.service.sendVerificationEmail(auth);
  }

  @Post('verify-email')
  @HttpCode(HttpStatus.OK)
  emailVerification(@Body() dto: VerifyEmailDto): Promise<Boolean> {
    return this.service.verifyEmail(dto);
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @Authenticated()
  async logout(
    @Req() request: Request,
    @Res({ passthrough: true }) res: Response,
    @Auth() auth: AuthDto,
  ): Promise<LogoutResponseDto> {
    const authType = (request.cookies || {})[ImmichCookie.AUTH_TYPE];

    const body = await this.service.logout(auth, authType);
    return respondWithoutCookie(res, body, [
      ImmichCookie.ACCESS_TOKEN,
      ImmichCookie.AUTH_TYPE,
      ImmichCookie.IS_AUTHENTICATED,
    ]);
  }
}
