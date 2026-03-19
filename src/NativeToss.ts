import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  configure(appKey: string): void;
  isLoginAvailable(): Promise<boolean>;
  login(policy: string | null): Promise<string>;
  moveToBridgePageForNoApp(): void;
  handleOpenUrl(url: string): Promise<boolean>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Toss');
