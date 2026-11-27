import { Clipboard, showHUD } from "@raycast/api";
import { discordSelection, pasteInDiscord } from "./discord";
import { formatContent, fromSelection } from "./format";

// No form: the clipboard links go into Discord as [Site](<url>). Words selected in
// Discord become the text of a single link instead, and the link replaces them.
export default async function Command() {
  const selection = fromSelection(await discordSelection());
  const content = selection.urls || (await Clipboard.readText()) || "";
  const link = formatContent(selection.text, content, true);
  if (!link) {
    await showHUD("No link on the clipboard");
    return;
  }

  const result = await pasteInDiscord(link);
  if (result !== "pasted") {
    await Clipboard.copy(link);
    await showHUD(
      result === "closed"
        ? "Discord is closed; the link was copied"
        : "Discord did not come to the front; the link was copied",
    );
  }
}
