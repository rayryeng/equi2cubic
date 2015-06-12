equi2cubic
==========

This is a MATLAB script that converts equirectangular images into six cube faces.

**Author: Ray Phan (ray@bublcam.com)**

# Introduction

This is a simple MATLAB script that takes an equirectangular version of a scene that is provided as an image with a 2:1 width and height ratio and creates six cube faces that represents the scene.  If you have seen the repo that performs cubic face to equirectangular version ([https://github.com/rayryeng/cubic2equi](https://github.com/rayryeng/cubic2equi)), this is essentially doing the opposite task.  Again, some good theory on the subject can be found on Paul Bourke's webpage [and can be found here](http://paulbourke.net/geometry/transformationprojection/).

Given an image that is of size ``2n x n``, where ``2n`` is the width and ``n`` is the height of the image, the output will produce 6 images of size ``m x m`` where ``m`` is the width/height of a cube face.  In the Hugin toolkit, they recommend that ``m`` is defined as:

    m = 8*(floor(2*n/pi/8))

As an added bonus, bilinear interpolation is performed when sampling from the equirectangular image to generate the cube faces.

# Sources of inspiration

This code would have not been made possible without the following sources:

1. Paul Bourke's website - See the Introduction section for link
2. The BigShot JavaScript library: [https://bitbucket.org/leo_sutic/bigshot](https://bitbucket.org/leo_sutic/bigshot).  I didn't use the library, but I used their equirectangular to cubic conversion code as inspiration and as a means of double-checking my implementation.  In essence, this is a MATLAB transcription of these two pieces of code - [```AbstractCubicTransform - transform()```](https://bitbucket.org/leo_sutic/bigshot/src/e7bd8aeead5708974c67204d62812dad0e50ee45/src/java/bigshot/AbstractSphericalCubicTransform.java?at=default#cl-62), [the ```EquirectangularToCubic``` class](https://bitbucket.org/leo_sutic/bigshot/src/e7bd8aeead5708974c67204d62812dad0e50ee45/src/java/bigshot/EquirectangularToCubic.java?at=default)

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

As a means of experimentation, you can also vary the vertical field of view.  For cubic images, the vertical field of view is 90 degrees per face, but you can vary this to see what the effects are.  In other words:

```
outCube = equi2cubic(equi, w, vfov);
```

`vfov` is the vertical field of view *in degrees*.

# Assumptions

No error checking is involved with this code.  This assumes that the equirectangular image is of size `2n x n`.  However, this can handle both monochromatic and grayscale images automatically.  This also assumes that ``w`` is an integer and is strictly positive.

# What is included in this repository
1. The equirectangular-to-cubic conversion script
2. An example script that you can use to see the script in action
3. An example equirectangular image (pulled from Paul Bourke's webpage)

# License
This code is protected under the MIT License.  You may feel free to use the code in any way, shape, or form and can modify it to your heart's content.  You may also include the code in any applications that you develop without releasing any of your code publicly (as per the GPL).  The only thing I request is that you cite where the source came from and give me credit whenever you decide to use it.  Thanks!
