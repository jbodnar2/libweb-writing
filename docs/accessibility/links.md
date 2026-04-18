# Master List of Bad Link Text Categories

## 1. Vague Action Phrases

**Description:** Links that describe a mechanical action (click, tap, go) without identifying the destination or content.

**Examples:** "Click here", "Click this link", "Go to", "Open this", "Select"

**The Problem:** Screen reader users often navigate by jumping from link to link. Hearing "Click here" five times in a row provides zero context about where each link leads. The user must guess the destination based on surrounding text, which breaks the flow of reading.

---

## 2. Generic "More" Phrases

**Description:** Links that promise additional information without specifying the topic.

**Examples:** "Learn more", "Read more", "Find out more", "See more", "More info", "Details"

**The Problem:** "More" is relative. More about what? Without the specific subject, the link is meaningless in isolation. This forces users to backtrack to read the preceding paragraph to understand the link's purpose.

---

## 3. Raw URLs as Anchor Text

**Description:** Using the full web address (or a truncated version) as the clickable text.

**Examples:** "https://example.com/products/item-123", "www.example.com", "bit.ly/3xYz"

**The Problem:** Screen readers read URLs character by character, including protocols (https://), slashes, and query strings. This is tedious, confusing, and provides no semantic meaning. A user hearing "slash dot dot dot slash products slash item one two three" cannot determine the link's relevance.

---

## 4. Duplicate Anchor Text on a Page

**Description:** Multiple links on the same page sharing the exact same text string.

**Examples:** Five links all labeled "Download PDF" or "Read Article"

**The Problem:** When a screen reader lists all links on a page, the user sees a list of identical items. They cannot distinguish which link goes to which document. Even sighted users may hesitate to click if they cannot tell the difference between two "Submit" buttons.

**Note:** Exceptions exist for standard navigation (e.g., multiple "Home" links in headers/footers).

---

## 5. Self-Referential Language

**Description:** Links that refer to themselves or their position rather than their content.

**Examples:** "This link", "The link below", "The link above", "Here", "It"

**The Problem:** These provide zero information about the destination. "This link" is useless if the user is listening to a list of links extracted from the page, as the spatial context ("below", "above") is lost.

---

## 6. Navigation Commands

**Description:** Links that describe movement or direction rather than the destination.

**Examples:** "Next", "Previous", "Continue", "Go to next page", "Back"

**The Problem:** While sometimes necessary for pagination, these are ambiguous if used elsewhere. "Next" could mean the next chapter, the next step in a form, or the next product. Users need to know what comes next.

---

## 7. Transactional Calls to Action (Without Context)

**Description:** Links focused on conversion that omit the specific product, service, or event.

**Examples:** "Buy now", "Sign up", "Register", "Order", "Book a ticket", "Subscribe"

**The Problem:** "Buy now" for what? "Sign up" for what? Without the object of the action, the link is ambiguous. Users cannot assess the risk or relevance of the action before clicking.

---

## 8. Social Engagement Prompts (Without Platform)

**Description:** Links asking for interaction without specifying the platform or content type.

**Examples:** "Follow us", "Like us", "Share", "Comment", "Tweet this"

**The Problem:** "Follow us" could lead to Facebook, Twitter, LinkedIn, or Instagram. "Share" could open a generic menu or a specific platform. Users need to know the destination to decide if they want to engage.

---

## 9. Support and Contact Ambiguity

**Description:** Links directing users to help without specifying the channel or scope.

**Examples:** "Contact us", "Get help", "Support", "Report issue", "Feedback"

**The Problem:** Does "Contact us" open an email client, a phone dialer, a live chat, or a contact form? Does "Report issue" go to a bug tracker or a customer service email? The lack of specificity causes user anxiety and hesitation.

---

## 10. Non-Descriptive File Types

**Description:** Links that only state the file format without the content title.

**Examples:** "PDF", "DOCX", "JPEG", "Video", "Audio"

**The Problem:** Knowing a link is a PDF tells the user nothing about the document's subject. They must download or open it to find out, which is inefficient and potentially risky (e.g., downloading large files unexpectedly).

---

## 11. Broken or Dead Link Indicators

**Description:** Links that appear functional but lead to 404 errors or broken paths (often indicated by generic text).

**Examples:** "Page not found", "Error", "Broken link", "Under construction"

**The Problem:** While the text describes the error, the link itself is useless. The problem here is often that the link should not exist or should be removed. If the text is "Click here for the broken page," it wastes the user's time.

---

## 12. Redundant Phrasing

**Description:** Links that include unnecessary words like "link", "page", or "website" when the context is obvious.

**Examples:** "Click this link to visit our website", "Go to the homepage page", "Read the article on the blog page"

**The Problem:** This adds cognitive load and verbosity. Screen readers already announce "link," so saying "click this link" is redundant. It clutters the experience without adding value.

---

## 13. Misleading or Deceptive Text

**Description:** Links where the text promises one thing but leads to another.

**Examples:** "Free Download" (leads to a paid signup), "Official Site" (leads to an affiliate), "News" (leads to an ad)

**The Problem:** This erodes trust and is a major accessibility and ethical violation. Users rely on link text to predict the outcome. Deception forces users to waste time verifying the destination.

---

## 14. Image-Only Links (Missing Alt Text)

**Description:** Links where the only content is an image, and the image lacks alternative text.

**Examples:** An icon of a magnifying glass with no alt text, a logo with no alt text acting as a link

**The Problem:** If the image has no alt attribute, screen readers may read the file path (e.g., "icon-search.png") or nothing at all. The link becomes invisible or confusing to assistive technology users.

---

## 15. Long, Unwieldy Strings

**Description:** Links that are excessively long, containing full sentences or paragraphs.

**Examples:** "Click here if you want to read the full article about the history of the internet and how it changed the world forever."

**The Problem:** While descriptive, excessive length makes scanning difficult. Screen reader users may hear a massive block of text for a single link, disrupting their ability to skim the page efficiently. Conciseness is key.

---

## 16. Redundant Destinations (Multiple Texts, One URL)

**Description:** Multiple links on the same page with different text that all point to the exact same destination URL.

**Examples:**

- Link A: "Read our privacy policy" -> /privacy
- Link B: "View legal terms" -> /privacy
- Link C: "Data protection info" -> /privacy

**The Problem:**

- **Accessibility:** Screen reader users navigating by link list will encounter three separate entries for the same destination. This creates clutter and confusion. The user may click one, realize they have been there, and then click another, thinking it is different content.
- **User Experience:** It suggests the content is fragmented or that the site structure is disorganized.
- **SEO:** Search engines may view this as "keyword stuffing" or an attempt to manipulate rankings by linking to the same page with varied anchor text.

**Rule Logic:** Extract all links, group by href, and flag any href that has more than one unique anchor_text.

---

## 17. Ambiguous Targets (Same Text, Different URLs)

**Description:** Multiple links on the same page with identical text that point to different destinations.

**Examples:**

- Link A: "Download Report" -> /reports/2023.pdf
- Link B: "Download Report" -> /reports/2024.pdf
- Link C: "Download Report" -> /downloads/general-guide.pdf

**The Problem:**

- **Accessibility:** This is the inverse of Category 4 (Duplicate Anchor Text). When a screen reader lists links, the user sees "Download Report" three times. They have no way of knowing which file corresponds to which year or type without clicking and guessing.
- **User Experience:** High friction. Users must click, verify, and potentially hit the "back" button repeatedly to find the correct file.
- **Trust:** It feels like a broken interface.

**Rule Logic:** Extract all links, group by anchor_text, and flag any anchor_text that has more than one unique href.

**Note:** You must whitelist standard navigation items (e.g., "Home" linking to the root in header, footer, and sidebar) to avoid false positives.
