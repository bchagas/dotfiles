import { closeMainWindow, Clipboard, getFrontmostApplication, getSelectedText, PopToRootType } from "@raycast/api";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const DISCORD = "com.hnc.Discord";
const run = promisify(execFile);
const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function isDiscordInFront(): Promise<boolean> {
  const app = await getFrontmostApplication().catch(() => undefined);
  return app?.bundleId === DISCORD;
}

// Only Discord's selection counts: text selected in a browser is never meant as a title
export async function discordSelection(): Promise<string> {
  if (!(await isDiscordInFront())) return "";
  return getSelectedText().catch(() => "");
}

// pgrep, not `open`: opening a closed Discord would take the paste before it loaded
async function isDiscordRunning(): Promise<boolean> {
  try {
    await run("/usr/bin/pgrep", ["-x", "Discord"]);
    return true;
  } catch {
    return false;
  }
}

async function bringDiscordToFront(): Promise<boolean> {
  await run("/usr/bin/open", ["-b", DISCORD]);
  for (let i = 0; i < 20; i++) {
    if (await isDiscordInFront()) return true;
    await sleep(50);
  }
  return false;
}

export type PasteResult = "pasted" | "closed" | "no focus";

// Pastes into the field Discord had focused (the message box, normally), replacing its
// selection, and never sends. Raycast's window stays open when Discord is closed, so a
// form can still show the error; otherwise it closes before the switch.
export async function pasteInDiscord(content: string): Promise<PasteResult> {
  if (!(await isDiscordRunning())) return "closed";
  await closeMainWindow({ clearRootSearch: true, popToRootType: PopToRootType.Immediate });
  if (!(await bringDiscordToFront())) return "no focus";
  // Lets Discord give focus back to the field it had before the switch
  await sleep(100);
  // Explicitly plain text: <https://…> must not be read as an HTML tag
  await Clipboard.paste({ text: content });
  return "pasted";
}
