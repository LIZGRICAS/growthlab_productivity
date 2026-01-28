
import { UserProfile, ProductivityEvent, RemoteConfig } from '../domain/entities';
import { cleverTapDataSource } from './clevertap_datasource';
import { firebaseDataSource } from './firebase_datasource';
import { restService } from './rest_datasource';

export class ProductivityRepository {
  async createUser(profile: UserProfile): Promise<UserProfile> {
    // 1. Create in CleverTap
    await cleverTapDataSource.onboardUser(profile);
    // 2. Persist in Firebase Firestore (Senior Requirement)
    const firebaseId = await firebaseDataSource.saveToFirestore(profile);
    return { ...profile, firebaseId };
  }

  async addDob(identity: string, dob: string): Promise<void> {
    await cleverTapDataSource.updateProfile(identity, { dob });
  }

  async recordProductivity(event: ProductivityEvent): Promise<void> {
    await cleverTapDataSource.trackEvent(event);
  }

  async syncFullData(): Promise<string[]> {
    // Simulated heavy operation (7s) + REST fetching
    return new Promise(async (resolve) => {
      setTimeout(async () => {
        const externalTasks = await restService.getExternalTasks();
        resolve(externalTasks);
      }, 7000);
    });
  }

  async getAppConfig(): Promise<RemoteConfig> {
    return await firebaseDataSource.fetchRemoteConfig();
  }
}

export const repository = new ProductivityRepository();
