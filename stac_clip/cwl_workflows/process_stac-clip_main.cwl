cwlVersion: v1.2
$graph:
- class: Workflow
  label: stac-clip
  doc: Searches the MAAP STAC catalog for a granule, downloads a raster asset, clips
    it to a bounding box, and emits a new STAC Item describing the clipped output.
  id: stac-clip
  inputs:
    collection_id:
      doc: STAC collection id containing the granule
      label: Collection id
      type: string
      default: ESACCI_Biomass_L4_AGB_V4_100m
    granule_id:
      doc: STAC item (granule) id to clip
      label: Granule id
      type: string
      default: S50W080_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2020-fv4.0
    asset_name:
      doc: Name of the raster asset to clip
      label: Asset name
      type: string?
      default: estimates
    bbox:
      doc: Clip bounding box as 'MINX MINY MAXX MAXY' in EPSG:4326
      label: Bounding box
      type: string
      default: -78 -58 -76 -56
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
      ramMin: 2048
      coresMin: 1
      outdirMax: 500
  baseCommand: run.py
  inputs:
    collection_id:
      type: string
      inputBinding:
        position: 1
        prefix: --collection_id
      default: ESACCI_Biomass_L4_AGB_V4_100m
    granule_id:
      type: string
      inputBinding:
        position: 2
        prefix: --granule_id
      default: S50W080_ESACCI-BIOMASS-L4-AGB-MERGED-100m-2020-fv4.0
    asset_name:
      type: string?
      inputBinding:
        position: 3
        prefix: --asset_name
      default: estimates
    bbox:
      type: string
      inputBinding:
        position: 4
        prefix: --bbox
      default: -78 -58 -76 -56
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
s:commitHash: 30413f08847a7bfae47b4fecc7a9b89ede5e421b
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
