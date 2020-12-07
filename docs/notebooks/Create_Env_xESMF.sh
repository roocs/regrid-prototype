#!/bin/bash

# mistral, user related
module unload netcdf_c
module unload python
module load python3/2020.02-gcc-9.1.0
module load anaconda3

# Clone xesmf to this directory
xesmf_dir=xesmf

# Clone clisops to this directory
clisops_dir=clisops

# Name of the new environment
envname=xesmf_test

# Name of the new JupyterNB Kernel
kernel_name="new_kernel"




# Create new conda environment and install xESMF incl dependencies
conda create -n $envname python=3
source activate $envname
conda install -c conda-forge esmpy xarray scipy dask netCDF4 matplotlib cartopy jupyterlab
#pip install xesmf
git clone https://github.com/pangeo-data/xESMF.git $xesmf_dir
#pip install pytest dask toolz
cd $xesmf_dir
#git checkout tags/v0.5.0 -b latest
pip install -e .
#python setup.py develop

# Test the installation
#python -m pytest
#pytest -v --pyargs xesmf

# Install clisops and dependencies
cd ..
git clone https://github.com/roocs/clisops.git $clisops_dir
cd $clisops_dir
conda-env update -n $envname -f environment.yml 
pip install -r requirements_dev.txt 
git submodule update --init
python setup.py develop

# Optionally install pyesgf and intake-esm (the latter needed for the notebooks)
pip install esgf-pyclient
conda install -c conda-forge ipykernel intake-esm=2020.8.15

#Plotting curvilinear grids, UGRID
#pip install psy-maps
#conda install -c ncas -c conda-forge cf-python cf-plot

#Conflicting matplotlib version (but might be useful at some point):
#pip install holoviews geoviews datashader

# Install the environment as Kernel for Jupyter
python -m ipykernel install --user --name "$kernel_name" --display-name="$kernel_name"

# Final test
pytest -v tests
cd ../$xesmf_dir/xesmf
#pytest -v --pyargs xesmf
python -m pytest
