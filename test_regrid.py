import xarray as xr
import numpy as np
import clisops.core as clore

grid=clore.Grid(grid_instructor=(3.,))
print(grid)
print("-"*20)

dsc=xr.open_dataset("target_grids/land_sea_mask_2degree.nc4")
gridc=clore.Grid(ds=dsc)
print(gridc)
print("-"*20)
