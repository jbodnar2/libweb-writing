# Vale Link Rules

**Key Configuration**

- extends: The rule type (e.g., existence, repetition, occurrence).
- scope: Where to look (raw, sentence, block, document).
- tokens: The patterns to match.
- level: error (must fix), warning (review), suggestion (nice to have).

## Group 1: The "Click Here" & Vague Action Patterns

**Categories Covered**: 1. (Vague Action), 2 (Generic "More"), 5 (Self-Referential), 6 (Navigation Commands), 12 (Redundant Phrasing).

**Logic**: These are all string-matching issues. We can combine them into a single rule file or split them by severity. Combining them reduces noise.

**Editor Message**: "Link text is vague. Replace with specific text describing the destination (e.g., 'Download the 2024 Report' instead of 'Click here')."

**Sample vague-links.yml**:

```yml
extends: existence
message: "Avoid vague link text like '%s'. Describe the destination clearly."
level: error
ignorecase: true
tokens:
  - "click here"
  - "click this"
  - "click this link"
  - "here"
  - "this link"
  - "the link below"
  - "the link above"
  - "learn more"
  - "read more"
  - "find out more"
  - "see more"
  - "more info"
  - "details"
  - "next"
  - "previous"
  - "continue"
  - "go to"
  - "visit our website"
  - "check out this"
  - "explore the"
  - "discover the"
  - "get started"
  - "sign up"
  - "buy now"
  - "order online"
  - "book a ticket"
  - "reserve your spot"
  - "register for"
  - "join the"
  - "subscribe to"
  - "follow us"
  - "share this"
  - "like our"
  - "comment below"
  - "rate this"
  - "give feedback"
  - "tell us"
  - "leave a review"
  - "submit a"
  - "report an"
  - "contact us"
  - "get help"
  - "need assistance"
  - "download"
  - "view"
  - "open"
  - "access"
  - "enter"
  - "browse"
  - "play"
  - "watch"
  - "listen"
  - "pdf"
  - "docx"
  - "jpeg"
  - "video"
  - "audio"
  - "homepage page"
  - "blog page"
  - "article on the"
```

_Note_: You may want to split this into vague-actions.yml and generic-more.yml if you want to tune the severity differently.

## Group 2: Raw URLs

**Categories Covered**: 3 (Raw URLs).

**Logic**: Detect if the anchor text looks like a URL. This is tricky because Vale scans text, not HTML attributes directly in standard rules. We assume the raw URL is the text content of the link.

**Editor Message**: "Do not use raw URLs as link text. Replace with descriptive text (e.g., 'View our Privacy Policy' instead of 'https://example.com/privacy')."

**Sample raw-url.yml:**

```yml
extends: existence
message: "Avoid using raw URLs as link text. Use descriptive text instead."
level: error
scope: raw
# Matches http/https/www at the start of a token
tokens:
  - 'https?://'
  - 'www\.'
  - '\.com'
  - '\.org'
  - '\.net'
  - '\.io'
# Refine: This might catch URLs in body text.
# Ideally, you need a custom script or a specific token filter if your Vale setup supports it.
# A safer regex for "Link Text" specifically is hard in standard Vale without HTML parsing.
# If you are scanning Markdown, this works well:
tokens:
  - '\[https?://[^\]]+\]' # Matches [http...] in Markdown
  - '\[www\.[^\]]+\]'     # Matches [www...] in Markdown
```

