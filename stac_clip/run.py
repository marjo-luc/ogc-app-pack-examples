#!/usr/bin/env python3
"""Entrypoint that maps the OGC ``--<name> value`` inputs onto papermill
parameters and executes the stac_clip notebook."""

import argparse
import os

import papermill as pm

NOTEBOOK_PATH = "/app/stac_clip.ipynb"
OUTPUT_DIR = "output"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Execute the stac_clip notebook with papermill."
    )
    parser.add_argument(
        "--collection_id",
        required=True,
        help="STAC collection id containing the granule.",
    )
    parser.add_argument(
        "--granule_id",
        required=True,
        help="STAC item (granule) id to clip.",
    )
    parser.add_argument(
        "--asset_name",
        default="estimates",
        help="Name of the raster asset to clip (default: estimates).",
    )
    parser.add_argument(
        "--bbox",
        required=True,
        help="Clip bounding box as 'MINX MINY MAXX MAXY' in EPSG:4326.",
    )
    parser.add_argument(
        "--output_file",
        default="clipped.tif",
        help="Name of the output COG (default: clipped.tif).",
    )
    args = parser.parse_args()

    # The notebook writes results into ./output; keep the executed copy there too.
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    executed_notebook = os.path.join(OUTPUT_DIR, "executed_stac_clip.ipynb")

    pm.execute_notebook(
        NOTEBOOK_PATH,
        executed_notebook,
        parameters={
            "collection_id": args.collection_id,
            "granule_id": args.granule_id,
            "asset_name": args.asset_name,
            "bbox": args.bbox,
            "output_file": args.output_file,
        },
    )


if __name__ == "__main__":
    main()
