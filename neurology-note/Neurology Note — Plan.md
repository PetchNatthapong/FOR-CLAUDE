# Neurology Note — Plan

Written 2026-11-09 following the Round Mize app-writing guide (section 2). A first version already exists as a working prototype (`neurology-note.html`). This plan covers the real app: what to keep from the prototype and what changes to match how Round Mize is built.

## 1. Goal and users

- **User:** NPC, neurology fellow (internal medicine background). Main interests: stroke, epilepsy and movement disorders.
- **Devices:** iPhone first (pinning from a lecture, a ward round or a journal club), then iPad and Mac for review.
- **Three jobs it must do well:**
  1. **Pin fast:** a photo, a video, a camera shot, a PDF or pasted text, in under 10 seconds, with one thumb.
  2. **Explain the pin:** a brief summary, key points and the source paper with a DOI that has been checked against PubMed.
  3. **Track learning:** each topic is New, Learning or Done, with dates added, started and completed, grouped by subspecialty and subtopic.
- **Not in v1:** sharing with other people, a social feed, spaced-repetition flashcards, a citation manager export, or more than one user.

## 2. Screens

| Screen | What it shows | What you can do there |
|---|---|---|
| Board | Pin cards in a masonry grid (photo, or the headline figure such as "6-24 h"), with the status pill and date added | Filter by status, search, sort, open a pin, add a pin (bottom-right button) |
| Subspecialties | Round Mize's 15 categories as round bubbles; each ring fills with the % of pins that are Done. Pins with none show under "Not sorted" | Pick one to filter the board; its subtopics appear as smaller bubbles |
| Pin detail | Media, title, dates, status, summary, key points, my notes, sources (with a PubMed check mark), tags | Change status, edit, delete (to Trash, with Undo) |
| New / edit pin | Photo, Video, Camera and File buttons, drop or paste area, text, link or DOI | Auto-fill (summary + sources), choose subspecialty and subtopic, status, start date, add a DOI or PMID |
| Settings | Subspecialty and subtopic lists, page order, display, account and sync, backup, app version | Rename, add or reorder subtopics; export or restore a backup; update the app |
| Trash | Pins deleted in the last 7 days | Restore, or delete for good |

## 3. Data model

| Field | Type | Rule |
|---|---|---|
| `uid` | string | Random, the same on every device; sync uses it |
| `id` | number (`++id`) | Local only, used in routes (`#/p/12`) |
| `title` | string | Required; Auto-fill writes one if empty (under 80 characters) |
| `sub` | string | One Round Mize category id (stroke, epilepsy, movement, …), or empty for "Not sorted" |
| `cat` | string | Subtopic; from the subspecialty's list or typed new |
| `status` | `new` / `learning` / `done` | Learning sets `startDate` if empty; Done sets `doneDate` |
| `createdAt`, `updatedAt` | ISO time | `updatedAt` decides sync conflicts (later wins) |
| `startDate`, `doneDate` | `YYYY-MM-DD` | Shown as "Nov 5"; Learning shows the day count "D3" |
| `summary` | string | 2-4 sentences, take-home message first |
| `keyPoints` | string[] | 3-5 items |
| `keyFigure` | `{value, label}` or null | The number on the card cover, e.g. "60 mg/kg - levetiracetam load" |
| `tags` | string[] | Lowercase, up to 8 |
| `body` | string | My own notes, never overwritten by Auto-fill |
| `link` | string | URL, DOI or PMID |
| `sources` | `{pmid, doi, title, journal, year, author, via, verified}[]` | Only PubMed or Crossref results count as verified |
| `media` | `{kind, name, type, size, blobId, posterBlobId}[]` | Photos shrunk to 1,800 px JPEG; videos get a still frame |
| `dirty`, `deletedAt` | flag, time | Sync and the 7-day Trash; deleting for good leaves a tombstone |

## 4. Privacy and data safety

- These are study notes, not patient records, but photos of slides, scans or EEGs can still show a patient. The app says so on the pin screen: "Crop out names, HN and faces before pinning."
- Pins are saved on the device first. If sync is turned on, it uses the Round Mize model: encrypted on the device, and the server stores only ciphertext.
- Auto-fill is the one feature that sends content off the device (see decision D1). It sends only the text and photos of the pin you're working on, and only when you tap Auto-fill.

## 5. Tech stack

