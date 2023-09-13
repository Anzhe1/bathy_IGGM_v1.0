Improved gravity-geologic method reliably removing the long-wavelength gravity effect of regional seafloor topography
This is my share of IGGM technology. Limited by their own capabilities, there are still many places to improve. 
If you have any suggestions and comments, don't hesitate to contact me andechao@126.com
Thank you!

information about code:
Notice: Gross errors detection and elimination of shipborned bathymetry data were performed before IGGM calculation.
1. IGGM_one.m file: The corrected long-wave gravity anomaly is calculated.
2. grid.bat file: Using  Generic Mapping Tools (GMT) to deal with long-wave gravity anomalies. The latitude and longitude ranges need to be modified according to the study area
3. IGGM_two.m file: Determine the optimal value of each parameter.
4. IGGM_model.m file: The optimal values are used to calculate the final sounding model. 
5. BLH2XYZ.m and GetGrid.m files are functions that need to be called within the program.
6. Data folder is test data, and the range of test data is 113°E-119°E, 12°N-19°N.

We express our gratitude to the following organizations: NCEI for providing shipborne bathymetric data, GEBCO for offering bathymetric model, SIO for sharing gravity anomaly model and bathymetric model, and the DTU for providing bathymetric model.
All data used in this study are publicly available through the NCEI (https://www.ncei.noaa.gov/maps/bathymetry/), GEBCO (https://www.gebco.net/data_and_products/gridded_bathymetry_data/), SIO (https://topex.ucsd.edu/pub/global_grav_1min/), and DTU (https://ftp.space.dtu.dk/pub/DTU18/1_MIN/). 
codes was build with Matlab version 2022a, and we as tested and run.