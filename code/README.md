# Code for my Bachelor's project
The project is based on a MATLAB module ([upr](https://www.sintef.no/projectweb/mrst/modules/upr/)) and a mesh generator ([Gmsh](https://gmsh.info)).

Code in this directory will firstly be about getting to know the generator (primarily through its Python API) and the MATLAB module. The goal of the project is to join the two, using Gmsh as backend for UPR.

## Packages and versions
This project is running on Python `3.10.2`

All packages can be found in `requirements.txt` and, as usual, installed by running `pip install -r requirements.txt`

Note that in order to run Gmsh, you need to install the Gmsh backend as well. I did this (on Arch Linux) by running `yay -S gmsh`, but depends entirely on your OS. Information on how to install Gmsh can be found at https://gmsh.info