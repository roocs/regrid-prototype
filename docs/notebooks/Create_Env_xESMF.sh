#!/bin/bash

# mistral, user related
module unload netcdf_c
module unload python
#module load python3/2020.02-gcc-9.1.0
module load python3/2021.01-gcc-9.1.0
module load anaconda3

# Name of the new environment
envname=clisopsdev

# Name of the new JupyterNB Kernel
kernel_name="clisopsdev"




# Create new conda environment
conda update anaconda
conda create -n $envname python=3
source activate $envname

# Install xesmf and its dependencies
conda install -c conda-forge esmpy xarray scipy dask netCDF4 matplotlib cartopy jupyterlab
#pip install xesmf
git clone https://github.com/pangeo-data/xESMF.git xesmf
#pip install pytest dask toolz
cd xesmf
#git checkout tags/v0.5.0 -b latest
pip install -e .
#python setup.py develop

# Install joint environment.yml
cd ..
conda-env update -n $envname -f environment.yml

# Install clisops and dependencies
for repo in clisops daops roocs-utils
do
  git clone https://github.com/roocs/${repo}.git $repo
  cd $repo
  #conda-env update -n $envname -f environment.yml 
  pip install -r requirements_dev.txt
  #git submodule update --init    # no longer needed
  #python setup.py develop        # alternatively to pip install
  pip install -e .
  cd ..
done

# Optionally install pyesgf and intake-esm (the latter needed for the notebooks)
pip install esgf-pyclient
conda install -c conda-forge ipykernel intake-esm=2020.8.15
#conda install -c conda-forge spyder=4 numpy pandas sympy cython

#Plotting curvilinear grids, UGRID
pip install psy-maps
#conda install -c ncas -c conda-forge cf-python cf-plot

#Conflicting matplotlib version (but might be useful at some point):
#pip install holoviews geoviews datashader

# Install the environment as Kernel for Jupyter
python -m ipykernel install --user --name "$kernel_name" --display-name="$kernel_name"

# Prevent problem (fixture 'tmp_path' not found) with old pytest version
pip install --upgrade pytest

# Final tests
for repo in clisops daops roocs-utils
do
  cd $repo
  pytest -v
  cd ..
done
cd xesmf/xesmf
pytest -v
