# INVESTX

Investment analysis and portfolio monitoring workspace.

## Reports & Dashboards

| File | Description |
|------|-------------|
| `INVESTX_Deep_Analysis.html` | Full deep-dive analysis of 30 assets across AI Core, AI Layer 2, Frontier, and Dividend/ETF groups (May 2026) |
| `valuation_framework.html` | Academic-grade stock valuation framework (Damodaran, Graham, Mauboussin, Greenblatt, Fama-French, Howard Marks) |
| `NVDA_Analysis.html` | NVDA pre-earnings interactive analysis card — May 19, 2026 |
| `NVDA_Analysis.xlsx` | NVDA Excel model: financials, DCF valuation, framework checklist, charts |

## Live on GitHub Pages
- [Portfolio Dashboard](https://petchnatthapong.github.io/FOR-CLAUDE/INVESTX_Deep_Analysis.html)
- [Valuation Framework](https://petchnatthapong.github.io/FOR-CLAUDE/valuation_framework.html)
- [NVDA Analysis Card](https://petchnatthapong.github.io/FOR-CLAUDE/NVDA_Analysis.html)

## Neurology Note (`neurology-note/`)
A Pinterest-style pinboard for neurology fellowship study notes.
- Pin photos, videos, camera shots, PDFs or pasted text; organize by 14 subspecialties with round subtopic bubbles (ring = % done)
- **Auto-fill** writes a brief summary, key points and a headline figure, suggests subspecialty/subtopic and tags, and finds sources with DOIs verified against PubMed
- Status per topic: New → Learning (day count from start date) → Done, with dates added/started/completed
- `index.html` opens standalone in any browser (saves in that browser; on-device summary; PubMed via NCBI E-utilities)
- `neurology-note.html` is the published Artifact source (saves to your Claude account; Claude summaries incl. photos; PubMed connector)
- `build.sh` regenerates `index.html` from `neurology-note.html`

