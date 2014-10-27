%% Normalizing Statistics by the phase on the tail
%
% The current Spatial Statistics routine computes the probability of
% finding two states separated by a vector of a specified distance over the
% entire sample.  It is important to consider the case where the state at
% the tail is known and one wants to find the probability of finding a
% phase at a distance away if the phase is known.
%
% The mask option in the Spatial Statistics makes this problem really easy
% to address.
%% Load sample image

Data{1}.phase = imread( './SpatialStatisticsFFT/examples/Data/Example.png');
%%
% Normalize raw image
Data{1}.phase(:) = round(Data{1}.phase./255);

%% Masking the Phase map
% We are going to compute the probability of a black phase (0) arising at a
% vector distance from a phase that is known to be black (0);

Data{2}.title = ['The Original Statistics as computed without the mask.  No '...
    'prior knowledge of the system is made.'];
[ Data{2}.original_stats xx]= SpatialStatsFFT( Data{1}.phase == 0, ... % tail of the vector
                                          Data{1}.phase == 0, ... % head of the vector
                                          'shift',true,...
                                          'cutoff', 30);
                         
% Data{2}.image                                      
                                      
Data{3}.title = ['The Original Statistics as computed without the mask.  No '...
    'prior knowledge of the system is made.'];

[ Data{3}.biased_stats xx]= SpatialStatsFFT( Data{1}.phase == 0, ... % tail of the vector
                                          Data{1}.phase == 0, ... % head of the vector
                                          'shift',true,...
                                          'cutoff', 30,...
                                          'Mask1',Data{1}.phase==0,...
                                          'Mask2',ones( size( Data{1}.phase)) );
