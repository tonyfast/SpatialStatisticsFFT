%% Plot 3-D volumetric information
% Spatial statistics of 3-D volumetric datasets are challenging to
% visualize.  One of the simplest ways to explore the data is to look at
% slice by slice spatial statistics.
%
% PlotSlice is a function to plot volumetric spatial statistics slices.
% 
% The following code is a tutorial to plotting the statistics
%
% This webpage was generated using the function 
% <https://github.com/tonyfast/SpatialStatisticsFFT/blob/gh-pages/Slice3d.m
% Slice3d>.
%%  Create a synthetic 3-D image

np = 10;% number of pixels in the checker pattern
C = round(checkerboard( np ));
C = C(:,1:(size(C,2)-2*np));
data.phase = repmat(cat(3, repmat( C, [ 1 1 np]), repmat( fliplr(C), [ 1 1 np]) ), [ 1 1 6]);
data.name = '3-D Checkerboard';

disp( sprintf('The size of the dataset is %ix%ix%i.',size(data.phase)));

%% Plot a slice of Shifted Spatial Statistics
% By default, we are computing the nonperiodic spatial statistics on a
% periodic checkerboard structure.

[data.stats xx] = SpatialStatsFFT( data.phase, [],'shift',true,'display',false);

%% Slices to explore
% The third argument for last slice defines the slice of interest.  nan are
% the projections that are being looked at.  Each entry correponds with a
% Matlab matrix dimenion.  The integer value (or non-nan) value indicates
% the slice index to look at in that dimension.
%
% * Slice 1: 0 vector in z slice
% * Slice 2: -10 vector in z slice
% * Slice 3: -1 vector in x slice
% * Slice 4: 12 vector in y slice

slices = [nan nan 0; 
    nan nan -10; 
    -1 nan nan;
    nan 12 nan];

for ii = 1 : size( slices,1)
    subplot(2,2,ii);
    
    % The 3-D slice plotting function
    h = PlotSlice( data.stats,xx,slices(ii,:));    
end

%% Saving image slices as datasets using matinpublish
% Publish dataset pages on the fly.
clf;

saveon = true; %If true then save the slices
imghandle = 'Stats-Tut-Slice-%i.png';

if saveon
    for ii = 1 : size( slices,1)
        h = PlotSlice( data.stats,xx,slices(ii,:));
        saveas( h, sprintf( './assets/%s',sprintf(imghandle, ii ) ) );
        data.image{ii} = sprintf(imghandle, ii );
    end
    
    matinpublish(data,'title','3-D Checkerboard with Slices')
end
close all;