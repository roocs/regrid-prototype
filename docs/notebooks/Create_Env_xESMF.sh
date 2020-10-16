#!/bin/bash

# mistral, user related
module unload netcdf_c
module unload python
module load python3/2020.02-gcc-9.1.0
module load anaconda3

# Clone xesmf to this directory
xesmf_dir=xesmf_latest

# Clone clisops to this directory
clisops_dir=clisops

# Name of the new environment
envname=xesmf_test

# Name of the new JupyterNB Kernel
kernel_name="new_kernel"




# Create new conda environment and install xESMF incl dependencies
conda create -n $envname python=3
source activate $envname
conda install -c conda-forge esmpy
#pip install xesmf
git clone https://github.com/pangeo-data/xESMF.git $xesmf_dir
git checkout tags/v0.4.0 -b latest
pip install pytest dask toolz
cd $xesmf_dir
python setup.py install

# Test the installation
python -m pytest
#pytest -v --pyargs xesmf

# Install clisops and dependencies
cd ..
mkdir -p $clisops_dir
git clone https://github.com/roocs/clisops.git $clisops_dir
cd $clisops_dir
conda-env update -n $envname -f environment.yml 
pip install -r requirements_dev.txt 
conda install -c conda-forge cartopy ipykernel jupyterlab udunits2=2.2
git submodule update --init
python setup.py develop

# Optionally install pyesgf and intake-esm (the latter needed for the notebooks)
conda install -c conda-forge intake-esm 
pip install esgf-pyclient

#Plotting curvilinear grids, UGRID
#pip install psy-maps
#conda install -c ncas -c conda-forge cf-python cf-plot

#Conflicting matplotlib version (but might be useful at some point):
#pip install holoviews geoviews datashader

# Install the environment as Kernel for Jupyter
python -m ipykernel install --user --name "$kernel_name" --display-name="$kernel_name"

# Final test
pytest -v tests
cd ../$xesmf_dir
#pytest -v --pyargs xesmf
python -m pytest
