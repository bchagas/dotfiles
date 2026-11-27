import { test } from "node:test";
import assert from "node:assert/strict";
import {
  cleanUrl,
  countUrls,
  formatContent,
  formatLink,
  fromSelection,
  isUrl,
  lengthWarning,
  siteName,
  stripTracking,
  wrapUrls,
} from "../src/format.ts";

const KABUM = "https://www.kabum.com.br/produto/997883/placa-de-video";

test("a list of links wraps each one and keeps the blank lines", () => {
  const list = `${KABUM}\n\n${KABUM}\n\n${KABUM}`;
  assert.equal(wrapUrls(list), `<${KABUM}>\n\n<${KABUM}>\n\n<${KABUM}>`);
});

test("text around links is kept as it is", () => {
  assert.equal(
    wrapUrls("look: https://a.com and https://b.com/x?y=1"),
    "look: <https://a.com> and <https://b.com/x?y=1>",
  );
});

test("punctuation after a link stays outside the brackets", () => {
  assert.equal(wrapUrls("see https://a.com/x."), "see <https://a.com/x>.");
  assert.equal(wrapUrls("(see https://a.com/x)"), "(see <https://a.com/x>)");
  assert.equal(wrapUrls("wiki https://x.com/a_(b), ok"), "wiki <https://x.com/a_(b)>, ok");
});

test("links already wrapped or masked are not wrapped twice", () => {
  assert.equal(wrapUrls("<https://a.com>"), "<https://a.com>");
  assert.equal(wrapUrls("[a](<https://a.com>)"), "[a](<https://a.com>)");
  assert.equal(wrapUrls("[a](https://a.com)"), "[a](<https://a.com>)");
});

test("countUrls counts every link in the content", () => {
  assert.equal(countUrls(`${KABUM}\n\n${KABUM}`), 2);
  assert.equal(countUrls("[a](<https://a.com>) https://b.com"), 2);
  assert.equal(countUrls("no links"), 0);
});

test("formatContent uses the text for a single link", () => {
  assert.equal(formatContent("Kabum", KABUM), `[Kabum](<${KABUM}>)`);
  assert.equal(formatContent("", `  ${KABUM}\n`), `<${KABUM}>`);
  assert.equal(formatContent(KABUM, ""), `<${KABUM}>`);
});

test("formatContent wraps every link of a list and ignores the text", () => {
  assert.equal(formatContent("kabum", `${KABUM}\n\n${KABUM}`), `<${KABUM}>\n\n<${KABUM}>`);
});

test("formatContent gives nothing without a link", () => {
  assert.equal(formatContent("kabum", "no links here"), undefined);
  assert.equal(formatContent("kabum", ""), undefined);
});

test("text and url make a masked link", () => {
  assert.equal(formatLink("google", "https://google.com"), "[google](<https://google.com>)");
});

test("no text gives the bare url in angle brackets", () => {
  assert.equal(formatLink("", "https://google.com"), "<https://google.com>");
  assert.equal(formatLink("   ", "https://google.com"), "<https://google.com>");
});

test("a url typed as the text becomes the link", () => {
  assert.equal(formatLink("https://google.com", ""), "<https://google.com>");
});

test("brackets in the text are escaped", () => {
  assert.equal(formatLink("a [b]", "https://x.com"), "[a \\[b\\]](<https://x.com>)");
});

test("an invalid url gives no link", () => {
  assert.equal(formatLink("google", "google.com"), undefined);
  assert.equal(formatLink("google", ""), undefined);
});

test("cleanUrl trims and undoes earlier formatting", () => {
  assert.equal(cleanUrl("  https://google.com\r\n"), "https://google.com");
  assert.equal(cleanUrl("<https://google.com>"), "https://google.com");
  assert.equal(cleanUrl("[kabum](<https://www.kabum.com.br/produto/1>)"), "https://www.kabum.com.br/produto/1");
  assert.equal(cleanUrl("[a](https://x.com/a_(b))"), "https://x.com/a_(b)");
});

test("cleanUrl drops clipboard text that is not a url", () => {
  assert.equal(cleanUrl("some copied sentence"), "");
  assert.equal(cleanUrl(undefined), "");
});

test("isUrl accepts only http and https", () => {
  assert.ok(isUrl("https://google.com/a?b=1&c=2"));
  assert.ok(isUrl("http://localhost:3000"));
  assert.ok(!isUrl("ftp://x.com"));
  assert.ok(!isUrl("https://has space.com"));
});

test("selected words become the link text", () => {
  assert.deepEqual(fromSelection("kabum"), { text: "kabum", urls: "" });
  assert.deepEqual(fromSelection("  placa\nde vídeo  "), { text: "placa de vídeo", urls: "" });
});

test("a selection holding links is the content, not the text", () => {
  assert.deepEqual(fromSelection(` ${KABUM} `), { text: "", urls: KABUM });
  assert.deepEqual(fromSelection(`a ${KABUM}\n${KABUM}`), { text: "", urls: `a ${KABUM}\n${KABUM}` });
});

