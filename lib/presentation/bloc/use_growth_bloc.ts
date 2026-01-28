
import { useReducer, useCallback, useEffect } from 'react';
import { BlocStatus, GrowthState, UserProfile, ProductivityEvent, AppView } from '../../domain/entities';
import { repository } from '../../data/productivity_repository';

type Action = 
  | { type: 'SET_STATUS'; payload: BlocStatus }
  | { type: 'SET_USER'; payload: UserProfile }
  | { type: 'SET_VIEW'; payload: AppView }
  | { type: 'SET_CONFIG'; payload: any }
  | { type: 'SET_PERMISSION'; payload: { key: 'camera' | 'location', val: any } }
  | { type: 'SET_ERROR'; payload: string }
  | { type: 'ADD_LOG'; payload: string }
  | { type: 'SET_TASKS'; payload: string[] };

const initialState: GrowthState = {
  status: BlocStatus.INITIAL,
  currentView: 'DASHBOARD',
  tasks: [],
  logs: ['GrowthLab Engine Initialized.'],
  config: { syncThreshold: 0, enablePremiumFeatures: false, activeCampaign: 'None' },
  permissions: { camera: 'prompt', location: 'prompt' }
};

function growthReducer(state: GrowthState, action: Action): GrowthState {
  switch (action.type) {
    case 'SET_STATUS': return { ...state, status: action.payload, errorMessage: undefined };
    case 'SET_USER': return { ...state, user: action.payload };
    case 'SET_VIEW': return { ...state, currentView: action.payload };
    case 'SET_CONFIG': return { ...state, config: action.payload };
    case 'SET_PERMISSION': return { ...state, permissions: { ...state.permissions, [action.payload.key]: action.payload.val } };
    case 'SET_ERROR': return { ...state, status: BlocStatus.ERROR, errorMessage: action.payload };
    case 'ADD_LOG': return { ...state, logs: [`[${new Date().toLocaleTimeString()}] ${action.payload}`, ...state.logs] };
    case 'SET_TASKS': return { ...state, tasks: action.payload };
    default: return state;
  }
}

export function useGrowthBloc() {
  const [state, dispatch] = useReducer(growthReducer, initialState);

  const addLog = (msg: string) => dispatch({ type: 'ADD_LOG', payload: msg });

  // Init Remote Config (Firebase Concept)
  useEffect(() => {
    repository.getAppConfig().then(config => {
      dispatch({ type: 'SET_CONFIG', payload: config });
      addLog(`Remote Config Applied: Campaign ${config.activeCampaign}`);
    });
  }, []);

  const setView = (view: AppView) => dispatch({ type: 'SET_VIEW', payload: view });

  const requestPermissions = async (type: 'camera' | 'location') => {
    addLog(`Requesting ${type} permission...`);
    // Simulate OS Dialog
    await new Promise(r => setTimeout(r, 1000));
    dispatch({ type: 'SET_PERMISSION', payload: { key: type, val: 'granted' } });
    addLog(`${type.toUpperCase()} permission granted.`);
  };

  const createUserProfile = async () => {
    dispatch({ type: 'SET_STATUS', payload: BlocStatus.LOADING });
    addLog("Firebase + CleverTap: Onboarding user...");
    try {
      const profile: UserProfile = {
        name: "Lizbeth Grisales",
        identity: "1029384756",
        email: "lgrisales.dev@example.com",
        phone: "573001234567"
      };
      const result = await repository.createUser(profile);
      dispatch({ type: 'SET_USER', payload: result });
      dispatch({ type: 'SET_STATUS', payload: BlocStatus.SUCCESS });
      addLog(`Success: User persisted in Firestore & CleverTap. ID: ${result.firebaseId}`);
    } catch (e: any) {
      dispatch({ type: 'SET_ERROR', payload: e.message });
      addLog(`Critical Failure: ${e.message}`);
    }
  };

  const completeProfile = async () => {
    if (!state.user) return dispatch({ type: 'SET_ERROR', payload: "No profile to update." });
    dispatch({ type: 'SET_STATUS', payload: BlocStatus.LOADING });
    try {
      const dob = "1992-08-15";
      await repository.addDob(state.user.identity, dob);
      dispatch({ type: 'SET_USER', payload: { ...state.user, dob } });
      dispatch({ type: 'SET_STATUS', payload: BlocStatus.SUCCESS });
      addLog("Profile Update: DOB synced with CleverTap cloud.");
    } catch (e: any) {
      dispatch({ type: 'SET_ERROR', payload: e.message });
    }
  };

  const trackProductivity = async () => {
    dispatch({ type: 'SET_STATUS', payload: BlocStatus.LOADING });
    try {
      const event: ProductivityEvent = {
        name: "Hola_mundo",
        properties: { years_mobile_experience: 8, years_flutter_experience: 5, published_apps: 12 }
      };
      await repository.recordProductivity(event);
      dispatch({ type: 'SET_STATUS', payload: BlocStatus.SUCCESS });
      addLog("Engagement: Tracked 'Hola_mundo' event successfully.");
    } catch (e: any) {
      dispatch({ type: 'SET_ERROR', payload: e.message });
    }
  };

  const syncData = async () => {
    dispatch({ type: 'SET_STATUS', payload: BlocStatus.LOADING });
    addLog("Cloud Sync: Synchronizing REST & Local data...");
    try {
      const restTasks = await repository.syncFullData();
      dispatch({ type: 'SET_TASKS', payload: [...state.tasks, ...restTasks] });
      dispatch({ type: 'SET_STATUS', payload: BlocStatus.SUCCESS });
      addLog("Sync Complete: Restored 3 external tasks via REST API.");
    } catch (e: any) {
      dispatch({ type: 'SET_ERROR', payload: e.message });
    }
  };

  const generateTasks = () => {
    const count = Math.floor(Math.random() * 400) + 1;
    const taskWords = ["Optimize", "Deploy", "Refactor", "Review", "Test", "Design"];
    const randomTasks = Array.from({ length: count }, (_, i) => 
      `${taskWords[Math.floor(Math.random() * taskWords.length)]} Sprint Task ${i + 1}`
    );
    dispatch({ type: 'SET_TASKS', payload: randomTasks });
    addLog(`Local Engine: Generated ${count} tasks.`);
  };

  return { state, setView, createUserProfile, completeProfile, trackProductivity, syncData, generateTasks, requestPermissions };
}
