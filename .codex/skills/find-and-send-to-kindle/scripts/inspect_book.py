#!/usr/bin/env python3
"""Inspect PDF suitability and validate EPUB packaging for Kindle delivery."""

from __future__ import annotations

import argparse
import json
import posixpath
import sys
import zipfile
from pathlib import Path, PurePosixPath
from xml.etree import ElementTree as ET


def local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def inspect_epub(path: Path, strict: bool) -> dict:
    errors: list[str] = []
    warnings: list[str] = []
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        if not names or names[0] != "mimetype":
            errors.append("mimetype is not the first archive entry")
        elif archive.getinfo("mimetype").compress_type != zipfile.ZIP_STORED:
            errors.append("mimetype is compressed")
        if "mimetype" not in names or archive.read("mimetype") != b"application/epub+zip":
            errors.append("invalid or missing EPUB mimetype")
        if "META-INF/container.xml" not in names:
            errors.append("missing META-INF/container.xml")
            return {"format": "EPUB", "errors": errors, "warnings": warnings}

        try:
            container = ET.fromstring(archive.read("META-INF/container.xml"))
            rootfiles = [e for e in container.iter() if local_name(e.tag) == "rootfile"]
            opf_name = rootfiles[0].attrib["full-path"]
        except (ET.ParseError, IndexError, KeyError) as exc:
            errors.append(f"invalid container.xml: {exc}")
            return {"format": "EPUB", "errors": errors, "warnings": warnings}

        if opf_name not in names:
            errors.append(f"package document not found: {opf_name}")
            return {"format": "EPUB", "errors": errors, "warnings": warnings}

        try:
            opf = ET.fromstring(archive.read(opf_name))
        except ET.ParseError as exc:
            errors.append(f"invalid package XML: {exc}")
            return {"format": "EPUB", "errors": errors, "warnings": warnings}

        opf_dir = PurePosixPath(opf_name).parent
        items: dict[str, tuple[str, str, str]] = {}
        for element in opf.iter():
            if local_name(element.tag) != "item":
                continue
            item_id = element.attrib.get("id", "")
            href = element.attrib.get("href", "")
            media = element.attrib.get("media-type", "")
            props = element.attrib.get("properties", "")
            if not item_id or not href:
                errors.append("manifest item is missing id or href")
                continue
            target = posixpath.normpath((opf_dir / href).as_posix())
            if target not in names:
                errors.append(f"missing manifest target: {target}")
            items[item_id] = (target, media, props)

        spine_ids = [
            element.attrib.get("idref", "")
            for element in opf.iter()
            if local_name(element.tag) == "itemref"
        ]
        if not spine_ids:
            errors.append("spine is empty")
        for item_id in spine_ids:
            if item_id not in items:
                errors.append(f"spine references missing manifest id: {item_id}")

        nav_items = [value for value in items.values() if "nav" in value[2].split()]
        if not nav_items:
            warnings.append("EPUB 3 navigation document not declared")

        xhtml_files = [target for target, media, _ in items.values() if media == "application/xhtml+xml" and target in names]
        word_count = 0
        image_refs = 0
        broken_refs: list[str] = []
        for name in xhtml_files:
            try:
                root = ET.fromstring(archive.read(name))
            except ET.ParseError as exc:
                errors.append(f"invalid XHTML {name}: {exc}")
                continue
            word_count += len(" ".join(root.itertext()).split())
            for element in root.iter():
                if local_name(element.tag) != "img":
                    continue
                image_refs += 1
                src = element.attrib.get("src", "")
                target = posixpath.normpath((PurePosixPath(name).parent / src).as_posix())
                if not src or target not in names:
                    broken_refs.append(f"{name} -> {src or '[missing src]'}")
        errors.extend(f"broken image reference: {value}" for value in broken_refs)

        if not xhtml_files:
            errors.append("no XHTML content documents")
        if word_count == 0:
            warnings.append("no readable text found in XHTML documents")
        if strict and warnings:
            errors.extend(f"strict: {warning}" for warning in warnings)

        return {
            "format": "EPUB",
            "files": len(names),
            "content_documents": len(xhtml_files),
            "spine_items": len(spine_ids),
            "image_references": image_refs,
            "word_count": word_count,
            "errors": errors,
            "warnings": warnings,
        }


def inspect_pdf(path: Path, strict: bool) -> dict:
    try:
        from pypdf import PdfReader
    except ImportError:
        return {"format": "PDF", "errors": ["pypdf is required for PDF inspection"], "warnings": []}

    errors: list[str] = []
    warnings: list[str] = []
    reader = PdfReader(str(path))
    encrypted = bool(reader.is_encrypted)
    if encrypted:
        errors.append("PDF is encrypted; do not bypass access controls")
        return {"format": "PDF", "encrypted": True, "errors": errors, "warnings": warnings}

    pages = len(reader.pages)
    sample_indexes = sorted({0, pages // 4, pages // 2, (3 * pages) // 4, pages - 1}) if pages else []
    sample_counts: list[int] = []
    for index in sample_indexes:
        try:
            sample_counts.append(len((reader.pages[index].extract_text() or "").strip()))
        except Exception as exc:
            warnings.append(f"could not extract text from page {index + 1}: {exc}")
            sample_counts.append(0)

    text_pages = sum(count >= 80 for count in sample_counts)
    if sample_counts and text_pages < max(1, len(sample_counts) // 2):
        warnings.append("little text was extractable; the PDF may be scanned or layout-heavy")
    if strict and not pages:
        errors.append("PDF has no pages")

    try:
        outline_entries = len(reader.outline)
    except Exception:
        outline_entries = 0

    return {
        "format": "PDF",
        "pages": pages,
        "encrypted": False,
        "sample_text_characters": sample_counts,
        "outline_top_level_entries": outline_entries,
        "errors": errors,
        "warnings": warnings,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", type=Path)
    parser.add_argument("--strict", action="store_true", help="fail on EPUB warnings and empty PDFs")
    args = parser.parse_args()
    path = args.file.expanduser().resolve()
    if not path.is_file():
        print(json.dumps({"errors": [f"file not found: {path}"]}, indent=2))
        return 2

    try:
        if path.suffix.lower() == ".epub":
            result = inspect_epub(path, args.strict)
        elif path.suffix.lower() == ".pdf":
            result = inspect_pdf(path, args.strict)
        else:
            result = {"errors": ["supported inputs are .epub and .pdf"], "warnings": []}
    except (OSError, zipfile.BadZipFile, ET.ParseError) as exc:
        result = {"errors": [str(exc)], "warnings": []}

    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 1 if result.get("errors") else 0


if __name__ == "__main__":
    sys.exit(main())
