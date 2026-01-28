
import { UserProfile, ProductivityEvent } from '../domain/entities';

/**
 * CleverTapDataSource simulates the official CleverTap SDK behavior.
 * In a real Flutter/React implementation, this would wrap the native library.
 */
export class CleverTapDataSource {
  async onboardUser(profile: UserProfile): Promise<void> {
    console.log('[CleverTap] onUserLogin:', profile);
    // Simulate API latency
    return new Promise((resolve) => setTimeout(resolve, 800));
  }

  async updateProfile(identity: string, attributes: Partial<UserProfile>): Promise<void> {
    console.log(`[CleverTap] profilePush for ${identity}:`, attributes);
    return new Promise((resolve) => setTimeout(resolve, 600));
  }

  async trackEvent(event: ProductivityEvent): Promise<void> {
    console.log(`[CleverTap] eventTrack: ${event.name}`, event.properties);
    return new Promise((resolve) => setTimeout(resolve, 500));
  }
}

export const cleverTapDataSource = new CleverTapDataSource();
