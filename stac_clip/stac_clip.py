#!/usr/bin/env python3
"""Clip a STAC Item's raster asset to a bounding box (STAC in, STAC out).

Reads an input STAC Item, window-reads one of its (Cloud-Optimized GeoTIFF)
assets to the requested bbox, writes the clip as a COG, and emits a new STAC
Item describing the clipped output. Everything is written into ./output so the
CWL workflow can collect it as a Directory output.
"""

import argparse
import json
import os

import pystac
import rasterio
import rasterio.shutil
from rasterio.io import MemoryFile
from rasterio.warp import transform_bounds
from rasterio.windows import from_bounds

OUTPUT_DIR = "output"


def bbox_to_polygon(bbox):
    """Return a GeoJSON Polygon (EPSG:4326) for a [minx, miny, maxx, maxy] bbox."""
    minx, miny, maxx, maxy = bbox
    return {
        "type": "Polygon",
        "coordinates": [
            [
                [minx, miny],
                [maxx, miny],
                [maxx, maxy],
                [minx, maxy],
                [minx, miny],
            ]
        ],
    }


def clip_asset(href, bbox, output_path):
    """Window-read ``href`` to ``bbox`` (lon/lat) and write it as a COG."""
    env = rasterio.Env(
        GDAL_DISABLE_READDIR_ON_OPEN="EMPTY_DIR",
        GDAL_HTTP_MULTIRANGE="YES",
        VSI_CACHE="TRUE",
    )
    with env, rasterio.open(href) as src:
        # The bbox is in EPSG:4326; reproject it to the raster's CRS.
        dst_bounds = transform_bounds("EPSG:4326", src.crs, *bbox)
        window = from_bounds(*dst_bounds, transform=src.transform)
        window = window.round_offsets().round_lengths()

        data = src.read(window=window)
        transform = src.window_transform(window)

        profile = src.profile.copy()
        profile.update(
            driver="GTiff",
            height=data.shape[1],
            width=data.shape[2],
            transform=transform,
            tiled=False,
        )
        # Drop any source block sizes that no longer fit the clipped raster.
        for key in ("blockxsize", "blockysize"):
            profile.pop(key, None)

        # Write to an in-memory GeoTIFF, then CreateCopy it to a valid COG.
        with MemoryFile() as mem:
            with mem.open(**profile) as tmp:
                tmp.write(data)
                rasterio.shutil.copy(tmp, output_path, driver="COG", overwrite=True)


def clip(stac_item_url, asset_name, bbox, output_file):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    output_path = os.path.join(OUTPUT_DIR, output_file)

    item = pystac.Item.from_file(stac_item_url)
    if asset_name not in item.assets:
        raise KeyError(
            f"Asset '{asset_name}' not found. Available: {sorted(item.assets)}"
        )
    href = item.assets[asset_name].href

    clip_asset(href, bbox, output_path)

    # Build the output STAC Item describing the clip.
    out_id = f"{item.id}-clip"
    out_item = pystac.Item(
        id=out_id,
        geometry=bbox_to_polygon(bbox),
        bbox=list(bbox),
        datetime=item.datetime,
        properties={},
    )
    out_item.add_asset(
        "data",
        pystac.Asset(
            href=output_file,  # sibling of the item JSON in the output dir
            media_type=pystac.MediaType.COG,
            roles=["data"],
            title=f"Clipped {asset_name}",
        ),
    )

    item_path = os.path.join(OUTPUT_DIR, f"{out_id}.json")
    with open(item_path, "w") as f:
        json.dump(out_item.to_dict(include_self_link=False), f, indent=2)

    return output_path, item_path


def main():
    parser = argparse.ArgumentParser(
        description="Clip a STAC Item's raster asset to a bounding box."
    )
    parser.add_argument(
        "--stac_item_url",
        required=True,
        help="URL to the input STAC Item JSON.",
    )
    parser.add_argument(
        "--asset_name",
        default="B04",
        help="Name of the asset to clip (default: B04).",
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

    bbox = [float(v) for v in args.bbox.split()]
    if len(bbox) != 4:
        raise ValueError("--bbox must have four values: 'MINX MINY MAXX MAXY'")

    output_path, item_path = clip(
        args.stac_item_url, args.asset_name, bbox, args.output_file
    )
    print(f"Wrote clipped COG to {output_path}")
    print(f"Wrote STAC Item to {item_path}")


if __name__ == "__main__":
    main()
