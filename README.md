AAMexplorer
===========

Visualize a level-set based Active Appearance Model and explore the model parameters in Matlab.
See references for details of the modeling framework.

Run `help aamexplorer` for usage.

The model is presented as a transverse, sagittal and coronal view of the generated image and outline of shape, as well as a 3-D rendering of the shape.
You can navigate the image volume by scrolling though slices, moving the 3-D cursor or rotating the 3-D rendering.
The generated shape is shown as a green contour.
The mean shape can be toggled, and is shown as a red contour.

Parameters can be changed using sliders.
Each paramter represent a certain fraction of the total variance in the appearance model; this fraction is shown next to each parameter slider.
Sliders range from -2 to +2 times the parameter standard deviation.
The first parameter is the most significant.
If the GUI window is not high enough the least significant parameter sliders are not shown.


---
Author: Ulrik Landberg Stephansen <usteph08@student.aau.dk>, Aalborg University




References
----------
Tsai, A. et. al. (2003). [A shape-based approach to the segmentation of medical imagery using level sets][Tsai03]. _IEEE Transactions on Medical Imaging, 22_(2), 137-154.

Hu, S. & Collins, D. L. (2007) [Joint level-set shape modeling and appearance modeling for brain structure segmentation][Hu07]. _NeuroImage, 36_(3), 672-683.


[Hu07]:http://dx.doi.org/10.1016/j.neuroimage.2006.12.048
[Tsai03]:http://dx.doi.org/10.1109/TMI.2002.808355

