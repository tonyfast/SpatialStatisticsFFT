%% An html view can be found at 
% http://htmlpreview.github.io/?https://github.com/tonyfast/Spatial_Statistics/blob/master/html/example.html

addpath( './Codes' );
addpath( './examples/Data' );

%% Example Dataset
% Read in an Alpha Beta titanium micrograph from Hamish Fraser at OSU.
information = double(imread( 'LowQuality.png'));

%% Encode the information

% the image has been compressed and has artifacts.  black phase is alpha (0)
% and white phase is beta (1).  this information is segmented out in `encoding`

encoding.phase = round( information ./ 255 );
pcolor( encoding.phase  ); colormap gray; shading flat
title(' white - beta-Ti  & black - alpha-Ti ', 'Fontsize', 16 )
snapnow;
%%
% another segmentation could be the grain boundaries

encoding.edge = edge( encoding.phase );
colormap pink
pcolor( 1-encoding.edge  ); shading flat
title(' white - edge  & black - grain ', 'Fontsize', 16 )

%% Compute some statistics
%% autocorrelation of the beta phase 
[ T xx ] = f2( encoding.phase==1, []); 
% [ T xx ] = f2( encoding.phase, encoding.phase, 'display',false); This is
% an autocorrelation too.
pcolor( fftshift(xx.values{2}), fftshift(xx.values{1}), fftshift(T) ); 

%%%%%%%% CHANGE COLORMAP %%%%%%%%%%%%
% I really like to use cbrewer for different colormaps
% http://www.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab
% Go get it or your plots are going to be gross :P
try 
co = cbrewer('div', 'RdYlBu', 26 ); 
catch
    co = jet;
end
colormap( co );

%%%%%%%% COLORMAP %%%%%%%%%%%%

xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = beta )','Fontsize',16);
figure(gcf)

%% crosscorrelation of the beta phase with alpha phase 
[ T xx ] = f2( encoding.phase==1, encoding.phase==0);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = alpha )','Fontsize',16);
figure(gcf)

%%  crosscorrelation of the edges and alpha phase
[ T xx ] = f2( encoding.edge , encoding.phase==0);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = edge, head = alpha )','Fontsize',16);
figure(gcf)

%% Parameters
% The following parameters work for any correlation, but the examples are show on an autcorrelation

%% Turn off the visualization
[ T xx ] = f2( encoding.phase==1, [], 'display', false); 

%% Periodic boundary conditions
[ T xx ] = f2( encoding.phase==1, [], 'periodic', true);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = beta )','Fontsize',16);
figure(gcf)

%% Partial periodic boundary conditions
% nonperiodic in the first dim and the periodic in the second
[ T xx ] = f2( encoding.phase==1, [], 'periodic', [ false true]);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = beta )','Fontsize',16);
figure(gcf)

%% Cutoff all vectors to 50
% BAM! Zoom in on it!
[ T xx ] = f2( encoding.phase==1, [], 'cutoff', 50);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = beta )','Fontsize',16);
figure(gcf)

%% Cutoff 
% Cutoff of the second dimension to 50 and return all of the rest of the
% stats
[ T xx ] = f2( encoding.phase==1, [], 'cutoff', [Inf 50 ]);
xlabel( 't_x','Fontsize',16); ylabel( 't_y','Fontsize',16);
axis equal; shading flat; hc = colorbar; set( get( hc, 'Ylabel'), 'String',...
    'Probability(tail = beta, head = beta )','Fontsize',16);
figure(gcf)




