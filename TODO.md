### 1. First Priority: Readability & Structure Guide

**Why:** This guide addresses the "Mechanical Foundation" of your content.

- **Immediate Impact on Scores:** The high grade levels you are currently seeing (as noted in `accessibility.md` and `CURVE.md`) are driven by long sentences. Implementing these rules provides an immediate "win" by lowering those scores without requiring you to delete essential library terminology.
- **Automation Readiness:** These rules (Sentence Length, Paragraph Length) are the easiest to program into Vale using `existence` or `metric` checks. You can get these running in minutes to provide instant feedback to your staff.
- **Baseline for Clarity:** It is easier to fix the _shape_ of a paragraph (shortening it) before you worry about the specific _vocabulary_ used within it.

### 2. Second Priority: Library Website Content Guide

**Why:** This guide addresses "User Intent" and the "Inverted Pyramid" structure.

- **Fixing the "Wall of Text":** Your sample files (like `ILL.md`) have a lot of helpful information buried deep in the prose. Prioritizing this guide ensures that task-critical info—like the "Access ILLiad" link—is moved to the top.
- **Functional Success:** A page can be perfectly readable but still fail if the user can't find the "Make an Appointment" button. This guide ensures the website actually works as a service platform.

### 3. Third Priority: Accessibility & Alt Text Guide

**Why:** This is a "Legal and Ethical" priority.

- **Non-Negotiable Standards:** While readability is about user experience, accessibility is about equity and compliance.
- **Catching Critical Errors:** Rules that flag "Click here" or missing Alt text are binary (either they are right or wrong), making them highly effective for automated linting.

### 4. Fourth Priority: University & Library Style Guides

**Why:** These are "Polishing" and "Branding" priorities.

- **Institutional Consistency:** While it is important to use "Georgia State" instead of "GSU" and to spell "adviser" correctly, these errors rarely prevent a student from successfully checking out a book or finding a database.
- **Final Layer:** These rules ensure that once the content is readable and accessible, it also looks professional and aligns with the university's brand.

---

### Implementation Roadmap

If you are building your `.yml` rule files today, I suggest this sequence:

1.  **Phase 1 (The Math):** Create `SentenceLength.yml` and `ParagraphLength.yml` in your `WritingQualityStyle` folder.
2.  **Phase 2 (The Navigation):** Create a rule to flag "Click here" and "Read more" (descriptive links).
3.  **Phase 3 (The Vocabulary):** Populate your `reject.txt` files with the "bureaucratic" terms we identified (patron, utilize, etc.).
4.  **Phase 4 (The Branding):** Add the GSU-specific rules like the ":00" time rule and the "adviser" spelling.

**Does this sequence align with your current development timeline, or are you under a specific deadline for accessibility compliance?**
