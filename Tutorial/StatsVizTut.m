%% 

pcstate = @()eval('axis equal; axis tight; shading flat;');

%% On to some visuals.

lamallae = repmat( [ ones(1,5), zeros(1,5)] , 40,4 )';

[ F, xx ] = SpatialStatsFFT( lamallae, [], ...
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );
clc;
subplot(1,2,1);
pcolor( lamallae ); pcstate()
subplot(1,2,2);
pcolor( xx{2}, xx{1}, F ); pcstate()
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
figure( gcf );


saveas( gcf, 'assets/lam-and-stat.png' );
%% Checkerboard

check = cast( [ lamallae + lamallae' ] == 1, 'double' );

[ F, xx ] = SpatialStatsFFT( check, [], ...
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );

clf;
subplot(1,2,1);
pcolor( check ); pcstate()
subplot(1,2,2);
surface( xx{2}, xx{1}, F ); 
shading flat;
view( 3 );
daspect( [ 1 1 1/50] )
grid on
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)

figure( gcf );


saveas( gcf, 'assets/check-and-stat.png' );
%% Smoother

checkbig = round( imresize( check, 4 ) );

[ F, xx ] = SpatialStatsFFT( checkbig, [], ...
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );

clf;
subplot(1,2,1);
pcolor( checkbig ); pcstate()
subplot(1,2,2);
surface( xx{2}, xx{1}, F ); 
shading flat;
view( 3 );
daspect( [ 1 1 1/50] )
grid on
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
figure( gcf );

saveas( gcf, 'assets/smoothcheck-and-stat.png' );

%% A non-periodic structure

newstructure = RandomStructure( 100 );
clc
pcolor( newstructure )
figure(gcf)
imwrite( newstructure, 'assets/RandomStructure.jpg')

[ Fp, xxp ] = SpatialStatsFFT( newstructure, [], ...
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', true );
[ Fnp, xx ] = SpatialStatsFFT( newstructure, [], ...
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );
                             
subplot(1,2,1)

pcolor( xxp{2}, xxp{1}, Fp ); pcstate()
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Periodic Statistics', 'Fontsize', 16 )

subplot(1,2,2)

pcolor( xx{2}, xx{1}, Fnp ); pcstate()
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Non-Periodic Statistics', 'Fontsize', 16 )

saveas( gcf, 'assets/np-synthetic-stats.png' );

%% Synthetic Structure for Cross-Correlations

synth = round( imread( 'Tutorial/data/RandomStructure.jpg' )./ 255 );

[ Fp, xxp ] = SpatialStatsFFT( synth == 1, synth == 0, ... %Cross Correlation
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', true );
[ Fnp, xx ] = SpatialStatsFFT( synth == 1, synth == 0, ... %Cross Correlation
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );

subplot(1,2,1)

pcolor( xxp{2}, xxp{1}, Fp ); pcstate()
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Periodic Statistics', 'Fontsize', 16 )

subplot(1,2,2)

pcolor( xx{2}, xx{1}, Fnp ); pcstate()
hc = colorbar;
set( get( hc, 'YLabel' ), 'String', 'Probability', ...
                          'Rotation', 270, ...
                          'Fontsize', 16, ...
                          'VerticalAlignment', 'bottom');
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Non-Periodic Statistics', 'Fontsize', 16 )
figure(gcf)

saveas( gcf, 'assets/cross-synthetic-stats.png' );

%% The Effect of Shifting

[ Fs, xxs ] = SpatialStatsFFT( synth == 1, synth == 0, ... %Cross Correlation
                                 'display', false, ...
                                 'shift', true, ...
                                 'periodic', false );

                             
[ F, xx ] = SpatialStatsFFT( synth == 1, synth == 0, ... %Cross Correlation
                                 'display', false, ...
                                 'shift', false, ...
                                 'periodic', false );
                             
subplot(1,2,1)

pcolor( xxs{2}, xxs{1}, Fs ); pcstate()
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Shifted', 'Fontsize', 16 )

subplot(1,2,2)                           
pcolor(F); pcstate();
% Rename the axes 
set( gca, 'XTickLabel', xx{2}(get( gca,'XTick')), 'Fontsize',16 );
set( gca, 'YTickLabel', xx{1}(get( gca,'YTick')), 'Fontsize',16 );
% Rename END
xlabel('t_x','Fontsize',16)
ylabel('t_y','Fontsize',16)
title( 'Un-shifted', 'Fontsize', 16 )
figure(gcf)
set( gcf, 'Position', get( 0,'ScreenSize') )

saveas( gcf, 'assets/cross-shift.png' );