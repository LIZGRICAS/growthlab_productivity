
export interface UserProfile {
  name: string;
  identity: string;
  email: string;
  phone: string;
  dob?: string;
  firebaseId?: string;
}

export interface RemoteConfig {
  syncThreshold: number;
  enablePremiumFeatures: boolean;
  activeCampaign: string;
}

export interface ProductivityEvent {
  name: "Hola_mundo";
  properties: {
    years_mobile_experience: number;
    years_flutter_experience: number;
    published_apps: number;
  };
}

export enum BlocStatus {
  INITIAL = 'INITIAL',
  LOADING = 'LOADING',
  SUCCESS = 'SUCCESS',
  ERROR = 'ERROR'
}

export type AppView = 'DASHBOARD' | 'CONFIG' | 'LOGS';

export interface GrowthState {
  status: BlocStatus;
  currentView: AppView;
  user?: UserProfile;
  tasks: string[];
  logs: string[];
  config: RemoteConfig;
  permissions: {
    camera: 'granted' | 'denied' | 'prompt';
    location: 'granted' | 'denied' | 'prompt';
  };
  errorMessage?: string;
}
