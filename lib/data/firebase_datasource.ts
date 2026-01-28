
import { UserProfile, RemoteConfig } from '../domain/entities';

export class FirebaseDataSource {
  async saveToFirestore(user: UserProfile): Promise<string> {
    console.log('[Firebase] Firestore: Saving user document...');
    await new Promise(r => setTimeout(r, 1200));
    return `fs_doc_${Math.random().toString(36).substr(2, 9)}`;
  }

  async fetchRemoteConfig(): Promise<RemoteConfig> {
    console.log('[Firebase] RemoteConfig: Fetching parameters...');
    await new Promise(r => setTimeout(r, 500));
    return {
      syncThreshold: 5,
      enablePremiumFeatures: true,
      activeCampaign: "Q1_Growth_Sprint"
    };
  }

  async uploadLogToStorage(log: string): Promise<string> {
    console.log('[Firebase] Storage: Uploading log dump...');
    return "https://storage.googleapis.com/growth-lab/logs/dump_001.txt";
  }
}

export const firebaseDataSource = new FirebaseDataSource();
