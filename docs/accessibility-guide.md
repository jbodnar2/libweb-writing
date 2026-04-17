# Accessibility & Alt Text Guide: Quick Reference

## 1. Heading Hierarchy

- **Sequential Order**: Never skip heading levels (e.g., do not jump from H2 to H4).
- **Single H1**: Each page must have exactly one H1, typically the page title.
- **Structural Use**: Do not use bold text to "fake" a heading; use the proper HTML/Markdown header tag.

## 2. Meaningful Link Text

- **Descriptive Action**: Link text must describe the destination or the action.
  - **Yes**: [Download the Floor Map (PDF)] or [Search the Library Catalog]
  - **No**: [Click here], [Read more], or [Link]
- **Unique Text**: Avoid having multiple links on the same page with the same text that point to different destinations.
- **File Types**: If a link opens a file (PDF, Excel), include the file type in the link text.

## 3. Image Alt Text

- **Informative Images**: Provide a concise description of the information the image conveys.
- **Functional Images**: For images that act as buttons or links, the alt text must describe the **action**, not the appearance.
  - **Yes**: `alt="Search"`
  - **No**: `alt="Magnifying glass icon"`
- **Decorative Images**: Use empty alt text (`alt=""`) for purely decorative elements (e.g., flourish lines or background textures).
- **Prohibited Phrases**: Do not start alt text with "Image of," "Picture of," or "Photo of."
- **File Names**: Never use file names (e.g., `img_1234.jpg`) as alt text.

## 4. Complex Images (Charts & Maps)

- **Two-Part Requirement**: Complex visuals require a short alt text identifier AND a full text description immediately nearby.
  - **Alt text**: "Map of Atlanta Campus Library floors; see text below for detailed directory."
  - **Nearby Text**: Provide a list of locations for each floor.

## 5. Color and Contrast

- **Color as Meaning**: Never use color as the _only_ way to convey information.
  - **Yes**: "Required fields are marked in red and with an asterisk (\*)."
  - **No**: "Click the red button to delete."
- **Contrast**: Ensure text has a contrast ratio of at least 4.5:1 against its background.

## 6. Readability and Layout

- **Scannability**: Use bulleted or numbered lists for three or more items.
- **Caps**: Avoid ALL CAPS for emphasis; it is difficult for users with dyslexia to read and may be read letter-by-letter by screen readers.
- **Underlining**: Do not underline text unless it is a functional hyperlink.