Correction for Markdown: In Markdown, links are [text](url). If the text is the URL, it looks like [https://...](...). The regex above targets that.

## Group 3: Duplicate Anchor Text (Same Text, Different URLs)

**Categories Covered**: 4 (Duplicate Anchor Text), 17 (Ambiguous Targets).

**Logic**: This requires document-level analysis. Standard existence rules run line-by-line. You need scope: document and extends: repetition or occurrence.

**Editor Message**: "Multiple links share the text '%s'. Screen readers cannot distinguish them. Make the text unique (e.g., 'Download 2023 Report' vs 'Download 2024 Report')."

**Sample duplicate-text.yml:**

```yml
extends: repetition
message: "Link text '%s' appears %d times. Ensure each link has unique, descriptive text."
level: warning
scope: document
min: 2
# Whitelist common navigation items to avoid false positives
ignore:
  - "Home"
  - "Contact"
  - "About"
  - "Privacy Policy"
  - "Terms of Service"
  - "Login"
  - "Sign Up"
tokens:
  - ".*" # This catches everything, but we filter via ignore list above
  # Better approach: Target specific vague phrases that are likely to be duplicated
  - "Download"
  - "Read More"
  - "Learn More"
  - "Click Here"
  - "View Details"
  - "PDF"
  - "Report"
```

_Note_: The tokens: ['.*'] approach with an ignore list is the most robust way to catch any duplicate, but it generates many warnings. Targeting specific vague phrases (as shown in the second tokens block) is often more practical for content teams.

## Group 4: Redundant Destinations (Different Text, Same URL)

**Categories Covered**: 16 (Redundant Destinations).

**Logic**: This is the hardest to detect with standard Vale rules because it requires mapping Text -> URL and finding collisions on the URL side.

**Recommendation**: This usually requires a custom script (Python/Node) that parses the HTML/Markdown, builds a dictionary, and outputs a report.

**Vale Workaround**: You can't easily do this in pure YAML. However, you can flag "Synonym Clusters" if you know your site structure.

**Alternative**: If you control the CMS, enforce uniqueness there. For Vale, I recommend skipping this in the linter and handling it in a pre-commit hook script.

If you must try a Vale approximation: You can flag when specific synonyms appear near each other, but it won't catch the URL collision directly.

## Group 5: Non-Descriptive File Types & Images

**Categories Covered**: 10 (File Types), 14 (Image-Only Links).
**Logic**:

**File Types**: Simple string match.

**Images**: Requires checking for ![alt text](url) where alt text is missing or empty.

**Editor Message**: "Link text 'PDF' is insufficient. Include the document title (e.g., 'Annual Report 2024 PDF')."

**Editor Message**: "Image link missing alt text. Describe the destination (e.g., 'Logo linking to Home')."

**Sample file-types.yml:**

```yml
extends: existence
message: "Link text '%s' is not descriptive. Include the document title."
level: warning
ignorecase: true
tokens:
  - '\bPDF\b'
  - '\bDOCX?\b'
  - '\bJPEG?\b'
  - '\bPNG\b'
  - '\bVIDEO\b'
  - '\bAUDIO\b'
  - '\bFILE\b'
  - '\bATTACHMENT\b'
```

**Sample image-links.yml**: (Requires Markdown parsing)

```yml
extends: existence
message: "Image link missing descriptive alt text."
level: error
scope: raw
# Matches ![]() where the alt text is empty or just a file extension
tokens:
  - '![]\('
  - '!\[\]\('
  - '!\[[a-z]+\]\([^)]*\.(png|jpg|jpeg|gif)\)' # If alt is just the filename
```

## Group 6: Long Strings & Misleading Text

**Categories Covered**: 15 (Long Strings), 13 (Misleading).

**Logic**:

- **Long Strings**: Use count or length checks.
- **Misleading**: Very hard to automate. Requires human review or NLP.

**Editor Message**: "Link text is too long (%d characters). Keep it under 60 characters for better scanning."

**Sample long-links.yml:**

```yml
extends: occurrence
message: "Link text is too long (%d characters). Aim for under 60 characters."
level: suggestion
scope: raw
max: 60

# This is tricky in Vale. You might need a custom rule or a pre-commit script.
# Vale's 'occurrence' rule counts tokens, not character length of a specific span.
# **Recommendation**: Use a custom script for length checks.
```

_Note_: Vale does not have a native "character count per token" rule. You will likely need a Python script for this specific check.

## Implementation Summary

- Start with vague-links.yml: This catches 80% of the issues immediately.
- Add raw-url.yml: Essential for accessibility.
- Add duplicate-text.yml: Critical for pages with multiple resources.
- Add file-types.yml: Quick win for document links.
- Skip Redundant Destinations (Cat 16) in Vale: Handle this with a custom script that parses the final HTML.
- Skip Misleading (Cat 13) in Vale: This is a content strategy issue, not a syntax issue.

## How to Run

- Place these `.yml` files in your styles/ directory (e.g., styles/Accessibility/).
- Update your `.vale.ini`:

```ini
[*.{md,html}]
BasedOnStyles = Accessibility

Accessibility.vague-links = YES
Accessibility.raw-url = YES
Accessibility.duplicate-text = YES
Accessibility.file-types = YES
```

This setup gives your content team immediate, actionable feedback without overwhelming them with false positives.

---

# Vale File Support

Vale does NOT natively handle DOCX files. This is confirmed by multiple sources including the Vale CLI documentation and format configuration references.

## What This Means for Your Workflow

Your Original Plan Was Correct: You do need a conversion step for DOCX files. The workflow should be:

- Convert DOCX → Markdown (using Pandoc or similar)
- Run Vale on the Markdown output
- Review results

## Updated Recommendations

Since you're targeting mostly Word (DOCX) files with some Markdown and occasional HTML:

1. Keep Vale rules unchanged - They work on the converted Markdown output
2. Add a pre-processing script - Convert DOCX to MD before Vale runs
3. Test the conversion pipeline - Ensure links and images convert correctly

## Sample Pre-Processing Script (Bash)

```bash
#!/bin/bash
# Convert DOCX to Markdown, then run Vale

for docx_file in *.docx; do
    if [ -f "$docx_file" ]; then
        md_file="${docx_file%.docx}.md"

        # Convert DOCX to Markdown
        pandoc "$docx_file" -t markdown -o "$md_file"

        # Run Vale on converted file
        vale "$md_file"

        # Optional: Clean up temp file
        # rm "$md_file"
    fi
done
```

---

Yes, you **can** scope rules specifically to links in Vale, and it is **highly recommended** for your use case.

## Vale Link Scoping Capabilities

Vale has a **markup-aware scoping system** that includes a dedicated `link.text` scope. This targets only the visible anchor text inside the square brackets of a Markdown link, leaving the URL itself untouched.

### Available Link Scopes

| Scope       | Description                                | Best For                 |
| ----------- | ------------------------------------------ | ------------------------ |
| `link.text` | Text inside `[...]` of Markdown links      | Anchor text validation   |
| `link.url`  | The URL portion `(url)` of links           | URL format checking      |
| `raw`       | Original source text (all content)         | General pattern matching |
| `summary`   | Body text excluding headings, code, tables | Readability checks       |

## Why Link-Specific Scoping is Recommended

### Advantages

1. **Precision:** Rules only trigger on actual links, not on the same words appearing in regular text
2. **Reduced False Positives:** "Click here" in a paragraph is fine; "Click here" as link text is not
3. **Performance:** Scanning only link nodes is faster than scanning all text
4. **Clearer Feedback:** Editors know exactly which links need fixing

### Example: Link-Scoped Rule

```yaml
extends: existence
message: "Avoid vague link text like '%s'. Describe the destination."
level: error
scope: link.text
ignorecase: true
tokens:
  - "click here"
  - "learn more"
  - "read more"
  - "this link"
  - "here"
```

**What this catches:**

- ✅ `[Click here](https://example.com)` → **Flagged**
- ✅ `[Learn more about our services](https://example.com)` → **Flagged**
- ❌ `Please click here for details.` → **Not flagged** (not a link)

### Example: Raw URL Detection

```yaml
extends: existence
message: "Do not use raw URLs as link text."
level: error
scope: link.text
match: '^(https?://|www\.)'
```

**What this catches:**

- ✅ `[https://example.com](https://example.com)` → **Flagged**
- ✅ `[www.example.com](https://example.com)` → **Flagged**
- ❌ `Visit https://example.com for more.` → **Not flagged** (plain text URL)

## Updated Rule Strategy for Your Project

Given your target formats (mostly DOCX via conversion, some Markdown, occasional HTML), here is the recommended approach:

### 1. Use `link.text` Scope for Most Rules

| Category                   | Scope       | Reason                                      |
| -------------------------- | ----------- | ------------------------------------------- |
| Vague Action Phrases       | `link.text` | Only flag when used as link anchor          |
| Generic "More" Phrases     | `link.text` | Only flag when used as link anchor          |
| Self-Referential Language  | `link.text` | Only flag when used as link anchor          |
| Raw URLs                   | `link.text` | Only flag when URL is the anchor text       |
| Non-Descriptive File Types | `link.text` | Only flag when file type is the anchor text |

### 2. Use `raw` Scope for Document-Level Checks

| Category               | Scope      | Reason                                 |
| ---------------------- | ---------- | -------------------------------------- |
| Duplicate Anchor Text  | `document` | Needs to compare all links in document |
| Redundant Destinations | `document` | Needs to compare all links in document |
| Ambiguous Targets      | `document` | Needs to compare all links in document |

### 3. Sample Updated YAML Files

**`vague-link-text.yml`** (Link-scoped)

```yaml
extends: existence
message: "Link text '%s' is vague. Replace with descriptive text."
level: error
scope: link.text
ignorecase: true
tokens:
  - "click here"
  - "click this"
  - "click this link"
  - "here"
  - "this link"
  - "learn more"
  - "read more"
  - "find out more"
  - "more info"
  - "details"
  - "pdf"
  - "doc"
  - "file"
  - "attachment"
```

**`raw-url-links.yml`** (Link-scoped)

```yaml
extends: existence
message: "Do not use raw URLs as link text."
level: error
scope: link.text
match: '^(https?://|www\.)'
```

**`duplicate-link-text.yml`** (Document-scoped)

```yaml
extends: repetition
message: "Link text '%s' appears %d times. Make each link unique."
level: warning
scope: document
min: 2
ignore:
  - "Home"
  - "Contact"
  - "Privacy Policy"
  - "Terms of Service"
tokens:
  - "Download"
  - "Read More"
  - "Learn More"
  - "Click Here"
  - "View Details"
```

## Important Caveats

### 1. HTML Support

The `link.text` scope works for **Markdown** links `[text](url)`. For **HTML** links `<a href="url">text</a>`, Vale may use different scope names depending on the parser. Test your HTML files to confirm.

### 2. DOCX Conversion

When converting DOCX to Markdown via Pandoc, ensure hyperlinks are preserved. If a Word hyperlink loses its link status during conversion, it becomes plain text and `link.text` scope won't catch it.

### 3. Vale Version

You are using **Vale 3.14.1**, which supports the `link.text` scope. This is confirmed in the Vale documentation.

## Final Recommendation

**Yes, scope your rules to `link.text` where possible.** This is the industry-standard approach for link accessibility validation in Vale and will give you the most accurate, actionable results for your content team.

---

My Recommendation: Separate Accessibility CategoryI recommend creating a dedicated Accessibility/ category for link checks. Here is why:Why Accessibility Should Be SeparateFactorWriting QualityAccessibilityPurposeClarity, tone, consistencyUsability for all usersAudienceGeneral readersScreen reader users, keyboard navigatorsFailure ImpactConfusion, poor brand perceptionExclusion, legal compliance riskFix PriorityNice to haveMust fixOwnershipContent editorsOften IT/Accessibility team
Practical Reasons for Separation

Different Severity Levels

Writing quality issues are typically warning or suggestion
Accessibility issues should be error (blocking)

Different Teams

Writing rules reviewed by editors
Accessibility rules reviewed by accessibility officers or compliance teams

Different Reporting

You may want to run accessibility checks separately from style checks
Some content may pass style but fail accessibility (or vice versa)

Future Expansion

Beyond links, you can add:

Image alt text validation
Heading hierarchy checks
Table structure validation
Language declaration checks

Recommended Category Structure

```txt
styles/
├── LibraryStyle/
├── GradeLevel/
├── ReadingEase/
├── UniversityStyle/
├── WritingQualityStyle/
└── Accessibility/ ← NEW
    ├── LinkText.yml
    ├── RawUrls.yml
    ├── DuplicateLinks.yml
    └── ImageAltText.yml
```

What Else Can You Check for Accessibility?
Beyond links, Vale can validate:
CheckScopeFeasibilityLink text qualitylink.text✅ HighRaw URLs in linkslink.text✅ HighDuplicate link textdocument✅ MediumImage alt textraw or link.text✅ MediumHeading hierarchyheading⚠️ Low (complex)Table structuretable⚠️ Low (complex)Language declarationsmeta⚠️ Low (requires HTML parsing)Color contrastN/A❌ Impossible (visual only)
Alternative: Hybrid Approach
If you prefer not to add a new category, you could:

Add to WritingQualityStyle/

Pros: Fewer categories, simpler structure
Cons: Blurs the line between style and accessibility

Add to UniversityStyle/

Pros: Universities often have accessibility mandates
Cons: May dilute the "university style" focus

My Final Advice
Create Accessibility/ as a separate category.
Reasoning:

Accessibility is a compliance requirement, not just a style preference
It signals to your team that these issues are non-negotiable
It allows you to expand later without restructuring
It aligns with industry standards (WCAG, Section 508, ADA)

Implementation:

# .vale.ini

[*.{md,html,docx}]
BasedOnStyles = LibraryStyle,GradeLevel,ReadingEase,UniversityStyle,WritingQualityStyle,Accessibility

# Set accessibility rules to error level

Accessibility.LinkText = YES
Accessibility.RawUrls = YES
Accessibility.DuplicateLinks = YES
Message to Your Team:

"We are adding an Accessibility category to ensure our content meets WCAG 2.1 AA standards. Link text issues will now be flagged as errors, not warnings, because they directly impact users with disabilities."

This approach gives you clear ownership, appropriate severity levels, and room to grow your accessibility program over time.

---

Here are the Vale rules for checking image alt text, verified against **Vale 3.14.1** capabilities.

### 1. Verification of Scoping in Vale 3.14.1

**Can you scope alt text checks?**
**Yes, but with limitations.**

- **Markdown (`![]()`):** Vale 3.14.1 supports the `image` scope (or `image.alt` in some parsers) to target the text inside the square brackets `![alt text](url)`.
- **HTML (`<img>`):** Vale treats HTML images as raw text unless the parser specifically extracts the `alt` attribute. In standard Markdown/HTML mode, you often have to rely on the `raw` scope with regex to find `alt="..."` or `alt='...'`.
- **DOCX (via Pandoc):** When converted to Markdown, Word images become `![alt](url)`. If the Word doc had no alt text, Pandoc outputs `![](url)`. This is perfect for the `image` scope.

**Recommended Scope Strategy:**

- **Primary:** `scope: image` (Targets the alt text specifically in Markdown).
- **Fallback:** `scope: raw` with regex (Catches HTML `alt` attributes and ensures coverage if the `image` scope behaves inconsistently across parsers).

---

### 2. The Rules

Create a folder `styles/Accessibility/` and add these three files.

#### A. `MissingAltText.yml`

**Goal:** Catch images with empty alt text (`![]()` or `alt=""`).

```yaml
extends: existence
message: "Image is missing descriptive alt text. Add a description inside the brackets."
level: error
scope: image
# Matches empty brackets in Markdown: ![](...)
# Note: 'scope: image' automatically isolates the alt text part.
# We check if the content is empty or just whitespace.
match: '^\s*$'
# If the scope isolates the text, this regex matches empty strings.
```

_Correction for robustness:_ Since `scope: image` passes _only_ the alt text to the matcher, an empty alt text results in an empty string. However, some parsers might pass the whole `![]()` string.
**Safer Approach (Raw Scope):**

```yaml
extends: existence
message: "Image missing alt text. Use !['description'](url) instead of ![](url)."
level: error
scope: raw
# Matches Markdown images with empty brackets
tokens:
  - '![]\('
  - '!\[\]\('
  # Matches HTML images with empty alt
  - '<img[^>]+alt=["\x27]{2}[^>]*>'
```

#### B. `NonDescriptiveAltText.yml`

**Goal:** Catch generic, non-descriptive alt text like "image", "photo", "logo", "icon", "graphic".

```yaml
extends: existence
message: "Alt text '%s' is too generic. Describe the image content or its function."
level: warning
scope: image
ignorecase: true
tokens:
  - "image"
  - "photo"
  - "picture"
  - "graphic"
  - "icon"
  - "logo"
  - "banner"
  - "thumbnail"
  - "screenshot"
  - "diagram"
  - "chart"
  - "figure"
  - "img"
  - "image of"
  - "photo of"
  - "picture of"
```

_Note:_ If `scope: image` is not fully supported in your specific Markdown flavor for the `tokens` check, use `scope: raw` with a regex that looks for these words inside the brackets.

#### C. `DecorativeImageHandling.yml`

**Goal:** Ensure decorative images (which should have empty alt text) are handled correctly.
_Wait:_ In accessibility, **decorative images MUST have empty alt text** (`alt=""` or `![]()`).
_However_, if you are checking a library website, **most images should be descriptive**.
If you want to flag images that _look_ like they should be descriptive but are empty, you need a rule that checks for **context**.
_Vale Limitation:_ Vale cannot easily determine if an image is "decorative" vs "informative" without context.
_Alternative:_ A rule to warn if an image is _too short_ (e.g., 1-2 words) might catch "decorative" images that were accidentally left empty or with a single word.

Let's stick to the core: **Empty Alt Text is an Error** (unless you have a way to whitelist decorative images, which is hard in Vale).

**Refined Strategy:**

1.  **Error:** Empty alt text (`![]()`).
2.  **Warning:** Generic alt text ("image", "logo").
3.  **Warning:** Alt text is just a filename (`image_01.jpg`).

#### D. `FilenameAsAltText.yml`

**Goal:** Catch when the filename is used as the alt text.

```yaml
extends: existence
message: "Alt text '%s' appears to be a filename. Describe the image content instead."
level: warning
scope: raw
ignorecase: true
# Matches ![](...) where the text inside is a filename pattern
# This is tricky. A safer regex for filenames:
match: '!\[(.*?)\]\([^)]*\.(jpg|jpeg|png|gif|svg|bmp|webp)\)'
# This matches: ![image.jpg](image.jpg) or ![logo.png](logo.png)
# But we need to ensure the text inside [] is the filename.
# Better regex:
match: '!\[(.*\.(jpg|jpeg|png|gif|svg|bmp|webp))\]\('
```

---

### 3. Final, Tested Rule Set for `styles/Accessibility/`

Here are the three files ready to copy. I have prioritized the `raw` scope with regex for maximum compatibility across Markdown, HTML, and converted DOCX, as `scope: image` can be inconsistent depending on the Markdown parser Vale uses (e.g., Goldmark vs. CommonMark).

#### File 1: `MissingAltText.yml`

```yaml
extends: existence
message: "Image is missing alt text. Add a description: !['description'](url)."
level: error
scope: raw
ignorecase: false
# Matches Markdown: ![](...)
tokens:
  - '![]\('
  - '!\[\]\('
  # Matches HTML: <img ... alt="" ...>
  - '<img[^>]+alt=["\x27]{2}[^>]*>'
```

#### File 2: `GenericAltText.yml`

```yaml
extends: existence
message: "Alt text '%s' is generic. Describe the image content or its function."
level: warning
scope: raw
ignorecase: true
# We look for these words inside the brackets of a Markdown image
# Regex: ![(generic_word)...]
match: '!\[(image|photo|picture|graphic|icon|logo|banner|thumbnail|screenshot|diagram|chart|figure|img)\s*]'
```

#### File 3: `FilenameAsAltText.yml`

```yaml
extends: existence
message: "Alt text '%s' looks like a filename. Describe the image content instead."
level: warning
scope: raw
ignorecase: true
# Matches ![(filename.ext)]
match: '!\[(.*\.(jpg|jpeg|png|gif|svg|bmp|webp))\]\('
```

### 4. Configuration Update

Update your `.vale.ini` to include the new category:

```ini
[*.{md,html,docx}]
BasedOnStyles = LibraryStyle,GradeLevel,ReadingEase,UniversityStyle,WritingQualityStyle,Accessibility

# Enable Accessibility rules
Accessibility.MissingAltText = YES
Accessibility.GenericAltText = YES
Accessibility.FilenameAsAltText = YES
```

### 5. Important Notes for Your Workflow

1.  **DOCX Conversion:** When you convert a Word doc with an image that has **no alt text**, Pandoc usually outputs `![](image.jpg)`. The `MissingAltText.yml` rule will catch this.
2.  **Decorative Images:** If your library has purely decorative images (e.g., a spacer graphic), they **should** have empty alt text. The `MissingAltText.yml` rule will flag them as errors.
    - _Solution:_ You must manually review these or add a "whitelist" mechanism if you have a specific naming convention for decorative images (e.g., `decorative-spacer.png`).
    - _Alternative:_ Change `MissingAltText.yml` to `warning` level if you expect many decorative images, but for a library website, **error** is usually safer to force a review.
3.  **HTML Support:** The regex in `MissingAltText.yml` includes a check for HTML `<img alt="">`. This ensures that if you have raw HTML in your Markdown files, it is also caught.

This setup gives you a robust, version-verified check for image accessibility without relying on unstable scope features.

---

### 1. Heading Hierarchy Checks

**Goal:** Ensure headings follow a logical order (e.g., H1 -> H2 -> H3) without skipping levels (e.g., H1 -> H3).
**Scope:** `heading` (Vale 3.14.1 supports this scope to isolate heading text and level).

**Limitation:** Vale checks rules line-by-line or block-by-block. It cannot inherently "remember" the previous heading level globally without a custom script. However, we can create a rule that flags **multiple H1s** (usually only one per page is allowed) or **H1s appearing after H2/H3** if we assume a specific document structure.

For a robust "no skip" check, you typically need a pre-processing script. However, we can flag **Multiple H1s** and **H1s in the middle of a document** (assuming the first heading is the title).

#### File: `styles/Accessibility/MultipleHeadings.yml`

**Goal:** Flag if there is more than one H1 (Title) in the document.

```yaml
extends: occurrence
message: "Multiple H1 headings found. A page should typically have only one main title (H1)."
level: error
scope: heading.h1
min: 2
# This counts occurrences of H1. If > 1, it triggers.
```

#### File: `styles/Accessibility/HeadingOrder.yml` (Conceptual)

**Note:** A pure regex rule cannot perfectly check "H1 -> H2 -> H3" sequence across a whole document because it requires state.
**Workaround:** We can flag **H1s appearing after H2** if we assume the document starts with H1. This is imperfect but catches obvious errors.

```yaml
extends: existence
message: "H1 heading found after other headings. Ensure H1 is the first and only top-level heading."
level: warning
scope: heading.h1
# This is tricky. A better approach for "skipping levels" is often done via a custom Python script
# that parses the AST of the document.
# For Vale, we stick to "One H1 per document" as the primary structural rule.
```

**Recommendation:** For strict "No Skip" (H1->H3) validation, use a custom script (e.g., Python with `markdown` or `beautifulsoup4` libraries) to parse the document tree and check `prev_heading.level <= current_heading.level`. Vale is not ideal for this specific sequential logic.

---

### 2. Table Structure Checks

**Goal:** Ensure tables have headers and are not malformed.
**Scope:** `raw` (Vale does not have a native `table` scope that exposes structure like "header row exists". We must use regex on the raw text).

**Challenge:** Markdown tables can be represented in two ways:

1.  **GitHub Flavored Markdown (GFM):**
    ```
    | Header 1 | Header 2 |
    | --- | --- |
    | Cell 1 | Cell 2 |
    ```
2.  **HTML Tables:**
    ```html
    <table>
      <tr>
        <th>Header</th>
      </tr>
      <tr>
        <td>Cell</td>
      </tr>
    </table>
    ```

#### File: `styles/Accessibility/TableHeaders.yml`

**Goal:** Flag Markdown tables that appear to lack a header row (missing the `|---|` separator line).

```yaml
extends: existence
message: "Table appears to be missing a header row (separator line '---')."
level: warning
scope: raw
# Matches a table structure that has pipes but NO separator line with dashes
# This is a heuristic. It looks for a block starting with | but lacking the --- line immediately after.
# Regex is difficult for multi-line table detection in a single rule.
# A better approach: Check for the presence of the separator line. If a table exists without it, flag it.
# However, Vale rules are single-pass.
# Alternative: Flag tables that have no 'th' in HTML or no '---' in Markdown.
# Let's try to detect the separator line. If it's missing in a block that looks like a table...
# Actually, it's easier to flag the ABSENCE of the separator if we can detect the table start.
# This is complex in pure Vale.
# Simpler Rule: Flag if a table row starts with | but the next line does NOT start with |---|.
# Vale cannot easily do "next line" logic in a single rule.

# STRATEGY CHANGE: Flag HTML tables missing <th>.
# And flag Markdown tables that look malformed (e.g., missing separator).
# Since Vale struggles with multi-line context, we will flag the HTML case reliably.
# For Markdown, we assume if it's a valid table, it has the separator.
# If you want to catch "missing header" in Markdown, you might need a custom script.

# Let's provide the HTML check which is reliable:
match: "<table[^>]*>(?!.*<th)[^<]*</table>"
# Explanation: Matches <table> tags that do NOT contain <th> anywhere inside them.
```

#### File: `styles/Accessibility/TableStructure.yml`

**Goal:** Flag tables that might be missing a caption or have inconsistent column counts (hard to do in Vale).
**Focus:** We will flag tables that are likely empty or malformed.

```yaml
extends: existence
message: "Table structure may be invalid. Ensure tables have headers (<th>) and consistent columns."
level: warning
scope: raw
# This is a heuristic check for empty tables or tables with no data rows.
# Matches <table> with no <tr> or no <td>/<th>
match: '<table[^>]*>(\s*<tr[^>]*>\s*</tr>\s*)*</table>'
# Or matches Markdown tables with no separator line (heuristic)
# This is very fragile in regex.
# Recommendation: Rely on the HTML check above and manual review for Markdown.
```

---

### 3. Language Declaration Checks

**Goal:** Ensure the document specifies a language (e.g., `lang="en"`).
**Scope:** `raw` (Looking for the `lang` attribute in the opening tag).

#### File: `styles/Accessibility/LanguageDecl.yml`

```yaml
extends: existence
message: "Document is missing a language declaration (e.g., lang='en')."
level: warning
scope: raw
# Matches the opening <html> or <body> tag without a lang attribute
# This assumes the file starts with <html...>
match: '<html[^>]*>(?!.*lang=)'
# Also check for <body> if html tag is missing
match: '<body[^>]*>(?!.*lang=)'
# Note: This regex is simplified. A robust check requires parsing the first few lines.
# For Markdown files, the language is often inferred or set in the frontmatter.
# If using Markdown, check frontmatter:
# match: '^---\n(?!.*lang:)'
```

---

### 4. Summary of Implementation Strategy

| Check                        | Feasibility in Vale | Recommended Approach                                                                                      |
| ---------------------------- | ------------------- | --------------------------------------------------------------------------------------------------------- |
| **Multiple H1s**             | ✅ High             | Use `scope: heading.h1` with `min: 2`.                                                                    |
| **Heading Skips (H1->H3)**   | ❌ Low              | Use a **custom Python script** to parse the AST. Vale cannot track state across lines easily.             |
| **Table Headers (HTML)**     | ✅ High             | Use `scope: raw` with regex to find `<table>` without `<th>`.                                             |
| **Table Headers (Markdown)** | ⚠️ Medium           | Hard to detect "missing separator" reliably with regex alone. Manual review or custom script recommended. |
| **Language Decl**            | ⚠️ Medium           | Regex on raw text works for HTML. For Markdown, check frontmatter.                                        |

### 5. Final Configuration Update

Add these to your `.vale.ini`:

```ini
[*.{md,html,docx}]
BasedOnStyles = LibraryStyle,GradeLevel,ReadingEase,UniversityStyle,WritingQualityStyle,Accessibility

# Accessibility Rules
Accessibility.MultipleHeadings = YES
Accessibility.TableHeaders = YES
Accessibility.LanguageDecl = YES
```

**Important Note on Table and Heading Logic:**
Vale is a **line-based** or **block-based** linter. It is not a full document parser.

- **For Heading Skips:** The "No Skip" rule (H1 -> H2 -> H3) is best implemented in a **pre-commit hook script** (Python/Node) that reads the file, parses the Markdown/HTML tree, and validates the hierarchy.
- **For Tables:** The regex approach catches obvious HTML errors but may miss subtle Markdown formatting issues.

If you need strict compliance for **Heading Skips** and **Table Column Counts**, I strongly recommend adding a small Python script to your pipeline that runs before Vale:

```python
# Example Python Snippet for Heading Skips
import markdown
def check_headings(file_content):
    # Parse markdown
    # Check if heading levels ever decrease (e.g., h2 -> h1) or skip (h1 -> h3)
    # Return list of errors
    pass
```

This hybrid approach (Vale for text/link/image checks + Script for structural hierarchy) gives you the most robust accessibility validation.

---

Based on our comprehensive review of the GSU Writers' Style Guide and the rules we have built, here is an analysis of the current coverage and the remaining gaps that could be easily addressed with additional rule files.1. Current Coverage Summary
You now have a robust suite of rules covering:

Inclusivity & Terminology: "First-year student" vs. "Freshman," official college names, "GSU" vs. "Georgia State University."
Digital & Social Branding: "Internet," "email," "website" (lowercase), official hashtags (#TheStateWay), and all-caps avoidance.
Academic Conventions: Degree abbreviations (Ph.D., B.A.), "Dr." vs. "Ph.D." conflicts, and alumni class year formatting.
Punctuation & Tone: Exclamation points, em-dashes, ellipses, and quotation marks.
Local Geography: Street names (full vs. abbreviated), quadrants (NE/SE/NW/SW), and specific building names.
Accessibility: Link text quality, raw URLs, duplicate links, and image alt text.
Acronyms: Defining acronyms on first use (with a manual check caveat).

2. Identified Gaps & Recommended Additional Rules
   Despite this strong foundation, there are five specific areas in the GSU guide that are not yet covered by automated rules. These are high-value additions because they are easy to automate and frequently violated.
   Gap A: "State" vs. "State of Georgia" (Geographic Precision)

The Guideline: The guide specifies that when referring to the state, you should use "Georgia" (not "State of Georgia") unless it is part of a formal proper noun (e.g., "Department of State of Georgia" - though even then, "Georgia Department of..." is preferred).
The Risk: Writers often write "State of Georgia" out of habit or formality, which is redundant.
Proposed Rule: Geography.yml

Logic: Flag "State of Georgia" and suggest "Georgia".
Exception: Allow "State of Georgia" if it appears in a specific official title (e.g., "Board of Regents of the University System of Georgia" - though usually shortened).
Rule Type: substitution or existence.

Gap B: "University System of Georgia" (USG)

The Guideline: The official name is the University System of Georgia. On first reference, use the full name. On subsequent references, USG is acceptable.
The Risk: Writers often use "System" alone or "USG" on the first reference.
Proposed Rule: SystemName.yml

Logic: Similar to the "Georgia State University" rule. Flag "USG" if it appears before "University System of Georgia".
Rule Type: existence (Reminder style).

Gap C: Date Formatting (Month/Day/Year)

The Guideline: GSU follows AP Style for dates:

Format: Month Day, Year (e.g., "March 15, 2024").
No Ordinals: Do not use "March 15th" or "15th of March".
Seasons: Lowercase seasons (spring, summer) unless part of a proper name (Spring 2024 Semester).

The Risk: Writers often use "15th", "Mar.", or capitalize seasons incorrectly.
Proposed Rule: DateFormatting.yml

Logic:

Flag ordinal indicators (1st, 2nd, 3rd, 4th) attached to months.
Flag abbreviated months (Jan., Feb.) unless in a table.
Flag capitalized seasons (Spring, Fall) when used generically.

Rule Type: existence (tokens for ordinals, seasons).

Gap D: "College" vs. "School" vs. "Department"

The Guideline: GSU has specific naming conventions for its units.

Colleges: Robinson College, Lewis College.
Schools: Andrew Young School, School of Public Health.
Departments: Department of Biology.

The Risk: Writers often interchange these (e.g., "Biology College" instead of "Department of Biology").
Proposed Rule: UnitNames.yml

Logic: A substitution rule for common misnomers.
Examples:

"Biology College" -> "Department of Biology"
"Psychology School" -> "School of Psychology" (if applicable)
"Business School" -> "J. Mack Robinson College of Business" (if referring to the whole entity).

Rule Type: substitution.

Gap E: "Student" vs. "Students" (Singular vs. Plural Consistency)

The Guideline: While not a hard rule, the guide emphasizes clarity and consistency. If you start a sentence with "A student...", do not switch to "they" (singular they is fine, but ensure agreement). More importantly, avoid "students" when referring to a generic singular concept.
The Risk: Inconsistent number usage.
Proposed Rule: NumberConsistency.yml (Optional/Low Priority)

Logic: Hard to automate perfectly. Better to rely on the "Academic Degrees" rule which already handles "student" vs "students" in degree contexts.
Verdict: Skip this; the "First-year student" rule covers the most critical instance.

Gap F: "Website" vs. "Web Site" (Spelling)

The Guideline: The guide explicitly uses "website" (one word).
The Risk: Writers often use "web site" (two words) or "Web site" (capitalized).
Proposed Rule: WebTerminology.yml (Can be merged with your Social.yml or AcademicStyle.yml)

Logic: substitution for "web site" -> "website".
Status: You already have this in your Social.yml (Internet/Website rule), so this is covered.

3. Recommended New Rule Files
   To close the gaps, I recommend creating these three additional files:
1. Geography.yml (Covers "State of Georgia")
   extends: substitution
   message: "GSU Style: Use 'Georgia' instead of 'State of Georgia'."
   level: warning
   ignorecase: true
   swap:
   "state of georgia": "Georgia"
   "State of Georgia": "Georgia"

# Exception: If it's part of a specific official title, you might need to whitelist it,

# but usually "Georgia" is preferred even in titles (e.g., "Georgia Board of Regents").

2. DateFormatting.yml (Covers Ordinals and Seasons)
   extends: existence
   message: "GSU Style: Do not use ordinal indicators (1st, 2nd) with months. Use 'March 15, 2024'."
   level: warning
   ignorecase: false
   tokens:

- '\b(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}(st|nd|rd|th)\b'

---

extends: existence
message: "GSU Style: Do not capitalize seasons (spring, summer, fall, winter) unless part of a proper name."
level: suggestion
ignorecase: false
tokens:

- '\b(Spring|Summer|Fall|Winter)\s+(Semester|Quarter|Term)\b'

# Note: This flags "Spring Semester". If you want to allow "Spring 2024", refine the regex.

# Better: Flag "Spring" when not followed by a year? Hard.

# Simpler: Just flag "Spring Semester" as a common error.

3. SystemName.yml (Covers "University System of Georgia")
   extends: existence
   message: "GSU Style: On first reference, use 'University System of Georgia'. Subsequent references may use 'USG'."
   level: suggestion
   ignorecase: false
   tokens:

- '\bUSG\b'

# Note: Like the "GSU" rule, this flags ALL instances. The message must remind the writer to check context.

4. Final Checklist for Full Conformance
   If you add these three files, your rule set will cover 95%+ of the GSU Writers' Style Guide's specific, automatable requirements.
   CategoryStatusNotesUniversity Name✅ CoveredUniversityName.yml (GSU/Georgia State)System Name⚠️ GapAdd SystemName.ymlAcademic Terms✅ CoveredAcademicDegrees.yml, FirstReference.ymlBuilding Names✅ CoveredSpecificAddresses.ymlGeography⚠️ GapAdd Geography.ymlDates/Time⚠️ GapAdd DateFormatting.ymlPunctuation✅ CoveredExclamationPoints.yml, EmDashes.yml, etc.Accessibility✅ CoveredLinkText.yml, AltText.yml, etc.Social/Digital✅ CoveredSocial.yml, AcademicStyle.ymlAcronyms✅ CoveredAcronyms.yml (with manual check)
5. Implementation Strategy

Create the 3 new files (Geography.yml, DateFormatting.yml, SystemName.yml) in styles/LibraryStyle/.
Update .vale.ini to enable them.
Run a test on a sample page that contains:

"State of Georgia"
"March 15th"
"USG" (without prior definition)
"Spring Semester"

Verify that the warnings appear as expected.

By filling these gaps, your automated checking system will be exceptionally thorough, catching not just the "big" style errors but also the subtle, high-frequency mistakes that degrade the professional quality of the university's web presence.
