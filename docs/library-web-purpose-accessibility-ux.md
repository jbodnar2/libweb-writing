# Library Website Purpose, Accessibility, and UX Guide (Consolidated)

This guide summarizes the purpose of the library website and practical accessibility/UX standards for public-facing web content.

## 1. Website Purpose and Role

- The library website should function as a service platform, not just a promotional brochure.
- Core goals:
  - Help users complete tasks quickly (hours, access, borrowing, contact, appointments).
  - Support learning and research for students, faculty, staff, and community members.
  - Provide clear pathways to services, spaces, collections, and assistance.
- Voice and framing:
  - Mission-driven, welcoming, and practical.
  - Emphasize access, inclusion, and user success.

## 2. UX Principles for Library Web Pages

- Put task-critical content first (what users need now).
- Use clear, descriptive headings and short sections.
- Use plain language and scannable chunks.
- Keep navigation and labels consistent across pages.
- Use descriptive links (avoid vague link text).
- Prefer action-oriented calls to action for service tasks.

## 3. Accessibility Expectations (Operational)

- Ensure content is perceivable, operable, understandable, and robust.
- Minimum practical target: WCAG 2.2 AA compliance for page content and interactions.
- Prioritize:
  - Keyboard accessibility for all controls.
  - Sufficient color contrast.
  - Correct heading hierarchy.
  - Meaningful link text.
  - Text alternatives for non-text content.
  - Clear form labels and error instructions.

## 4. Image and Alt Text Guidance

### 4.1 When alt text is required

- Informative images: provide concise, meaningful alt text.
- Functional images (icons/buttons that trigger actions): alt text should describe the action.
- Complex images (charts/diagrams/maps): provide short alt text plus nearby text summary.

### 4.2 When to use empty alt text

- Decorative images that add no informational value should use empty alt text (`alt=""`).
- Do not repeat nearby visible text in alt text.

### 4.3 Alt text quality rules

- Describe purpose and meaning, not every visual detail.
- Keep concise (typically one short phrase or sentence).
- Avoid starting with "Image of" or "Picture of" unless needed for meaning.
- For linked images, describe destination/action (for example, "View library hours").

### 4.4 Common mistakes to avoid

- Missing alt on meaningful images.
- File names used as alt text.
- Keyword stuffing in alt text.
- Redundant alt text that duplicates adjacent captions/headings.

## 5. Content Patterns for Service Pages

- Start with key service facts:
  - who the service is for
  - what the service does
  - where/how to access it
  - constraints (hours, appointment rules, eligibility)
- Provide direct contact options near task steps.
- Break policy details into short subsections with informative headings.
- For location content, include clear physical access details and alternatives.

## 6. Accessibility and UX QA Checklist (Editorial)

- Headings are clear and in logical order.
- Links are descriptive and make sense out of context.
- Paragraphs are short enough for scanning.
- Lists are used for steps, requirements, and options.
- Images have correct alt treatment (informative vs decorative).
- Contact, help, and feedback options are easy to find.
- Critical task information appears above long background/context text.

## 7. Source and Reference Links

1. WCAG 2.2 (W3C)

- https://www.w3.org/TR/WCAG22/

2. WAI Images Tutorial (W3C)

- https://www.w3.org/WAI/tutorials/images/

3. WAI Alt Decision Tree (W3C)

- https://www.w3.org/WAI/tutorials/images/decision-tree/

4. Plain Language Guidelines (U.S. Government)

- https://www.plainlanguage.gov/guidelines/

5. GOV.UK Content Design: Writing for GOV.UK

- https://www.gov.uk/guidance/content-design/writing-for-gov-uk

6. Project references in this repository

- docs/gsu-libraries-styl-guide.md
- docs/gsu-style-guide.md
- docs/web-readability-guidelines.md
