---
name: find-and-send-to-kindle
description: Find a lawful or authorized EPUB/PDF of a book or document, download or use the user's owned copy, assess Kindle suitability, convert or repair it into a reflowable Paperwhite-friendly EPUB when useful, validate the result, and send it through Gmail or another available delivery route after confirmation. Use when the user asks to find an ebook or PDF and put it on a Kindle, improve a PDF for Kindle/Paperwhite reading, convert a document to EPUB, or deliver an ebook to a Kindle address.
---

# Find and Send to Kindle

Complete the workflow from authorized discovery through verified delivery. Prefer a native, DRM-free EPUB because it preserves reflow, font resizing, navigation, and annotations better than a fixed-layout PDF.

## Workflow

### 1. Establish the target

- Identify the exact title, author, and edition from the request or supplied file.
- Reuse Kindle and sender addresses already supplied in the active conversation. Otherwise ask only when they become necessary.
- Treat addresses as runtime inputs. Never save personal addresses, passwords, cookies, or account tokens in this skill or generated files.

### 2. Find an authorized source

- Search current sources because availability and delivery rules change.
- Prefer, in order: a user-supplied owned file; an official publisher or author download; an official companion repository; a library or storefront download the user is entitled to access; another clearly licensed source.
- Prefer EPUB over PDF when both are authorized and match the requested edition.
- Record the source URL and why it appears authorized. Distinguish a free download from a purchase or account-gated download.
- Do not use piracy mirrors, misleading copies, or files with unclear provenance. Do not bypass paywalls, access controls, or DRM. If the only available copy is DRM-protected, explain the supported vendor or Kindle delivery route.
- Do not claim a third-party repository is authorized merely because it is public.

### 3. Inspect before converting

- Load the bundled workspace dependencies when that capability is available, and use the returned Python executable for the bundled inspector. It includes the PDF libraries the script expects. Otherwise use a Python environment with `pypdf`.
- Confirm the downloaded file opens and matches its extension.
- For EPUB, run `PYTHON scripts/inspect_book.py FILE` and repair only reported structural problems.
- For PDF, run `PYTHON scripts/inspect_book.py FILE`. Assess encryption, text coverage, page count, outline, columns, headers/footers, tables, code, figures, footnotes, and whether pages are scans.
- Render representative PDF pages: cover/front matter, one ordinary prose page, one complex page, and a table/figure page when present.
- Use the PDF skill for PDF inspection and visual verification when available.

### 4. Choose the reading format

- Keep a sound native EPUB and make only necessary metadata, navigation, CSS, or packaging repairs.
- Convert a text-based PDF to reflowable EPUB when prose dominates and the reading order can be recovered reliably.
- Apply OCR before conversion when the PDF is scanned and the user is authorized to process it. Spot-check recognition quality.
- Preserve a layout-heavy PDF when reflow would damage equations, tables, comics, sheet music, or visual relationships. Optimize/crop it only if that improves the target device, and clearly state the tradeoff.
- Never silently remove substantive text, figures, captions, code, footnotes, or tables.

### 5. Build a Paperwhite-friendly EPUB

- Use semantic XHTML with chapters in separate files, a working table of contents, correct spine order, cover, title/author/language metadata, and embedded figures referenced from the manifest.
- Favor device-controlled fonts, scalable text, modest margins, left-aligned body text, and simple high-contrast styling. Avoid fixed widths, tiny type, forced page backgrounds, and unnecessary embedded fonts.
- Remove recurring page headers, footers, printed page numbers, and soft hyphen artifacts. Reconstruct paragraphs and dehyphenate line wraps carefully.
- Preserve headings, lists, block quotes, code blocks, captions, links, italics, and meaningful scene breaks.
- Scale images responsively. Retain legible detail and descriptive alt text where practical.
- Keep intermediate work under the current task's `work/` directory and place user-facing deliverables under its `outputs/` directory.

### 6. Validate and spot-check

- Run `PYTHON scripts/inspect_book.py OUTPUT.epub --strict` with the selected Python executable.
- Use `epubcheck` as an additional validator when installed.
- Inspect the cover, contents, first chapter, a middle chapter, code/table content, images, and final chapter in an EPUB reader or by rendering representative sections.
- Compare representative passages and figures against the source. Report any known limitations instead of describing an unverified conversion as complete.

### 7. Deliver to Kindle

- Verify current Amazon Send to Kindle format and size limits from official Amazon documentation before delivery.
- Prefer the connected Gmail capability. If it cannot attach a local file, use the signed-in browser Gmail interface.
- Prepare a minimal email: Kindle address as recipient, book title as subject, EPUB/PDF attached, and no body unless useful.
- Treat entering the recipient and sending the email as an external communication. Ask for confirmation immediately before the first action that enters the Kindle address or clicks Send, summarizing sender, recipient, subject, and attachment.
- After confirmation, send once. Verify Gmail's authoritative `Message sent` signal; do not infer success from a click alone.
- Tell the user delivery may take several minutes. If it fails to appear, check Amazon's approved personal-document sender list, document status, format/size rules, Wi-Fi/sync, and any Amazon rejection email.

## Resources

- `scripts/inspect_book.py`: inspect PDFs and validate EPUB packaging; use `--strict` before delivery.
- `references/quality-checklist.md`: read when converting or repairing a file, or when investigating a failed Kindle delivery.

## Completion report

State the source and format used, whether conversion was needed, the validation result, the output file, and delivery status. Do not expose account secrets or unrelated mailbox content.
