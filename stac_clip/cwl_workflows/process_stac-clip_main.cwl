cwlVersion: v1.2
$graph:
- class: Workflow
  label: stac-clip
  doc: Clips a STAC Item's raster asset to a bounding box and emits a new STAC Item
    describing the clipped output.
  id: stac-clip
  inputs:
    stac_item_url:
      doc: URL to the input STAC Item JSON
      label: STAC Item URL
      type: string
      default: https://cmr.earthdata.nasa.gov/stac/LPCLOUD/collections/HLSL30_2.0/items/HLS.L30.T10SEG.2023198T184546.v2.0
    asset_name:
      doc: Name of the asset to clip
      label: Asset name
      type: string?
      default: B04
    bbox:
      doc: Clip bounding box as 'MINX MINY MAXX MAXY' in EPSG:4326
      label: Bounding box
      type: string
      default: -122.55 37.70 -122.35 37.85
    output_file:
      doc: Name of the output COG
      label: Output filename
      type: string?
      default: clipped.tif
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        stac_item_url: stac_item_url
        asset_name: asset_name
        bbox: bbox
        output_file: output_file
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/stac-clip:main
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 5
      coresMin: 1
      outdirMax: 100
  baseCommand: stac_clip.py
  inputs:
    stac_item_url:
      type: string
      inputBinding:
        position: 1
        prefix: --stac_item_url
      default: https://cmr.earthdata.nasa.gov/stac/LPCLOUD/collections/HLSL30_2.0/items/HLS.L30.T10SEG.2023198T184546.v2.0
    asset_name:
      type: string?
      inputBinding:
        position: 2
        prefix: --asset_name
      default: B04
    bbox:
      type: string
      inputBinding:
        position: 3
        prefix: --bbox
      default: -122.55 37.70 -122.35 37.85
    output_file:
      type: string?
      inputBinding:
        position: 4
        prefix: --output_file
      default: clipped.tif
  outputs:
    outputs_result:
      outputBinding:
        glob: ./output*
      type: Directory
s:author:
- class: s:Person
  s:name: mlucas
s:contributor:
- class: s:Person
  s:name: mlucas
s:citation: https://github.com/marjo-luc/ogc-app-pack-examples.git
s:codeRepository: https://github.com/marjo-luc/ogc-app-pack-examples.git
s:commitHash: b7876be8f8e309d89602cbc5ec0f9dadcfd3d5c1
s:dateCreated: 2026-07-15
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc, stac, raster
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
