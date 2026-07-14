#!/usr/bin/env python3
"""Write an input string to a text file."""

import argparse
import os

OUTPUT_DIR = "output"


def write_string_to_file(text: str, output_file: str) -> str:
    """Write ``text`` to ``output_file`` inside the output directory.

    The file is written into ``OUTPUT_DIR`` in the current working
    directory so the CWL workflow can collect it as a Directory output.
    """
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    output_path = os.path.join(OUTPUT_DIR, output_file)
    with open(output_path, "w") as f:
        f.write(text)
    return output_path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Write an input string to a text file."
    )
    parser.add_argument(
        "--text",
        required=True,
        help="The string to write to the file.",
    )
    parser.add_argument(
        "--output_file",
        default="output.txt",
        help="Name of the output text file (default: output.txt).",
    )
    args = parser.parse_args()

    output_path = write_string_to_file(args.text, args.output_file)
    print(f"Wrote {args.text} to {output_path}")


if __name__ == "__main__":
    main()
