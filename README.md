equi2cubic
==========

This is a MATLAB script that converts equirectangular images into six cube faces.

**Author: Ray Phan (ray@bublcam.com)**

# Introduction

This is a simple MATLAB script that takes an equirectangular version of a scene that is provided as an image with a 2:1 width and height ratio and creates six cube faces that represents the scene.  If you have seen the repo that performs cubic face to equirectangular version ([https://github.com/rayryeng/cubic2equi](https://github.com/rayryeng/cubic2equi)), this is essentially doing the opposite task.  Again, some good theory on the subject can be found on Paul Bourke's webpage [and can be found here](http://paulbourke.net/geometry/transformationprojection/).

Given an image that is of size ``2n x n``, where ``2n`` is the width and ``n`` is the height of the image, the output will produce 6 images of size ``m x m`` where ``m`` is the width/height of a cube face.  In the Hugin toolkit, they recommend that ``m`` is defined as:

    m = 8*(floor(n/pi/8))
    
Roughly speaking, this is the maximum width/height/depth of a cube that can minimally surround the unit sphere.  In normalized co-ordinates, each dimension `x,y,z` has its domain such that:

    -1 <= x <= 1
    -1 <= y <= 1
    -1 <= z <= 1

The basic premise behind how the cubic image generation works is that the equirectangular image is a flattened representation of a 360 degree scene.  Each point in the equirectangular denotes a point on the surface of the sphere.  If we place the sphere inside a cube, we accomplish converting from equirectangular to cubic, by determining where each point in our sphere **projects** onto the cube.  If we took a point on the sphere and traced a ray from this point outwards until we hit a cube face, this is where the point on the sphere would map to on a cube face.  However, we have the inverse problem.  What we want to do is for a given location in a cube face, we need to figure out which point on the sphere we need to sample from so that we can copy the pixel colour from this point in the sphere onto the cube face.

The basic algorithm to generate a cube face would be to generate a square surface of points that is representative of the cube face we want to generate and positioned in the corresponding spot that is representative of that cube face.  Then, for each point on this cube face, figure out where we need to sample from on the unit sphere and copy this pixel colour over to the cube face.  It should be noted that this code does *not* perform any interpolation when sampling the cubic faces.  This performs nearest neighbour sampling instead.  You are certainly welcome to implement this on your own if you would like!

The mathematics behind how this projection works can be found in the links below.

# Sources of inspiration

This code would have not been made possible without the following sources:

1. [Philip Nowell's post on mapping points from a square to a unit circle - http://mathproofs.blogspot.ca/2005/07/mapping-square-to-circle.html](http://mathproofs.blogspot.ca/2005/07/mapping-square-to-circle.html)
2. [Philip Nowell's post on mapping points from a cube to a unit sphere - http://mathproofs.blogspot.ca/2005/07/mapping-cube-to-sphere.html](http://mathproofs.blogspot.ca/2005/07/mapping-cube-to-sphere.html)
3. Paul Bourke's website - See the Introduction section for link

# Requires

Any version of MATLAB with the Image Processing Toolbox installed.  Alternatively, this should be Octave friendly so you can use that environment if you like.

# How to run the code

Assuming that you already have an equirectangular image loaded in called  ``equi``, you would run the MATLAB script this way:

```
outCube = equi2cubic(equi);
```

``outCube`` is a cell array of 6 elements where each position in this cell array is a cube face for the scene.  Specifically, the cell array is arranged such that:

    outCube{1} = Top Face
    outCube{2} = Bottom Face
    outCube{3} = Left Face
    outCube{4} = Right Face
    outCube{5} = Front Face
    outCube{6} = Back Face

The output width/height of each cube face is calculated using the recommended Hugin default (see Introduction) if the script is called this way.  Alternatively, you can control the output width/height of each cube face by providing a second input parameter such that:

```
outCube = equi2cubic(equi, w);
```

``w`` would be the desired output width/height of a cube face (as an integer of course).  However, if you are in doubt with how to run the code, I have included a sample test script so you can run it and see what the results are.

# Assumptions

No error checking is involved with this code.  This assumes that the equirectangular image is of size `2n x n`.  However, this can handle both monochromatic and grayscale images automatically.  This also assumes that ``w`` is an integer and is strictly positive.

# What is included in this repository
1. The equirectangular-to-cubic conversion script
2. An example script that you can use to see the script in action
3. An example equirectangular image (pulled from Paul Bourke's webpage)

# License
This code is protected under the MIT License.  You may feel free to use the code in any way, shape, or form and can modify it to your heart's content.  You may also include the code in any applications that you develop without releasing any of your code publicly (as per the GPL).  The only thing I request is that you cite where the source came from and give me credit whenever you decide to use it.  Thanks!