| Option | Pros | Cons |
|---|---|---|
| **A. Keep the prototype** (single HTML page as a Claude Artifact) | Already works; Claude writes summaries and reads photos; the PubMed connector checks DOIs; storage comes with your Claude account | Opens only inside claude.ai; no offline use or home-screen app; uses Google Fonts; the code sits in a public repo |
| **B. Round Mize stack** (Vite + React 19 + TS, Tailwind 4, Dexie, PWA, Cloudflare Pages + D1, Web Crypto sync) | Same as Round Mize: offline, installs on iPhone, encrypted sync, code is private, components can be reused | More to build; Auto-fill needs a small server function and a Claude API key (D1) |
| **C. B now, with A as the reference** | You can try the prototype today while B is built | Two versions exist for a while |

**Recommended: C.** Build the real app on the Round Mize stack and keep the prototype as the clickable reference until B passes the ward test.

## 6. Build roadmap

| Phase | Builds | Test that ends it |
|---|---|---|
| 1 | Board, subspecialty bubbles, pin detail, status, Dexie storage, autosave, Trash + Undo | Pin 10 topics on the iPhone during one teaching session, offline |
| 2 | Photo, video, camera and file capture; still frame for video; images shrunk on the device | Pin a slide photo and a 30 s clip in Airplane Mode; both open later |
| 3 | Auto-fill: `functions/api/autofill.ts` (Claude) and `functions/api/pubmed.ts` (NCBI) | Pin a journal-club abstract; check that the summary is right and the DOI opens the correct paper |
| 4 | Encrypted sync (reusing Round Mize's `crypto.ts` and `sync.ts`), backup and restore | Pin on the iPhone and see it on the Mac; check that the D1 rows hold only ciphertext |
| 5 | Settings: subtopic lists, page order, Large text, version card + Update now | Add a subtopic on the iPad and see it on the iPhone |

## 7. Decisions

Decided:
- Subspecialty list: the same 15 categories as Round Mize, with the same ids, names, order and keywords (sent from Round Mize on 2026-11-09). If you've edited the list in Round Mize on a device, tell me and I'll match it.
- Keyword suggestions use Round Mize's matching rules, on the device: title x3, summary / key points / tags x2, notes x1. The top 2 show as dashed chips until you pick one.
- One subspecialty per pin (Round Mize allows several per case), because each subspecialty is its own swipe page. Subtopics stay as the second level, editable in Settings.
- Status words: New, Learning, Done. Dates shown as "Nov 5"; learning day shown as "D3".
- Brand colour: cresyl violet (the Nissl stain) instead of Round Mize teal, so the two apps are easy to tell apart. The greys lean toward violet.
- Names fixed before any real data: Pages project `neurology-note`, D1 `neurology-note` / `neurology-note-preview`, IndexedDB `neurology-note`, crypto salt prefix `neurology-note/sync/v2/`.

Decided on 2026-11-09 (owner's answers):
- [x] **D1 - Auto-fill goes through the app's own server.** The browser talks only to the app's own site. Pages Functions call Claude (owner's API key, stored as a Cloudflare secret) and PubMed/Crossref. Only the pin you tap Auto-fill on is sent. This is the one agreed exception to "no third parties".
- [x] **D2 - Subcategories as round bubbles; pages like Round Mize** (revised 2026-11-09). The swipe row is **All pins | Settings**: swipe left on All pins for Settings, right to come back, dots at the bottom on phones. Each subspecialty is its own page, opened from its bubble (a right swipe goes back). Inside it, subtopics are round bubbles whose ring fills with % done.
- [x] **D3 - The code lives in a new private GitHub repo.** Deploy by direct upload with Wrangler from the Mac. The prototype stays in `for-claude` as the reference.

- [x] **D4 - Sync in v1, like Round Mize.** Username and password, end-to-end encrypted, same Settings card, sign-in and sign-out wording.
- [x] **D5 - Its own account and database**, separate from Round Mize. The same username and password can be used in both; the data never mixes.
- [x] **D6 - Code in a private GitHub repo** (2026-11-10), so any chat can edit the app, including a cloud chat while the Mac is off. GitHub puts it online with the same Wrangler direct upload: the `preview` branch updates the preview copy, and `main` updates the live app only after NPC's Yes. Every chat runs `git pull` before changing anything. The repo stays private; the Round Mize guide's rule is no *public* repo.
