# OGC Application Package Examples

A collection of example [OGC Application Packages](https://docs.ogc.org/bp/20-089r1.html) for the
[MAAP](https://maap-project.org/). Each example is a small, self-contained processing
unit bundled with everything needed to register and run it as an
OGC process.

## What is an OGC Application Package?

An OGC Application Package is a standardized way to describe a data-processing application so it can
be deployed and executed portably across platforms. The application's logic is containerized, and a
[Common Workflow Language (CWL)](https://www.commonwl.org/) document declares its inputs, outputs,
container image, and resource requirements. A platform (like MAAP) can then ingest that description
and run the process on demand, wiring the declared inputs to command-line arguments and collecting
the declared outputs.

## The ogc-app-pack-genreator GitHub Action

Pushing a change under an example directory triggers a per-example GitHub workflow (e.g.
`.github/workflows/stac-clip.yml`), which calls the shared
[`.github/workflows/generate-app-pack.yml`](.github/workflows/generate-app-pack.yml). That reusable
workflow runs the [`MAAP-Project/ogc-app-pack-generator`](https://github.com/MAAP-Project/ogc-app-pack-generator)
action, which:

1. Reads the example's `algorithm_config.yml` and `Containerfile`.
2. Builds and publishes the container image.
3. Generates the CWL workflow, writes it to `cwl_workflows/` and commits it back to `main`.
4. Registers the process with the MAAP OGC processes endpoint.

# Examples

| Example | What it does | Runtime | Highlights |
|---------|--------------|---------|------------|
| [Write String to File](#write-string-to-file) | Writes an input string to a text file. | Python script | Simplest example: string in, file out. |
| [Estimate Pi](#estimate-pi) | Estimates π by numerically integrating 4/(1+x²) over [0, 1] (midpoint rule). | Compiled Fortran | A non-Python, compiled-binary process. |
| [Color to Greyscale](#color-to-greyscale) | Converts an input image to greyscale using GDAL. | Python notebook (papermill) | `File` input; notebook-as-process. |
| [STAC Raster Subset](#stac-raster-subset) | Searches the Earthdata CMR STAC catalog, downloads a raster asset, clips it to a bbox, and emits a new STAC Item. | Python notebook (papermill) | STAC in / STAC out; `maap-py` download; `rio-stac` output. |
| [Biomass Change](#biomass-change) | Pulls ESA CCI aboveground biomass tiles from MAAP S3 for two years and visualizes the apparent change over a region. | Python notebook (papermill) | S3 access via `maap-py`; multi-temporal; PNG visualization out. |

# Running the CWL workflows locally

The generated CWL workflows can be run on your own machine with the reference CWL runner,
[`cwltool`](https://github.com/common-workflow-language/cwltool), plus a container engine.

### Prerequisites

- A container engine: **Docker** or **Podman**.
- `cwltool`:

  ```bash
  pip install cwltool
  # or: conda install -c conda-forge cwltool
  ```

### Run an example

Each example ships a sample job file (`input.yml`). From the repository root, run the workflow with
that job file:

```bash
cwltool color_to_greyscale/cwl_workflows/process_color-to-greyscale_main.cwl \
        color_to_greyscale/input.yml
```

The process writes its results into a `Directory` output (globbed as `./output*`), which `cwltool`
stages into your current working directory when the run completes.

Other examples follow the same pattern — point `cwltool` at the example's
`cwl_workflows/process_<name>_main.cwl` and its `input.yml`:

```bash
cwltool write_string_to_file/cwl_workflows/process_write-string-to-file_main.cwl write_string_to_file/input.yml
cwltool estimate_pi/cwl_workflows/process_estimate-pi_main.cwl                   estimate_pi/input.yml
cwltool stac_clip/cwl_workflows/process_stac-clip_main.cwl                       stac_clip/input.yml
```

### Examples that need network access or credentials

`stac_clip` and `biomass_change` fetch remote data. They are intended to run in the MAAP Hub; running them on an arbitrary
  local machine requires equivalent MAAP/AWS credentials to be present in the container's
  environment.

The credential-free examples (`write_string_to_file`, `estimate_pi`, `color_to_greyscale`) run
locally with no extra setup.
