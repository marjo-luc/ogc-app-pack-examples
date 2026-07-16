cwlVersion: v1.2
$graph:
- class: Workflow
  label: biomass-change
  doc: Pulls ESA CCI aboveground biomass tiles from MAAP S3 (via maap-py) for two
    years and visualizes the apparent change in biomass over a region.
  id: biomass-change
  inputs:
    collection_id:
      doc: STAC collection id of the annual AGB tiles
      label: Collection id
      type: string
      default: ESACCI_Biomass_L4_AGB_V4_100m
    tile_id:
      doc: ESA CCI tile id (e.g. S10W070)
      label: Tile id
      type: string
      default: S10W070
    year_start:
      doc: Earlier year to compare
      label: Start year
      type: int
      default: 2019
    year_end:
      doc: Later year to compare
      label: End year
      type: int
      default: 2020
    asset_name:
      doc: Name of the AGB asset to read
      label: Asset name
      type: string?
      default: estimates
    bbox:
      doc: Region to visualize as 'MINX MINY MAXX MAXY' in EPSG:4326
      label: Bounding box
      type: string
      default: -65 -12 -63 -10
    output_file:
      doc: Name of the output visualization
      label: Output filename
      type: string?
      default: biomass_change.png
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        collection_id: collection_id
        tile_id: tile_id
        year_start: year_start
        year_end: year_end
        asset_name: asset_name
        bbox: bbox
        output_file: output_file
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/biomass-change:main
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
      default: ESACCI_Biomass_L4_AGB_V4_100m
    tile_id:
      type: string
      inputBinding:
        position: 2
        prefix: --tile_id
      default: S10W070
    year_start:
      type: int
      inputBinding:
        position: 3
        prefix: --year_start
      default: 2019
    year_end:
      type: int
      inputBinding:
        position: 4
        prefix: --year_end
      default: 2020
    asset_name:
      type: string?
      inputBinding:
        position: 5
        prefix: --asset_name
      default: estimates
    bbox:
      type: string
      inputBinding:
        position: 6
        prefix: --bbox
      default: -65 -12 -63 -10
    output_file:
      type: string?
      inputBinding:
        position: 7
        prefix: --output_file
      default: biomass_change.png
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
s:commitHash: 9e551f27d4b4ed49da23260c656651a54df9e4ed
s:dateCreated: 2026-07-16
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc, stac, biomass, raster
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
