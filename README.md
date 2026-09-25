# Image and Signal Processing Coursework

## Overview

This repository contains 2025 coursework for Image and Signal Processing. It
collects MATLAB lab exercises and homework assignments covering audio analysis,
image filtering, histogram equalisation, Fourier and wavelet methods, image
registration, watermark processing, and related image-processing exercises.

## Tech Stack

- MATLAB
- MATLAB image-processing functions such as `imread`, `imrotate`, `medfilt2`,
  `hough`, `dct2`, and `imregcorr`
- MATLAB audio-processing functions such as `audioread` and `audiowrite`

## Features and repository structure

- `hw/` contains homework assignments, their MATLAB source files, input media,
  generated outputs, image assets grouped in local `images/` directories, and
  the Homework 3 report.
- `hw/hw1/audio/` contains the Homework 1 audio input and generated filtered
  output.
- `lab/` contains introductory exercises, MATLAB scripts, supporting datasets,
  generated examples, and image assets grouped in local `images/` directories.
- `lab/audio/` contains the lab audio inputs and generated audio output.
- `lab/color_processing_and_watermarking/watermark/images/` and
  `lab/image_pyramids_and_enhancement/lena_noise/images/`
  contain the image sequences used by those exercises.
- `lab/color_processing_and_watermarking/Sentinel2.README.txt` documents the
  included Sentinel-2A TIFF data and its technical properties.

The lesson directories use descriptive names based on their locally verified
contents: color processing and watermarking, earth texture processing, image
pyramids and enhancement, Hough line detection, and wavelets, compression, and
panorama processing.

The scripts and their inputs are generally kept together by homework or lesson.
Many scripts use paths relative to the current MATLAB working directory, so
run a script from the directory that contains it and its referenced inputs.

## Getting Started

### Requirements

MATLAB is required. Some scripts use functions from MATLAB toolboxes for image,
audio, filtering, registration, or transform processing. The repository does
not define a pinned MATLAB release or an automated environment.

### Installation

No installation command or dependency manifest is included. Open the repository
in MATLAB and use the existing directory layout.

### Running

Select the directory containing a script as the current MATLAB working
directory, then run the relevant `.m` file from the MATLAB editor or command
window. Examples include:

- `hw/hw1/audio_15_analysis.m`
- `hw/hw2/hw2_maria_romero.m`
- `lab/image_pyramids_and_enhancement/pyramid_grayscale.m`
- `lab/wavelets_compression_and_panorama/panorama.m`

Not every script is self-contained. The repository currently does not include
some inputs referenced by the scripts, including `yellowlily.jpg`,
`cameraman.tif`, `gantrycrane.png`, and `pout.tif`. Those exercises require the
corresponding external or course-provided files before they can be run.

## Results

The repository includes the Homework 3 report:
[`hw/hw3/ISP_Hw3_Report___Histogram_Equalisation.pdf`](hw/hw3/ISP_Hw3_Report___Histogram_Equalisation.pdf).
It also includes supporting datasets and generated image/audio examples
alongside the corresponding exercises.

## Academic Context

This repository is coursework for Image and Signal Processing from 2025,
including lab exercises and assignments. Some starter code was provided; the
remaining work is mine.
