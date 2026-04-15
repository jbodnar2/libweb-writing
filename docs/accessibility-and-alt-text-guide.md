# Accessibility and Alt Text Guide

## When to Use This File

- Use this first when reviewing accessibility requirements and image text alternatives.
- Use this when findings indicate heading/link issues, missing accessibility support, or unclear alt text treatment.
- Use this with the service content guide when both usability and accessibility issues appear on the same page.

This guide summarizes practical accessibility expectations for public-facing library content.

## 1. Accessibility Expectations (Operational)

- Ensure content is perceivable, operable, understandable, and robust.
- Minimum practical target: WCAG 2.2 AA compliance for page content and interactions.
- Prioritize:
  - Keyboard accessibility for all controls.
  - Sufficient color contrast.
  - Correct heading hierarchy.
  - Meaningful link text.
  - Text alternatives for non-text content.
  - Clear form labels and error instructions.

## 2. Image and Alt Text Guidance

### 2.1 When alt text is required

- Informative images: provide concise, meaningful alt text.
- Functional images (icons/buttons that trigger actions): alt text should describe the action.
- Complex images (charts/diagrams/maps): provide short alt text plus nearby text summary.

### 2.2 When to use empty alt text

- Decorative images that add no informational value should use empty alt text (`alt=""`).
- Do not repeat nearby visible text in alt text.

### 2.3 Alt text quality rules

- Describe purpose and meaning, not every visual detail.
- Keep concise (typically one short phrase or sentence).
- Avoid starting with "Image of" or "Picture of" unless needed for meaning.
- For linked images, describe destination/action (for example, "View library hours").

### 2.4 Common mistakes to avoid

- Missing alt on meaningful images.
- File names used as alt text.
- Keyword stuffing in alt text.
- Redundant alt text that duplicates adjacent captions/headings.

## 3. Accessibility QA Checklist (Editorial)

- Heading order is logical and complete.
- Link text is descriptive and clear out of context.
- Images have correct alt treatment (informative vs decorative).
- Form labels and instructions are clear.
- Contact/help paths are easy to find for blocked tasks.

## 4. Sources and Related References

1. WCAG 2.2 (W3C)

- https://www.w3.org/TR/WCAG22/

2. WAI Images Tutorial (W3C)

- https://www.w3.org/WAI/tutorials/images/

3. WAI Alt Decision Tree (W3C)

- https://www.w3.org/WAI/tutorials/images/decision-tree/

4. Project references in this repository

- docs/library-style-guide.md
- docs/university-style-guide.md
- docs/readability-style-guide.md
