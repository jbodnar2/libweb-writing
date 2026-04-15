# LibWeb Writing

This repository runs automated editorial checks for Georgia State University Library web content using [Vale](https://vale.sh/). It combines third-party style packages with custom rule sets for university naming, library naming, writing quality and readability.

Generated review reports are written to [reviews](reviews) for regular content and [tests/test-reviews](tests/test-reviews) for rule-check test runs.

## What This Repo Enforces

- University naming and first-reference rules
- Library naming and location conventions
- Writing quality (grammar, punctuation, jargon, link text)
- Readability targets (12th-grade level guidance)

Primary custom rule directories:

- [styles/UniversityStyle](styles/UniversityStyle)
- [styles/LibraryStyle](styles/LibraryStyle)
- [styles/WritingQualityStyle](styles/WritingQualityStyle)
- [styles/ReadabilityStyle](styles/ReadabilityStyle)

## Prerequisites

- Vale installed and available in your shell
  - macOS (Homebrew): `brew install vale`

## Quick Start

1. Clone the repository.
2. Sync style packages:
   - `vale sync`
3. Run a single sample review:
   - `./scripts/review-file.sh /full/path/to/file.md`
4. Run all test files in [tests](tests):
   - `./scripts/test-rules.sh`

## How Review Scripts Work

### Single File Review

Script: [scripts/review-file.sh](scripts/review-file.sh)

- Accepts a full file path.
- Also accepts repo-relative paths.
- Example input: `/full/path/to/file.md`
- Output file pattern: `<input_basename>__review.md` in [reviews](reviews)

Example:

```bash
./scripts/review-file.sh /full/path/to/file.md
# writes: reviews/file__review.md
```

### Test Sweep

Script: [scripts/test-rules.sh](scripts/test-rules.sh)

- Iterates over source `.md` files in [tests](tests)
- Writes output `__review.md` files into [tests/test-reviews](tests/test-reviews)

### Test Validation Coverage

The test files in [tests](tests) are intentionally written with known issues so you can verify that custom rules and configs still work after changes.

- [tests/01-university-style-checks.md](tests/01-university-style-checks.md)
  Checks: UniversityStyle.Headings, UniversityStyle.Identity, UniversityStyle.Login, UniversityStyle.Time, UniversityStyle.Technical, UniversityStyle.Exclamation, UniversityStyle.AllCaps.
- [tests/02-library-style-checks.md](tests/02-library-style-checks.md)
  Checks: LibraryStyle.Naming, LibraryStyle.Locations.
- [tests/03-writing-quality-checks.md](tests/03-writing-quality-checks.md)
  Checks: WritingQualityStyle.Commas, WritingQualityStyle.Grammar, WritingQualityStyle.Jargon, WritingQualityStyle.LinkText, WritingQualityStyle.Punctuation, WritingQualityStyle.Quotes.
- [tests/04-readability-checks.md](tests/04-readability-checks.md)
  Checks: ReadabilityStyle.SentenceLength, ReadabilityStyle.SentenceLengthHighRisk, ReadabilityStyle.ParagraphLength.

Notes:

- Test files are synthetic and are not expected to be style-compliant.
- Keep test source files in version control as a regression set.

## Configuration

- Main style/mechanics config: [.vale.ini](.vale.ini)
- Readability-focused config: [.vale-readability.ini](.vale-readability.ini)
- Alert template used by reports: [styles/config/templates/alerts.tmpl](styles/config/templates/alerts.tmpl)

## Policy Guardrails

- First reference should use "Georgia State University".
- Secondary references may use "Georgia State", "GSU" or "the university".
- Avoid "GSU" in headings/titles.
- Use "the library" (lowercase) for generic secondary reference.
- Do not add `GSU` to [styles/config/vocabularies/UniversityAndAcademicTerms/accept.txt](styles/config/vocabularies/UniversityAndAcademicTerms/accept.txt), or it can suppress expected acronym/name checks.

## Debugging Rule Behavior

Useful commands:

```bash
# Show active Vale config for a file
vale --config=.vale.ini ls-config tests/01-university-style-checks.md

# Emit JSON alerts for deeper inspection
vale --config=.vale.ini --output=JSON tests/01-university-style-checks.md
```

Notes:

- Vale commonly exits non-zero when alerts are found.
- When debugging, verify both rule enablement in [.vale.ini](.vale.ini) and vocabulary accept lists.

## Project Docs

- [Editor Guide Index](docs/index.md)
- [University Style Guide Notes](docs/university-style-guide.md)
- [Library Style Guide](docs/library-style-guide.md)
- [Readability Style Guide](docs/readability-style-guide.md)
- [Library Service Content Guide](docs/library-service-content-guide.md)
- [Accessibility and Alt Text Guide](docs/accessibility-and-alt-text-guide.md)

## External References

### Vale

- [Vale CLI](https://vale.sh/)
- [Vale Docs](https://docs.vale.sh/)
- [Vale Config Generator](https://vale.sh/generator)

### Georgia State University

- [Writer's Style Guide (GSU)](https://commkit.gsu.edu/writers-style-guide/)

### Supporting Tools

- [Markdown Online](https://markdownonline.org/)
- [Pandoc](https://pandoc.org/)
- [Trafilatura](https://trafilatura.readthedocs.io/en/latest/index.html)
