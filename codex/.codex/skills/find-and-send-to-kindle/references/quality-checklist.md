# Kindle document quality checklist

Read this checklist while converting or repairing a book and while diagnosing a failed delivery.

## Source and identity

- Confirm title, author, edition, language, and completeness.
- Retain the authorized source URL or note that the user supplied an owned file.
- Confirm the file signature matches EPUB/PDF and that it is not encrypted or DRM-protected.

## EPUB structure

- Store `mimetype` first and without compression.
- Include a valid container, package document, manifest, spine, navigation document, and cover.
- Ensure every manifest, spine, navigation, image, stylesheet, and hyperlink target resolves.
- Split long works at meaningful chapter or section boundaries.
- Set title, creator, language, identifier when known, and modified date.

## Reading quality

- Verify paragraph order across pages and columns.
- Remove repeated headers, footers, printed folios, and accidental line-break hyphenation.
- Preserve emphasis, headings, lists, quotations, code, captions, footnotes, and links.
- Check that tables remain understandable. Use a labeled image only when semantic reflow would be worse.
- Check that figures are present, correctly placed, scaled to the viewport, and legible in grayscale.
- Avoid body text baked into page images unless faithful reflow is impractical.
- Let the Kindle control body font, size, line spacing, and background.

## Representative verification

- Compare the cover, contents, beginning, middle, and ending against the source.
- Sample every unusual content type: multi-column pages, code, equations, tables, footnotes, and full-page figures.
- Confirm chapter navigation and reading order in an EPUB reader.
- Run the bundled strict inspector and `epubcheck` when available.

## Delivery

- Check Amazon's current official supported formats and size limit.
- Attach only the final validated file.
- Confirm sender, Kindle recipient, subject, and attachment immediately before sending.
- Verify Gmail reports `Message sent`.
- If the book does not appear, check Amazon approval of the sender address, document status/rejection email, device sync/Wi-Fi, and current format/size rules.
