# LibWeb Writing

This tool automates editorial checks for Georgia State University Library web content using [Vale](https://vale.sh/). It relies on third-party style packages with custom rule sets for university naming, library naming, writing quality and readability.

Reports are written to [reviews](reviews) for regular content and [tests/test-reviews](tests/test-reviews) for rule tests.

## General Checks

- University naming and first-reference rules
- Library naming and location conventions
- Writing quality (grammar, punctuation, jargon, link text)
- Readability targets (12th-grade level guidance)

### Custom Rulesets

- [styles/UniversityStyle](styles/UniversityStyle)
- [styles/LibraryStyle](styles/LibraryStyle)
- [styles/WritingQualityStyle](styles/WritingQualityStyle)
- [styles/ReadabilityStyle](styles/ReadabilityStyle)

## Prerequisites

- [Vale](https://vale.sh/)
  - macOS (Homebrew): `brew install vale`

## Usage

1. Clone the repository.
2. Sync style packages:
   - `vale sync`
3. Run a single sample review:
   - `./scripts/review-file.sh </full/path/to/file.md>`
4. Run all test files in [tests](tests):
   - `./scripts/test-rules.sh`

## How Review Scripts Work

### Single File Review

Script: [scripts/review-file.sh](scripts/review-file.sh)

- Accepts full or repo-relative path, e.g. `/full/path/to/file.md` or `reviews/file.md`.
- The output file, `<input_basename>__review.md`, is written to [`reviews`](reviews)

### Rule Tests

Script: [scripts/test-rules.sh](scripts/test-rules.sh)

- Iterates over source `.md` files in [tests](tests)
- Writes output `__review.md` files into [tests/test-reviews](tests/test-reviews)

### Test Coverage

Included test files in [`tests`](tests) contain issues in order to verify that custom rules and configs work as expected.

- [tests/01-university-style-checks.md](tests/01-university-style-checks.md) checks:
  - UniversityStyle.Headings
  - UniversityStyle.Identity
  - UniversityStyle.Login
  - UniversityStyle.Time
  - UniversityStyle.Technical
  - UniversityStyle.Exclamation
  - UniversityStyle.AllCaps.
- [tests/02-library-style-checks.md](tests/02-library-style-checks.md) checks:
  - LibraryStyle.Naming,
  - LibraryStyle.Locations.
- [tests/03-writing-quality-checks.md](tests/03-writing-quality-checks.md) checks:
  - WritingQualityStyle.Commas,
  - WritingQualityStyle.Grammar,
  - WritingQualityStyle.Jargon,
  - WritingQualityStyle.LinkText,
  - WritingQualityStyle.Punctuation,
  - WritingQualityStyle.Quotes.
- [tests/04-readability-checks.md](tests/04-readability-checks.md) checks:
  - ReadabilityStyle.SentenceLength,
  - ReadabilityStyle.SentenceLengthHighRisk,
  - ReadabilityStyle.ParagraphLength.

Notes:

- Keep test source files in git.

## Configuration

- Main style config: [.vale.ini](.vale.ini)
- Readability config: [.vale-readability.ini](.vale-readability.ini)
- Output (Alert) template for reports: [styles/config/templates/alerts.tmpl](styles/config/templates/alerts.tmpl)

## Debugging

Useful commands:

```bash
# Show active Vale config for a file
vale --config=.vale.ini ls-config tests/01-university-style-checks.md

# Output JSON format
vale --config=.vale.ini --output=JSON tests/01-university-style-checks.md
```

- When debugging, check verify rule set is enabled in [.vale.ini](.vale.ini) and probleatic terms do not conflict with custom vocabulary accept/reject rules.

## Guidance Documentation

- [University Style Guide]()
- [Library Style Guide]()
- [Accessibility & Alt Text Guide]()
- [Library Website Content Guide]()
- [Readability Guide]()

## External References

### Vale

- [Vale CLI](https://vale.sh/)
- [Vale Docs](https://docs.vale.sh/)
- [Vale Config Generator](https://vale.sh/generator)

### Georgia State University

- [Writer's Style Guide (GSU)](https://commkit.gsu.edu/writers-style-guide/)
- ...

### Helpful Tools

- [Markdown Online](https://markdownonline.org/)
- [Pandoc](https://pandoc.org/)
- [Trafilatura](https://trafilatura.readthedocs.io/en/latest/index.html)
