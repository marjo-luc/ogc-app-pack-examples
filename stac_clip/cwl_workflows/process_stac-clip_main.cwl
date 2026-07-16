cwlVersion: v1.2
$graph:
- class: Workflow
  label: stac-clip
  doc: Searches the Earthdata CMR STAC catalog for a granule, downloads a raster asset
    over HTTP, clips it to a bounding box, and emits a new STAC Item describing the
    clipped output.
  id: stac-clip
  inputs:
    collection_id:
      doc: STAC collection id containing the granule
      label: Collection id
      type: string
      default: HLSL30_2.0
    granule_id:
      doc: STAC item (granule) id to clip
      label: Granule id
      type: string
      default: HLS.L30.T10SEG.2023198T184546.v2.0
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
        collection_id: collection_id
        granule_id: granule_id
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
    collection_id:
      type: string
      inputBinding:
        position: 1
        prefix: --collection_id
      default: HLSL30_2.0
    granule_id:
      type: string
      inputBinding:
        position: 2
        prefix: --granule_id
      default: HLS.L30.T10SEG.2023198T184546.v2.0
    asset_name:
      type: string?
      inputBinding:
        position: 3
        prefix: --asset_name
      default: B04
    bbox:
      type: string
      inputBinding:
        position: 4
        prefix: --bbox
      default: -122.55 37.70 -122.35 37.85
    output_file:
      type: string?
      inputBinding:
        position: 5
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
s:commitHash: 4d9d3ca4d6c05c12531acc51ff127e32789ebeb4
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
