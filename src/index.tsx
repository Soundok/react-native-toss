import NativeToss from './NativeToss';

export type TossLoginSuccessResult = {
  type: 'success';
  authCode: string;
};

export type TossLoginErrorResult = {
  type: 'error';
  code: string;
  message: string;
};

export type TossLoginCancelledResult = {
  type: 'cancelled';
};

export type TossLoginResult =
  | TossLoginSuccessResult
  | TossLoginErrorResult
  | TossLoginCancelledResult;

export const TossLogin = {
  configure(appKey: string): void {
    NativeToss.configure(appKey);
  },

  async isLoginAvailable(): Promise<boolean> {
    return NativeToss.isLoginAvailable();
  },

  async login(policy?: string): Promise<TossLoginResult> {
    try {
      const authCode = await NativeToss.login(policy ?? null);
      return { type: 'success', authCode };
    } catch (error: any) {
      if (error.code === 'CANCELLED') {
        return { type: 'cancelled' };
      }
      return {
        type: 'error',
        code: error.code ?? 'UNKNOWN',
        message: error.message ?? 'Unknown error',
      };
    }
  },

  moveToBridgePageForNoApp(): void {
    NativeToss.moveToBridgePageForNoApp();
  },

  async handleOpenUrl(url: string): Promise<boolean> {
    return NativeToss.handleOpenUrl(url);
  },
};
