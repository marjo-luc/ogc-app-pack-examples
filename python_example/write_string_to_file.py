#!/usr/bin/env python3
"""Write an input string to a text file."""

import argparse


def write_string_to_file(text: str, output_path: str) -> None:
    """Write ``text`` to the file at ``output_path``."""
    with open(output_path, "w") as f:
        f.write(text)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Write an input string to a text file."
    )
    parser.add_argument("text", help="The string to write to the file.")
    parser.add_argument(
        "-o",
        "--output",
        default="output.txt",
        help="Path to the output text file (default: output.txt).",
    )
    args = parser.parse_args()

    write_string_to_file(args.text, args.output)
    print(f"Wrote {args.text} to {args.output}")


if __name__ == "__main__":
    main()
