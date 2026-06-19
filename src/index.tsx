import { useEffect } from 'react';
import NativeErxesSdk from './NativeErxesSdk';
import type { ActionItem } from './NativeErxesSdk';

export type { ActionItem };

export type ErxesUser = {
  email?: string;
  phone?: string;
  name?: string;
};

export type ErxesSDKProps = {
  integrationId: string;
  serverUrl: string;
  fileEndpoint?: string;
  /** Launcher tint, hex string e.g. "#7C3AED". */
  primaryColor?: string;
  /** Optional identified user. */
  user?: ErxesUser;
  /**
   * Whether the native floating launcher is shown. Visibility is *owned by the
   * native SDK* — when true the launcher appears automatically once the connect
   * handshake completes. Defaults to true.
   */
  visible?: boolean;
  /**
   * UI shell. 'classic' (default) is the 4-tab widget shown as a sheet; 'chat'
   * is a ChatGPT/Claude-style full-screen shell with a left conversation drawer.
   */
  displayMode?: 'classic' | 'chat';
  /** Chat-mode header-right actions. Ignored in classic mode. */
  homeActions?: ActionItem[];
  /** Chat-mode drawer top action rows. Ignored in classic mode. */
  drawerActions?: ActionItem[];
  /** Called with the action `id` when a home/drawer action is tapped. */
  onAction?: (id: string) => void;
};

/**
 * Headless erxes Messenger entry point. Drop it once near the root of your app:
 *
 * ```tsx
 * <ErxesSDK
 *   integrationId="YOUR_INTEGRATION_ID"
 *   serverUrl="https://your.erxes.instance"
 *   user={{ email, name }}
 * />
 * ```
 *
 * It renders nothing. The native SDK draws and positions the floating launcher
 * in its own overlay window and decides when it is visible — there is no JS
 * `<Button>` to wire up.
 */
export function ErxesSDK({
  integrationId,
  serverUrl,
  fileEndpoint,
  primaryColor,
  user,
  visible = true,
  displayMode,
  homeActions,
  drawerActions,
  onAction,
}: ErxesSDKProps): null {
  // Configure + (re)connect whenever the connection inputs change.
  useEffect(() => {
    NativeErxesSdk.configure({
      integrationId,
      serverUrl,
      fileEndpoint,
      primaryColor,
      displayMode,
      homeActions,
      drawerActions,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [integrationId, serverUrl, fileEndpoint, primaryColor, displayMode]);

  // Subscribe to chat-mode action taps.
  useEffect(() => {
    if (!onAction) return;
    const sub = NativeErxesSdk.onAction((e) => onAction(e.id));
    return () => sub.remove();
  }, [onAction]);

  // Push the identified user separately so changing the user doesn't reconnect.
  useEffect(() => {
    if (user) {
      NativeErxesSdk.setUser(user);
    } else {
      NativeErxesSdk.clearUser();
    }
  }, [user?.email, user?.phone, user?.name]);

  // Native owns visibility; this just toggles the overlay window.
  useEffect(() => {
    if (visible) {
      NativeErxesSdk.showLauncher();
    } else {
      NativeErxesSdk.hideLauncher();
    }
    return () => NativeErxesSdk.hideLauncher();
  }, [visible]);

  return null;
}

/** Imperative escape hatch if you'd rather not mount the component. */
export const Erxes = NativeErxesSdk;

export default ErxesSDK;
