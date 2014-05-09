%% The Effect of Masking on Perfectly Periodic Information
% Most materials science information is imperfect; you're allowed to make
% people aware of this.  Spatial Statistics computations make it is to
% remove imperfect data.
% Imperfect data arises from..

%% Load a periodic checkerboard dataset

Data = checkerdata();  % Load a periodic 

%% Create a mask to illustrate

Data.mask = ones(size(Data.phase));
Data.mask( [1 end],: ) = 0; Data.mask( :, [1 end] ) = 0;
Data.mask(:) = imerode( Data.mask, ones(31) );

%% Normal Spatial Statistics

Data.statsunmasked = SpatialStatsFFT( Data.phase );
title('Unmasked Statistics')
Data.image{1} = 'unmasked-stats-checker.png';
saveas( gcf,'./assets/unmasked-stats-checker.png');

%% Masked Spatial Statistics
Data.statsmasked = SpatialStatsFFT( Data.phase, [], 'Mask1',Data.mask );
title('Masked Statistics')
Data.image{2} = 'masked-stats-checker.png';
saveas( gcf,'./assets/masked-stats-checker.png');
%% 
matinpublish( Data, 'title','Checkerboard Statistics')