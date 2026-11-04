cwlVersion: v1.2
$graph:
- class: Workflow
  label: write-string-to-file-gha
  doc: Writes an input string to a text file.
  id: write-string-to-file-gha
  inputs:
    text:
      doc: The string to write to the file
      label: Input text
      type: string
      default: Hello, world!
    output_file:
      doc: Path to the output text file
      label: Output filename
      type: string?
      default: output.txt
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        text: text
        output_file: output_file
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/write-string-to-file-gha:main
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 1
      coresMin: 1
      outdirMax: 1
  baseCommand: write_string_to_file.py
  inputs:
    text:
      type: string
      inputBinding:
        position: 1
        prefix: --text
      default: Hello, world!
    output_file:
      type: string?
      inputBinding:
        position: 2
        prefix: --output_file
      default: output.txt
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
s:commitHash: 365c50c0391adff8e1c20a64df1a57ae8e5055a5
s:dateCreated: 2026-11-04
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
