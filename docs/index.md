# Editor Guide Index

Use this file as the first stop when reviewing report output for web page content.

## How to Use This Index

1. Start with report severity and check name.
2. Use the crosswalk below to jump to the right guidance file.
3. Fix in priority order:
   - Identity/factual/location correctness
   - Accessibility and usability blockers
   - Readability/scannability
   - Style polish and consistency

## Alert-to-Guidance Crosswalk

| Report check examples                                                                        | Where to look first                                                                                      | Why                                                                |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `GSU.Identity`, `Library.Naming`, `Library.Locations`, `Library.Time`, `Library.Login`       | [gsu-libraries-styl-guide.md](./gsu-libraries-styl-guide.md), [gsu-style-guide.md](./gsu-style-guide.md) | Institutional and library-specific conventions                     |
| `LibraryReadability.SentenceLength`, `LibraryReadability.ParagraphLength`                    | [web-readability-guidelines.md](./web-readability-guidelines.md)                                         | Readability thresholds and rationale                               |
| Content structure, task clarity, image alt text, link usefulness                             | [library-web-purpose-accessibility-ux.md](./library-web-purpose-accessibility-ux.md)                     | UX/accessibility expectations for public web content               |
| Generic package checks (`Microsoft.*`, `proselint.*`, `write-good.*`, `alex.*`, `Joblint.*`) | Start with project docs above, then apply judgment                                                       | Some generic checks are lower-priority than institutional guidance |

## What Each Guidance File Is For

- [gsu-style-guide.md](./gsu-style-guide.md)
  - Use for university-wide language, time/date, punctuation, and tone rules.

- [gsu-libraries-styl-guide.md](./gsu-libraries-styl-guide.md)
  - Use for library naming, addresses, floors, links, and service-page mechanics.

- [web-readability-guidelines.md](./web-readability-guidelines.md)
  - Use for sentence/paragraph thresholds and readability interpretation.

- [library-web-purpose-accessibility-ux.md](./library-web-purpose-accessibility-ux.md)
  - Use for page purpose, user-task orientation, accessibility, and alt text guidance.

## Quick Triage by Report Pattern

- Many repeated findings of one type:
  - Fix a repeated pattern in source content first, then rerun report.

- Report says readability above target:
  - Shorten long sentences, split long paragraphs, move key action info higher.

- Naming/location/time conflicts:
  - Prioritize institutional correctness over stylistic preference.

- Accessibility/UX concerns:
  - Verify heading order, descriptive links, contact pathways, and alt text treatment.
