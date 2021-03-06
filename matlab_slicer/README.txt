3D SLICER & ASSEMBLER
=====================

This code is meant to generate and visualize 3d construction using stacked plates.
Such construction are typically realized with laser cutting.

With this code, the following design workflow is used:
    1) A STL file of the target 3d object is used.
    2) The function 'run_slice.m' is used to slice the 3d object into contour.
    3) The function 'plot_slice.m' is used to visualize the slices and export the contour as PDF.
    4) The PDF contour are imported into a vector graphic tool (e.g., inkscape, illustrator).
    5) In the vector graphic tool, the contour are edited, simplified, and improved.
    6) The slices are exported as a series of black and white bitmap images.
    7) The function 'run_assemble.m' is used to mesh and assemble the exported bitmap images.
    8) The function 'plot_assemble.m' is used to visualize the result.

FAQ
===

Why a vector graphic tool is typically required and the exported contours cannot be used directly?
    The STL file containing the 3d object is sometimes not well formed, i.e. does not contain close volumes.
    For complex STL file, the contours need to be simplified manually for removing features.
    The 'mathematical' slicing does not always provide the most beautiful results. Some manual adaptions might improve the aspect.
    However, in case of a high-quality STL file, the exported contours might be directly used.

Why the assembly step is used bitmap images and not vector graphics?
    Not only the contours are need but also type of the curve (external boundaries or holes).
    The typical vector output format (e.g., pdf, eps, dxf) are difficult to parse in a robust way.
    However, the code is written such that it would be easy to use a vector format parser instead of the bitmap one.

Why the test file used for the slicing ('model.stp') is already composed of stacked plates?
    Of course, the original model should not be composted of stacked plates since such a model is the goal of this code.
    However, for the used 3d model (Porsche 917K), there is not 3d model under a free license.
    Therefore, the model with stacked plates (i.e. the output model) is also used for the slicing (i.e. the input model).

AUTHOR
======

Thomas Guillod.
2019 - BSD License.

COMPATIBILITY
=============

Tested with MATLAB R2018b.

The following toolboxes are used:
    - image_toolbox (for contour detection)
    - map_toolbox (for contour simplification)
    - pde_toolbox (for meshing)

Compatibility with GNU Octave not tested but probably problematic
    - 3d plotting code
    - image detection: 'bwboundaries'
    - contour simplification: 'reducem'
    - mesh creation: 'geometryFromEdges' and 'generateMesh'
