import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

/**
 * TurboModule spec for the erxes Messenger SDK (RN 0.81+, new architecture).
 *
 * This is a *headless* module: it has no JS-rendered UI. The native SDK owns the
 * floating launcher and decides when it is visible (after the connect handshake
 * succeeds). JS only forwards configuration and toggles the native overlay.
 *
 * Codegen turns this file into the `NativeErxesSdk` spec — keep the filename and
 * the `getEnforcing` name ("ErxesSdk") in sync with the native module name.
 */
export interface Spec extends TurboModule {
  /**
   * Configure + auto-connect. Safe to call once near app start.
   * `serverUrl` maps to the SDK's `endpoint`.
   */
  configure(config: {
    integrationId: string;
    serverUrl: string;
    fileEndpoint?: string;
    /** Launcher tint, hex string e.g. "#7C3AED". */
    primaryColor?: string;
  }): void;

  /** Identify the logged-in user. */
  setUser(user: {
    email?: string;
    phone?: string;
    name?: string;
  }): void;

  /** Clear the current user (e.g. on logout). */
  clearUser(): void;

  /** Show the native floating launcher overlay window. */
  showLauncher(): void;

  /** Hide the native floating launcher overlay window. */
  hideLauncher(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ErxesSdk');
