import xarray as xr
import numpy as np
import clisops.core as clore
from clisops.ops.regrid import regrid

# Create Grid object for MPIOM tos data:
dso_path="mini-esgf-data/test_data/badc/cmip6/data/CMIP6/CMIP/MPI-M/MPI-ESM1-2-HR/historical/r1i1p1f1/Omon/tos/gn/v20190710/tos_Omon_MPI-ESM1-2-HR_historical_r1i1p1f1_gn_185001.nc"
dso=xr.open_dataset(dso_path)
grido=clore.Grid(ds=dso)
print(repr(grido))
print("-"*20)

# Create 3deg global grid
grid=clore.Grid(grid_instructor=(3.,))
print(repr(grid))
print("-"*20)

# Load 1degree global grid
grid1d=clore.Grid(grid_id="1deg")
print(repr(grid1d))
print("-"*20)

# Load 2degree global grid with specified land sea mask
# at a later point: gridc=clore.Grid(grid_id="2deg_lsm")
dsc=xr.open_dataset("target_grids/land_sea_mask_2degree.nc4")
gridc=clore.Grid(ds=dsc)
print(repr(gridc))
print("-"*20)

# Create regridding weights to remap the 2degree to the 3degree grid
Regridding_Weights=clore.Weights(gridc, grid, method="conservative")
print(Regridding_Weights.Regridder)
print("-"*20)

# Regrid the land sea mask
ds_out=clore.regrid(gridc.ds, Regridding_Weights.Regridder, 0.5)
print(ds_out)
print("-"*20)

# Regrid using the ops regrid function
# Adaptive masking fails when providing an entire dataset and not just a data array for remapping
print("\nBefore:\n")
print(dso)
print ("\nAfter:\n")
ds_regrid = regrid(ds=dso, grid="1deg", method="conservative", adaptive_masking_threshold=-1, output_type="xarray")
print(ds_regrid)
