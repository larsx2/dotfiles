/**
 * File Watcher Tool - Example with state management and external execution
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { stat } from "node:fs/promises";
import * as path from "node:path";

interface WatchedFile {
	path: string;
	lastModified: number;
	size: number;
}

interface WatcherDetails {
	action: string;
	files: WatchedFile[];
	changes?: string[];
}

export default function (pi: ExtensionAPI) {
	// State: files we're watching
	let watchedFiles: Map<string, WatchedFile> = new Map();

	// Restore state from session on startup
	pi.on("session_start", async (_event, ctx) => {
		watchedFiles.clear();

		// Look for the most recent watcher state in the branch
		const branch = ctx.sessionManager.getBranch();
		for (const entry of branch.reverse()) {
			if (entry.type === "message" && entry.message.role === "toolResult") {
				if (entry.message.toolName === "file_watcher") {
					const details = entry.message.details as WatcherDetails | undefined;
					if (details?.files) {
						// Restore watched files
						for (const file of details.files) {
							watchedFiles.set(file.path, file);
						}
						break;
					}
				}
			}
		}
	});

	pi.registerTool({
		name: "file_watcher",
		label: "File Watcher",
		description: "Monitor files for changes. Actions: watch (add file), unwatch (remove file), check (check for changes), list (show watched files)",
		parameters: Type.Object({
			action: StringEnum(["watch", "unwatch", "check", "list"] as const),
			filePath: Type.Optional(Type.String({ description: "File path (for watch/unwatch actions)" })),
		}),

		async execute(toolCallId, params, signal, onUpdate, ctx) {
			const { action, filePath } = params;

			switch (action) {
				case "watch": {
					if (!filePath) {
						return {
							content: [{ type: "text", text: "Error: filePath required for watch action" }],
							details: { action, files: Array.from(watchedFiles.values()), error: "Missing filePath" },
						};
					}

					// Resolve path relative to CWD
					const fullPath = path.resolve(ctx.cwd, filePath);

					try {
						const { mtimeMs: lastModified, size } = await stat(fullPath);
						watchedFiles.set(fullPath, { path: fullPath, lastModified, size });

						return {
							content: [{ type: "text", text: `Now watching: ${fullPath}` }],
							details: { action, files: Array.from(watchedFiles.values()) },
						};
					} catch {
						return {
							content: [{ type: "text", text: `File not found: ${fullPath}` }],
							details: { action, files: Array.from(watchedFiles.values()), error: "File not found" },
						};
					}
				}

				case "unwatch": {
					if (!filePath) {
						return {
							content: [{ type: "text", text: "Error: filePath required for unwatch action" }],
							details: { action, files: Array.from(watchedFiles.values()), error: "Missing filePath" },
						};
					}

					const fullPath = path.resolve(ctx.cwd, filePath);
					if (watchedFiles.delete(fullPath)) {
						return {
							content: [{ type: "text", text: `Stopped watching: ${fullPath}` }],
							details: { action, files: Array.from(watchedFiles.values()) },
						};
					} else {
						return {
							content: [{ type: "text", text: `File was not being watched: ${fullPath}` }],
							details: { action, files: Array.from(watchedFiles.values()) },
						};
					}
				}

				case "check": {
					onUpdate?.({
						content: [{ type: "text", text: "Checking for changes..." }],
					});

					const changes: string[] = [];

					for (const [filePath, fileInfo] of watchedFiles.entries()) {
						if (signal?.aborted) break;

						try {
							const { mtimeMs: lastModified, size } = await stat(filePath);
							if (lastModified !== fileInfo.lastModified || size !== fileInfo.size) {
								changes.push(`${filePath}: Modified (size: ${fileInfo.size} → ${size} bytes)`);
								fileInfo.lastModified = lastModified;
								fileInfo.size = size;
							}
						} catch {
							changes.push(`${filePath}: File no longer exists`);
							watchedFiles.delete(filePath);
						}
					}

					const message = changes.length > 0
						? `Found ${changes.length} change(s):\n${changes.join("\n")}`
						: "No changes detected";

					return {
						content: [{ type: "text", text: message }],
						details: { action, files: Array.from(watchedFiles.values()), changes },
					};
				}

				case "list": {
					const count = watchedFiles.size;
					if (count === 0) {
						return {
							content: [{ type: "text", text: "No files are being watched" }],
							details: { action, files: [] },
						};
					}

					const fileList = Array.from(watchedFiles.values())
						.map(f => `• ${f.path} (${f.size} bytes)`)
						.join("\n");

					return {
						content: [{ type: "text", text: `Watching ${count} file(s):\n${fileList}` }],
						details: { action, files: Array.from(watchedFiles.values()) },
					};
				}

				default:
					return {
						content: [{ type: "text", text: `Unknown action: ${action}` }],
						details: { action, files: Array.from(watchedFiles.values()), error: "Unknown action" },
					};
			}
		},
	});

	// Also register a command for users to check watched files
	pi.registerCommand("watched", {
		description: "Show watched files",
		handler: async (_args, ctx) => {
			const count = watchedFiles.size;
			if (count === 0) {
				ctx.ui.notify("No files are being watched", "info");
			} else {
				const files = Array.from(watchedFiles.keys()).join("\n");
				ctx.ui.notify(`Watching ${count} files:\n${files}`, "info");
			}
		},
	});
}