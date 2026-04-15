# LibWeb Writing

This repository runs automated editorial checks for Georgia State University Library web content using [Vale](https://vale.sh/). It combines third-party style packages with custom rule sets for university naming, library naming, writing quality and readability.

Generated review reports are written to the [reviews](reviews) directory.

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
   - `./review.sh /full/path/to/file.md`
4. Run all test files in [tests](tests):
   - `./review-tests.sh`

## How Review Scripts Work

### Single File Review

Script: [review.sh](review.sh)

- Accepts a full file path.
- Also accepts repo-relative paths and legacy paths relative to [reviews](reviews).
- Example input: `/full/path/to/file.md`
- Output file pattern: `<input_basename>__review.md` in [reviews](reviews)

Example:

```bash
./review.sh /full/path/to/file.md
# writes: reviews/file__review.md
```

### Test Sweep

Script: [review-tests.sh](review-tests.sh)

- Iterates over source `.md` files in [tests](tests)
- Skips files already ending in `__review.md`
- Writes output `__review.md` files into [reviews/tests](reviews/tests)

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
