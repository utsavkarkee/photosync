import { MigrationInterface, QueryRunner } from 'typeorm';

export class UpdateUser1734012434068 implements MigrationInterface {
  name = 'UpdateUser1734012434068';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "users" ADD "resetToken" character varying NOT NULL DEFAULT ''`);
    await queryRunner.query(`ALTER TABLE "users" ADD "expireResetToken" TIMESTAMP WITH TIME ZONE`);
    await queryRunner.query(`ALTER TABLE "users" ADD "emailVerifyToken" character varying NOT NULL DEFAULT ''`);
    await queryRunner.query(`ALTER TABLE "users" ADD "expireEmailVerifyToken" TIMESTAMP WITH TIME ZONE`);
    await queryRunner.query(`ALTER TABLE "users" ADD "isEmailVerify" boolean NOT NULL DEFAULT false`);
    await queryRunner.query(`ALTER TABLE "users" ALTER COLUMN "shouldChangePassword" SET DEFAULT false`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "users" ALTER COLUMN "shouldChangePassword" SET DEFAULT true`);
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "isEmailVerify"`);
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "expireEmailVerifyToken"`);
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "emailVerifyToken"`);
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "expireResetToken"`);
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "resetToken"`);
  }
}
