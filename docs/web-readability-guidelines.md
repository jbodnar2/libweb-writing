# Web Readability Guidelines (Sentence and Paragraph Length)

## When to Use This File

- Use this first when reports show readability and scanning findings.
- Use this when checks from LibraryReadability.SentenceLength or LibraryReadability.ParagraphLength appear.
- Use this to decide whether a warning is a true readability issue or acceptable due to necessary specificity.

This reference summarizes practical readability targets for public-facing web content in this project.

## 1. Sentence Length

- Recommended average sentence length: 15-20 words.
- Suggested warning threshold: 25+ words.
- High-risk threshold for web scanning: 30+ words.

Why:

- Shorter sentences improve scanning, comprehension, and task completion on web pages.
- Longer sentences increase cognitive load, especially for mobile users and multilingual audiences.

## 2. Paragraph Length

- Suggested warning threshold: 100+ words.
- Strong warning threshold: 140+ words.
- Additional practical cue: review paragraphs with 5+ sentences, even when word count is lower.

Why:

- Web users scan in chunks, not dense blocks.
- Shorter paragraphs improve legibility and help users locate key actions and information faster.

## 3. Accessibility and Compliance Note

- There is no single WCAG numeric limit for sentence or paragraph length.
- These thresholds are readability and usability targets, not strict accessibility conformance rules.

## 4. Recommended Project Defaults

- Sentence warnings: 25+ words.
- Paragraph suggestion: 100+ words.
- Paragraph warning: 140+ words.

These values are tuned for public service pages, policy pages, and instructional pages where clarity and scanning are primary goals.

## 5. Sources

1. U.S. Federal Plain Language Guidelines

- Recommends plain language, short sentences, and web-friendly structure.
- https://www.plainlanguage.gov/guidelines/

2. GOV.UK Content Design: Writing for GOV.UK

- Emphasizes concise sentences and short paragraphs for digital service content.
- https://www.gov.uk/guidance/content-design/writing-for-gov-uk

3. Internal GSU Writing Summary (this repo)

- Scannability guidance and short paragraph emphasis.
- See docs/gsu-style-guide.md
