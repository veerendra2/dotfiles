import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default async function (pi: ExtensionAPI) {
  let modelIds: string[];
  try {
    const response = await fetch("http://localhost:11434/api/tags", {
      signal: AbortSignal.timeout(5000),
    });
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    if (
      !Array.isArray(data?.models) ||
      !data.models.every(
        (model: unknown) =>
          model !== null &&
          typeof model === "object" &&
          "name" in model &&
          typeof model.name === "string" &&
          model.name.trim().length > 0,
      )
    ) {
      throw new Error("Invalid model list returned by Ollama");
    }
    modelIds = [...new Set<string>(data.models.map((model: { name: string }) => model.name))];
  } catch (error) {
    console.warn(
      `[ollama] Model discovery failed: ${error instanceof Error ? error.message : String(error)}. Start Ollama and run /reload to retry.`,
    );
    return;
  }

  if (modelIds.length === 0) {
    console.warn("[ollama] No installed models found. Pull a model and run /reload.");
    return;
  }

  pi.registerProvider("ollama", {
    baseUrl: "http://localhost:11434/v1",
    api: "openai-completions",
    apiKey: "ollama",
    models: modelIds.map((id) => ({
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
