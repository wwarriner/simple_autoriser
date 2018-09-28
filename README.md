# Simple Autoriser
The purpose of this code is to serve as a demonstration of how metalcasting feeders can be identified automatically from geometry. It serves as a companion for the paper [citation tbd], by William Warriner.

# Usage
The entirety of the code is encapsulated in a single function, together with an example script of how to use it, and a sample stereolithography (STL) geometry file. Run the script `determine_feeders_example.m` to see the function in action. Feel free to explore, examine, modify, and build on the code. If you do, please let us know! If you have any questions, comments, concerns, suggestions, or bug reports, don't hesitate to contact us!

The external libraries and MATLAB toolboxes listed below are required. The code was written in `R2018a`, and is not guaranteed to work for previous versions. The libraries are included with the code, and have their own licenses. Ensure all subfolders of the repository root folder are on the MATLAB path.

#### External Libraries
- [3D Euclidean Distance Transform for Variable Data Aspect Ratio](https://www.mathworks.com/matlabcentral/fileexchange/15455-3d-euclidean-distance-transform-for-variable-data-aspect-ratio) (bwdistsc, BSD)
- [Mesh voxelization](https://www.mathworks.com/matlabcentral/fileexchange/27390-mesh-voxelisation) (Mesh_voxelization, BSD)
- [Matlab Capped Cylinder](https://github.com/wwarriner/matlab_capped_cylinder)
- [Generate maximally perceptually-distinct colors](https://www.mathworks.com/matlabcentral/fileexchange/29702-generate-maximally-perceptually-distinct-colors)

#### MATLAB Toolboxes
- [Image Processing Toolbox](https://www.mathworks.com/products/image.html)

# Planned Changes
There are no plans for additional changes.
