# Image and Signal Processing Coursework

## Overview

This repository contains 2025 coursework for Image and Signal Processing. It
collects MATLAB homework assignments and lab exercises covering audio analysis,
image filtering, histogram equalisation, Fourier and wavelet methods, image
registration, watermark processing, and related image-processing exercises.

## Tech Stack

- MATLAB
- MATLAB image-processing functions such as `imread`, `imrotate`, `medfilt2`,
  `hough`, `dct2`, and `imregcorr`
- MATLAB audio and signal-processing functions such as `audioread`,
  `audiowrite`, `findpeaks`, `filtfilt`, and `designfilt`

## Coursework contents and structure

`hw/` contains the homework assignments, while `lab/` contains guided
image-processing and signal-processing exercises.

- **Homework 1 — Audio analysis and filtering:** analyses an audio recording in
  the time and frequency domains, then applies smoothing, low-pass filtering,
  and volume normalization in MATLAB.
- **Homework 2 — Image denoising and correction:** reduces salt-and-pepper
  noise with a median filter, rotates the image, and crops the resulting
  borders.
- **Homework 3 — Histogram equalisation:** implements global and local
  histogram equalisation for grayscale and color images, including a tile-based
  contrast-limited method with interpolation. The accompanying
  [report](hw/hw3/ISP_Hw3_Report___Histogram_Equalisation.pdf) describes the
  methods and experimental results.
- **Audio signal exercises:** explores tone synthesis, Fourier spectra,
  frequency selection, filtering, and audio reconstruction using scripts such
  as `lab/audio_signal_experiments.m`, `lab/cmajor.m`, and
  `lab/noisy_signal_and_filtering.m`.
- **Color processing and watermarking:** applies color quantization and
  color-space processing, and estimates and removes a watermark from an image
  sequence using `lab/color_processing_and_watermarking/watermark.m`.
- **Earth texture processing:** transforms a southern-hemisphere Earth texture
  into a circular projection using spherical coordinates and interpolation.
- **Hough line detection:** detects image edges and line segments with Canny
  edge detection and the Hough transform.
- **Image pyramids and enhancement:** builds Gaussian and Laplacian pyramids,
  applies adaptive tile enhancement, and averages noisy Lena image samples.
- **Wavelets, compression, and panorama processing:** implements Haar wavelet
  decomposition and reconstruction, performs block-based JPEG-style and
  wavelet compression, and registers overlapping images to create a panorama.
- **Additional image and signal exercises:** includes median filtering and
  phase-interference demonstrations in the MATLAB scripts at the `lab/` level.

## Getting Started

### Requirements

MATLAB is required. Individual scripts use MATLAB image-processing,
audio/signal-processing, filtering, registration, and transform functions, so
the relevant MATLAB toolbox capabilities are required for the selected
exercise. The repository does not specify a pinned MATLAB release or provide a
dependency manifest.

Several scripts expect external or course-provided inputs that are not
included here: `yellowlily.jpg`, `cameraman.tif`, `gantrycrane.png`, and
`pout.tif`.

### Installation

No installation command is required or provided. Open the repository in MATLAB
and use the existing coursework files and datasets.

### Running

Run a script from the directory expected by its relative paths. For example,
from the repository root, open MATLAB and use:

```matlab
cd('hw/hw1')
audio_15_analysis
```

Other documented entry points include:

- `hw/hw2/hw2_maria_romero.m`
- `hw/hw3/hw3_maria_romero.m`
- `lab/image_pyramids_and_enhancement/pyramid_grayscale.m`
- `lab/wavelets_compression_and_panorama/panorama.m`

Not every script is self-contained. In particular, scripts that reference the
external inputs listed above require those files before they can be run.

## Results

The repository includes the [Homework 3 report](hw/hw3/ISP_Hw3_Report___Histogram_Equalisation.pdf),
which documents grayscale and color histogram equalisation methods,
tile-based contrast-limited enhancement, and experimental results. Supporting
datasets and generated image/audio examples are kept with the corresponding
coursework.

## Academic Context

This repository is coursework for Image and Signal Processing from 2025. Some
starter code was provided; the remaining work is mine.
