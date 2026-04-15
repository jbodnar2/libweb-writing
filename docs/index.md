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
| `GSU.Identity`, `Library.Naming`, `Library.Locations`, `Library.Time`, `Library.Login`       | [library-style-guide.md](./library-style-guide.md), [university-style-guide.md](./university-style-guide.md) | Institutional and library-specific conventions                     |
| `ReadabilityStyle.SentenceLength`, `ReadabilityStyle.ParagraphLength`                        | [readability-style-guide.md](./readability-style-guide.md)                                                | Readability thresholds and rationale                               |
| Content structure and task clarity                                                            | [library-service-content-guide.md](./library-service-content-guide.md)                                    | Service-page purpose and usability expectations                    |
| Accessibility and alt text treatment                                                          | [accessibility-and-alt-text-guide.md](./accessibility-and-alt-text-guide.md)                              | Accessibility and image text alternative standards                 |
| Generic package checks (`Microsoft.*`, `proselint.*`, `write-good.*`, `alex.*`, `Joblint.*`) | Start with project docs above, then apply judgment                                                       | Some generic checks are lower-priority than institutional guidance |

## What Each Guidance File Is For

- [university-style-guide.md](./university-style-guide.md)
  - Use for university-wide language, time/date, punctuation, and tone rules.

- [library-style-guide.md](./library-style-guide.md)
  - Use for library naming, addresses, floors, links, and service-page mechanics.

- [readability-style-guide.md](./readability-style-guide.md)
  - Use for sentence/paragraph thresholds and readability interpretation.

- [library-service-content-guide.md](./library-service-content-guide.md)
  - Use for page purpose, task flow, and service-content usability guidance.

- [accessibility-and-alt-text-guide.md](./accessibility-and-alt-text-guide.md)
  - Use for accessibility expectations and alt text treatment.

## Quick Triage by Report Pattern

- Many repeated findings of one type:
  - Fix a repeated pattern in source content first, then rerun report.

- Report says readability above target:
  - Shorten long sentences, split long paragraphs, move key action info higher.

- Naming/location/time conflicts:
  - Prioritize institutional correctness over stylistic preference.

- Accessibility/UX concerns:
  - Verify heading order, descriptive links, contact pathways, and alt text treatment.
