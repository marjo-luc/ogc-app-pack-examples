cwlVersion: v1.2
$graph:
- class: Workflow
  label: color-to-greyscale
  doc: Converts an input image to greyscale using GDAL.
  id: color-to-greyscale
  inputs:
    input_image:
      doc: Input image to convert to greyscale
      label: Input image
      type: File
      default:
        class: File
        path: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/color_to_greyscale/nasa_maap_logo.png
    output_file:
      doc: Name of the output greyscale image
      label: Output filename
      type: string?
      default: greyscale.tif
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        input_image: input_image
        output_file: output_file
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/color-to-greyscale:main
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 5
      coresMin: 1
      outdirMax: 10
  baseCommand: run.py
  inputs:
    input_image:
      type: File
      inputBinding:
        position: 1
        prefix: --input_image
      default:
        class: File
        path: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/color_to_greyscale/nasa_maap_logo.png
    output_file:
      type: string?
      inputBinding:
        position: 2
        prefix: --output_file
      default: greyscale.tif
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
s:commitHash: 3fe29205efd7cc14d4d62d06b4e11185b942cdc9
s:dateCreated: 2026-07-15
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc, gdal
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
