%% Spatial Sampling Types for Materials Science Information
% A lot of materials science information is sampled in both space and time
% on a uniform grid.  Information such as microscope images and 3-D
% volumetric images generated from micro-CT are evenly gridded.  Other
% datasets will be lumped into the category of point cloud data.

%% Gridded Volume Metric Data

%% Other classes of Materials Data
% Some data sources have a total disregard for uniformity and are willy
% nilly about their place in space.  These datasets are called 
% <http://en.wikipedia.org/wiki/Point_cloud point cloud datasets>
% There are experimental techniques in
% materials science such as 
% <http://en.wikipedia.org/wiki/Atom_probe Atom Probe Microscopy> 
% (Fig. APM). In silico data sources with often maintain periodic boundary conditions at least in one direction.
% It is critical to record the upper and lower bounds of the periodic boundary conditions 
% to compute spatial statistics on point cloud data.  (Please see the discussion on
% periodic versus non-periodic boundary conditions for more information)

%%
% <html>
% <figure>
% <img
% src="http://upload.wikimedia.org/wikipedia/commons/6/6b/Atomprobe_00_as-prepared_Cu-NiFe-W01.jpg"></img>
% <figcaption>Atom Probe Microscopy Data. Each colored point in the data cloud indicates a particular species of molecule</figcaption>
% </figure>
% </html>


%% A Polymer Molecular Dynamics Simulation
% Each point in the image below is a carbon atom in a long polymer chain.
% The color of each point indicates its relatives in the polymer chain.
% There are periodic boundary conditions in each direction.  The limits of
% each boundary are annotated on the plot.

% polymer = Polymerstuff;

%%
% <html>
% <figure>
% <img
% src="polyer-chain-location.png"></img>
% <figcaption>Atom Probe Microscopy Data. Each colored point in the data cloud indicates a particular species of molecule</figcaption>
% </figure>
% </html>

%% Materials Features
% The materials features contained in the APM and Polymer datasets are
% feature identifiers.  They are discrete indices that can be represented
% using color, basis function, or different sizes styrofoam balls.

%%
%