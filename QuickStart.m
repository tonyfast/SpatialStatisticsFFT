%% Quick Start
% A quick matlab snippet of code to test the SpatialStatsFFT function with
% sample data.
%
% In the SpatialStatisticsFFT root directory execute the following command.
% run( 'QuickStart.m' );

template_location = fullfile('.','examples','Data','Example.png');
template.phase = double( round( imread( template_location )./255 ) );

%% Compute and plot the Spatial Statistics 
% Spatial statistics automatically plots the statistics by default.
% A visualization of the spatial statistics on the Titanium micrograph in
% the default template will be shown.
%
% After computing the statsistics I like to maintain a conventional that
% the output variable is a field in a Matlab structure.  This maintains a
% loose connection between the variable fields while you are interactively
% coding.
%
template.stats = SpatialStatsFFT( template.phase, [],'display', true );

%%%
% The second Null argument automatically computes the Autocorrelation.
