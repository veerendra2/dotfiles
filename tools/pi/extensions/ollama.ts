import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerProvider("ollama", {
    baseUrl: "http://localhost:11434/v1",
    api: "openai-completions",
    apiKey: "ollama",
    models: [
      "gpt-oss:latest",
      "glm-4.7-flash:latest",
      "gemma4:latest",
    ].map((id) => ({
      id,
      name: `${id} (Ollama)`,
      reasoning: false,
      input: ["text"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      // Match these budgets to the context configured on the Ollama server.
      contextWindow: 32768,
      maxTokens: 4096,
      compat: {
        supportsDeveloperRole: false,
        supportsReasoningEffort: false,
      },
    })),
  });
}
