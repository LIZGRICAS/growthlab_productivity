
export class RestService {
  private baseUrl = "https://api.growthlab.io/v1";

  async getExternalTasks(): Promise<string[]> {
    console.log(`[REST] GET ${this.baseUrl}/tasks`);
    await new Promise(r => setTimeout(r, 1500));
    return [
      "REST: Implement OAuth2 Flow",
      "REST: Optimize API Latency",
      "REST: Schema Migration v2"
    ];
  }
}

export const restService = new RestService();
