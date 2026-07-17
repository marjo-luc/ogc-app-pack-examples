cwlVersion: v1.2
$graph:
- class: Workflow
  label: stac-clip
  doc: Reads a staged STAC Catalog, clips the requested raster asset to a bounding
    box, and emits a new STAC Catalog describing the clipped output (OGC stage-in /
    stage-out).
  id: stac-clip
  inputs:
    input_catalog:
      doc: Path to the staged STAC Catalog directory (contains catalog.json)
      label: Input STAC Catalog
      type: Directory
    asset_name:
      doc: Name of the raster asset to clip
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
        input_catalog: input_catalog
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
      outdirMax: 10
  baseCommand: run.py
  inputs:
    input_catalog:
      type: Directory
      inputBinding:
        position: 1
        prefix: --input_catalog
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
s:commitHash: 97fb332bbaccbc5e6bf067049be3ca73a1a9e2cc
s:dateCreated: 2026-07-16
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc, stac, raster
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
