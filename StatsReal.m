%%

pcstate = @()eval('axis equal; axis tight; shading flat;');

%% Compute Spatial Statistics on Web Resources
% Download the synthetic data from the prior example and compute its stats

url = 'https://farm6.staticflickr.com/5613/15039346854_e228fc7c36_o.jpg'
[ F, xx ] = SpatialStatsFFT( url );
figure(gcf)
saveas( gcf, 'assets/Stats-from-web.png' )


%% Why doesn't this look right?

SpatialStatsFFT(  round(SpatialStatsVar.data./255) == 1 );
figure(gcf)
set( gcf, 'Position', get( 0,'ScreenSize') )

saveas(gcf, 'assets/phase-one-stats.png')

SpatialStatsFFT(  round(SpatialStatsVar.data./255) == 0 );
figure(gcf)
set( gcf, 'Position', get( 0,'ScreenSize') )

saveas(gcf, 'assets/phase-zero-stats.png')
