cwlVersion: v1.2
$graph:
- class: Workflow
  label: print-message
  doc: Takes in a string and prints it.
  id: print-message
  inputs:
    message:
      doc: Message to print
      label: message
      type: string
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        message: message
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/ogc-app-pack-examples:main
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 1
      coresMin: 1
      outdirMax: 1
  baseCommand: /app/print_message.py
  inputs:
    message:
      type: string
      inputBinding:
        position: 1
        prefix: --message
  outputs:
    outputs_result:
      outputBinding:
        glob: ./output*
      type: Directory
s:author:
- class: s:Person
  s:name: Marjorie Lucas
s:contributor:
- class: s:Person
  s:name: Marjorie Lucas
s:citation: https://github.com/marjo-luc/ogc-app-pack-examples.git
s:codeRepository: https://github.com/marjo-luc/ogc-app-pack-examples.git
s:commitHash: 3a9b8d89c3c2c0730364d9443a92b2603d25c7fd
s:dateCreated: 2025-07-11
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
