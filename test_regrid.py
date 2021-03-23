import xarray as xr
import numpy as np
import clisops.core as clore

# Create 3deg global grid
grid=clore.Grid(grid_instructor=(3.,))
print(grid)
print("-"*20)

# Load 2degree global grid with specified land sea mask
dsc=xr.open_dataset("regrid-prototype/target_grids/land_sea_mask_2degree.nc4")
gridc=clore.Grid(ds=dsc)
print(gridc)
print("-"*20)

# Create regridding weights to remap the 2degree to the 3degree grid
Regridding_Weights=clore.Weights(gridc, grid, method="conservative")
print(Regridding_Weights.Regridder)
print("-"*20)

# Regrid the land sea mask
ds_out=clore.regrid(gridc.ds, Regridding_Weights.Regridder, 0.5)
print(ds_out)
print("-"*20)

