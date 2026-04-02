#!/usr/bin/env python3
"""Check ASCII art box-drawing alignment in markdown files.

Finds all box blocks (┌...┘) within code fences and reports lines
whose display width differs from the top border.

Usage: python3 check_alignment.py <file.md>
"""

import sys
import unicodedata


def display_width(s: str) -> int:
    """Calculate terminal display width of a string.

    CJK characters (East Asian Width F/W) = 2 columns.
    All other characters = 1 column.
    """
    w = 0
    for c in s:
        if unicodedata.east_asian_width(c) in ("F", "W"):
            w += 2
        else:
            w += 1
    return w


def check_file(path):
    """Check alignment of all box-drawing blocks in a markdown file.

    Returns list of (line_number, actual_width, expected_width, content)
    for misaligned lines.
    """
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    problems = []
    in_code = False
    code_lines = []  # list of (line_num, content)

    for i, line in enumerate(lines, 1):
        stripped = line.rstrip("\n")
        if stripped.startswith("```"):
            if in_code:
                # Process code block
                problems.extend(_check_code_block(code_lines))
                code_lines = []
                in_code = False
            else:
                in_code = True
                code_lines = []
            continue
        if in_code:
            code_lines.append((i, stripped))

    return problems


def _check_code_block(
    code_lines,
):
    """Check box blocks within a single code block."""
    problems = []
    box_start_width = None
    box_lines = []  # list of (line_num, content)

    for ln, content in code_lines:
        trimmed = content.lstrip()
        if trimmed.startswith("┌"):
            box_start_width = display_width(content)
            box_lines = [(ln, content)]
        elif box_start_width is not None:
            if any(c in content for c in "│├└"):
                box_lines.append((ln, content))
            if trimmed.startswith("└"):
                # Box complete - check widths
                for bln, bcontent in box_lines:
                    w = display_width(bcontent)
                    if w != box_start_width:
                        problems.append((bln, w, box_start_width, bcontent))
                box_start_width = None
                box_lines = []

    return problems


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <file.md>", file=sys.stderr)
        sys.exit(1)

    path = sys.argv[1]
    problems = check_file(path)

    if problems:
        print(f"ALIGNMENT PROBLEMS in {path}:")
        for ln, actual, expected, content in problems:
            print(f"  L{ln}: width={actual} (expected {expected})")
            print(f"    {content}")
        sys.exit(1)
    else:
        print(f"All box-drawing blocks in {path} are properly aligned.")
        sys.exit(0)


if __name__ == "__main__":
    main()
