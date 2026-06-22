import type { EventEmitter, TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

/** A chat-mode action descriptor (header-right button or drawer top row). */
export type ActionItem = {
  /** Host-defined id, echoed back via the `onAction` event. */
  id: string;
  /** Display title (drawer rows) / accessibility label (header icons). */
  title: string;
  /** SF Symbol name, e.g. "magnifyingglass". */
  systemIcon: string;
};

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
    /** UI shell: 'classic' (4-tab widget, default) or 'chat' (ChatGPT-style). */
    displayMode?: string;
    /** Chat-mode header-right actions. Ignored in classic mode. */
    homeActions?: ActionItem[];
    /** Chat-mode drawer top action rows. Ignored in classic mode. */
    drawerActions?: ActionItem[];
  }): void;

  /** Fires when a chat-mode `homeActions`/`drawerActions` item is tapped. */
  readonly onAction: EventEmitter<{ id: string }>;

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
