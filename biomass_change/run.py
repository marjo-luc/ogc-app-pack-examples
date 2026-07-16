#!/usr/bin/env python3
"""Entrypoint that maps the OGC ``--<name> value`` inputs onto papermill
parameters and executes the biomass_change notebook."""

import argparse
import os

import papermill as pm

NOTEBOOK_PATH = "/app/biomass_change.ipynb"
OUTPUT_DIR = "output"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Execute the biomass_change notebook with papermill."
    )
    parser.add_argument(
        "--collection_id",
        default="ESACCI_Biomass_L4_AGB_V4_100m",
        help="STAC collection id of the annual AGB tiles.",
    )
    parser.add_argument(
        "--tile_id",
        required=True,
        help="ESA CCI tile id (e.g. S10W070).",
    )
    parser.add_argument(
        "--year_start",
        required=True,
        type=int,
        help="Earlier year to compare.",
    )
    parser.add_argument(
        "--year_end",
        required=True,
        type=int,
        help="Later year to compare.",
    )
    parser.add_argument(
        "--asset_name",
        default="estimates",
        help="Name of the AGB asset to read (default: estimates).",
    )
    parser.add_argument(
        "--bbox",
        required=True,
        help="Region to visualize as 'MINX MINY MAXX MAXY' in EPSG:4326.",
    )
    parser.add_argument(
        "--output_file",
        default="biomass_change.png",
        help="Name of the output visualization (default: biomass_change.png).",
    )
    args = parser.parse_args()

    # The notebook writes results into ./output; keep the executed copy there too.
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    executed_notebook = os.path.join(OUTPUT_DIR, "executed_biomass_change.ipynb")

    pm.execute_notebook(
        NOTEBOOK_PATH,
        executed_notebook,
        parameters={
            "collection_id": args.collection_id,
            "tile_id": args.tile_id,
            "year_start": args.year_start,
            "year_end": args.year_end,
            "asset_name": args.asset_name,
            "bbox": args.bbox,
            "output_file": args.output_file,
        },
    )


if __name__ == "__main__":
    main()
