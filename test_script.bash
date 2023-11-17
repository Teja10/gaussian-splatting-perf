#!/bin/bash

# Define the range of values for BLOCK_X and BLOCK_Y
block_values=(1 2 4 8 16 32 64 128)

# Loop over the values
for block in "${block_values[@]}"; do
  # Edit config.h
  sed -i "s/^#define BLOCK_X .*/#define BLOCK_X $block/" submodules/diff-gaussian-rasterization/cuda_rasterizer/config.h
  sed -i "s/^#define BLOCK_Y .*/#define BLOCK_Y $block/" submodules/diff-gaussian-rasterization/cuda_rasterizer/config.h

  # Compile the Pytorch extension
  pip install -e submodules/diff-gaussian-rasterization

  mkdir ./logs/tile_${block}
  # Run the training process and redirect output to a file
  python train.py -s ~/nerf_data/nerf-360/bicycle --trace_output_dir ./logs/tile_${block}

  # Remove the cached build directory
  rm -rf submodules/diff-gaussian-rasterization/build/
done