test("no selection gives nothing", () => {
  assert.deepEqual(fromSelection(""), { text: "", urls: "" });
  assert.deepEqual(fromSelection("   \n "), { text: "", urls: "" });
});

test("siteName is the domain before its suffix, in lowercase", () => {
  assert.equal(siteName("https://dexscreener.com/solana/aircdeu4"), "dexscreener");
  assert.equal(siteName("https://www.kabum.com.br/produto/997883"), "kabum");
  assert.equal(siteName("https://docs.google.com/document/d/1"), "google");
  assert.equal(siteName("https://bbc.co.uk/news"), "bbc");
  assert.equal(siteName("https://github.com/bchagas/dotfiles"), "github");
  assert.equal(siteName("http://localhost:3000/x"), "localhost");
  assert.equal(siteName("http://192.168.0.1/admin"), "192.168.0.1");
  assert.equal(siteName("not a url"), "");
});

test("named: a single link gets the site name unless a text is given", () => {
  assert.equal(formatContent("", KABUM, { named: true }), `[kabum](<${KABUM}>)`);
  assert.equal(formatContent("Placa", KABUM, { named: true }), `[Placa](<${KABUM}>)`);
  assert.equal(formatContent("", KABUM), `<${KABUM}>`);
});

test("named: every bare link of a list gets its site name", () => {
  assert.equal(
    formatContent("", `${KABUM}\n\nlook https://dexscreener.com/x.`, { named: true }),
    `[kabum](<${KABUM}>)\n\nlook [dexscreener](<https://dexscreener.com/x>).`,
  );
});

test("named: links already masked or wrapped keep their form", () => {
  assert.equal(wrapUrls("[a](https://a.com) <https://b.com>", { named: true }), "[a](<https://a.com>) <https://b.com>");
});

test("named: repeated site names are numbered, unique ones are not", () => {
  const list = `${KABUM}\n\nhttps://dexscreener.com/x\n\n${KABUM}/2\n${KABUM}/3`;
  assert.equal(
    wrapUrls(list, { named: true }),
    `[kabum 1](<${KABUM}>)\n\n[dexscreener](<https://dexscreener.com/x>)\n\n[kabum 2](<${KABUM}/2>)\n[kabum 3](<${KABUM}/3>)`,
  );
});

test("named: masked and wrapped links do not count toward the numbering", () => {
  assert.equal(
    wrapUrls(`[a](${KABUM}) <${KABUM}> ${KABUM}`, { named: true }),
    `[a](<${KABUM}>) <${KABUM}> [kabum](<${KABUM}>)`,
  );
});

test("formatting characters in the text are escaped so Discord shows them as typed", () => {
  assert.equal(formatLink("meu_projeto", KABUM), `[meu\\_projeto](<${KABUM}>)`);
  assert.equal(
    formatLink("**promo** ~x~ `c` ||s||", KABUM),
    "[\\*\\*promo\\*\\* \\~x\\~ \\`c\\` \\|\\|s\\|\\|](<" + KABUM + ">)",
  );
  assert.equal(formatLink("a\\b", KABUM), `[a\\\\b](<${KABUM}>)`);
});

test("stripTracking drops tracking parameters and keeps the rest as written", () => {
  assert.equal(stripTracking("https://a.com/x?utm_source=tw&id=5&fbclid=abc#top"), "https://a.com/x?id=5#top");
  assert.equal(stripTracking("https://a.com/x?utm_source=tw&UTM_MEDIUM=y"), "https://a.com/x");
  assert.equal(stripTracking("https://a.com/x?gclid=1#frag"), "https://a.com/x#frag");
  assert.equal(stripTracking("https://a.com/?q=a%20b&utm_medium=x"), "https://a.com/?q=a%20b");
  assert.equal(stripTracking("https://a.com/x?ref=home&page=2"), "https://a.com/x?ref=home&page=2");
  assert.equal(stripTracking("https://a.com/x"), "https://a.com/x");
});

test("untrack applies to a single link and to every link of a list", () => {
  assert.equal(formatContent("", `${KABUM}?utm_source=x`, { named: true, untrack: true }), `[kabum](<${KABUM}>)`);
  assert.equal(formatContent("", `${KABUM}?utm_source=x`), `<${KABUM}?utm_source=x>`);
  assert.equal(
    formatContent("", `${KABUM}?fbclid=1\n[a](https://b.com/?gclid=2)`, { untrack: true }),
    `<${KABUM}>\n[a](<https://b.com/>)`,
  );
});

test("lengthWarning flags content over Discord's 2000 characters", () => {
  assert.equal(lengthWarning("a".repeat(2000)), undefined);
  assert.equal(lengthWarning("a".repeat(2345)), "2345 characters: over Discord's 2000 limit (4000 with Nitro)");
});
