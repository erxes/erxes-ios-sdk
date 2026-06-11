import { useEffect } from 'react';
import NativeErxesSdk from './NativeErxesSdk';

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
}: ErxesSDKProps): null {
  // Configure + (re)connect whenever the connection inputs change.
  useEffect(() => {
    NativeErxesSdk.configure({ integrationId, serverUrl, fileEndpoint, primaryColor });
  }, [integrationId, serverUrl, fileEndpoint, primaryColor]);

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
