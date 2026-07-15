cwlVersion: v1.2
$graph:
- class: Workflow
  label: estimate-pi
  doc: Estimates pi by numerically integrating 4/(1+x^2) over [0, 1] using the midpoint
    rule.
  id: estimate-pi
  inputs:
    intervals:
      doc: Number of subintervals used in the midpoint-rule integration
      label: Intervals
      type: int
      default: 1000000
    output_file:
      doc: Name of the output text file
      label: Output filename
      type: string?
      default: pi.txt
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        intervals: intervals
        output_file: output_file
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/marjo-luc/estimate-pi:main
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 1
      coresMin: 1
      outdirMax: 1
  baseCommand: estimate_pi
  inputs:
    intervals:
      type: int
      inputBinding:
        position: 1
        prefix: --intervals
      default: 1000000
    output_file:
      type: string?
      inputBinding:
        position: 2
        prefix: --output_file
      default: pi.txt
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
s:commitHash: d440950b09019b7de76e6d3661ea3c5d3e675db0
s:dateCreated: 2026-07-15
s:license: https://raw.githubusercontent.com/marjo-luc/ogc-app-pack-examples/refs/heads/main/LICENSE
s:softwareVersion: 1.0.0
s:version: main
s:releaseNotes: None
s:keywords: ogc, fortran, math
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
