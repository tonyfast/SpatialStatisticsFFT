%% Sanity Checks
% Explore some simple numeric datasets to prove to ourselves that the code
% is working.

%% Delta Structure
% A delta structure is a sufficient criteria to create a heterogenous
% image.

structure = zeros( 5 );
structure( ceil( numel( structure )/2 ) ) = 1;

[F, xx] = SpatialStatsFFT( structure, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true);

clc;
% Print the iamge
disp( 'Image' )
disp( structure )
% Print the spatial statistics
disp( 'Spatial Statistics' )
disp( [ NaN xx{1};
        xx{2}' F ] )

%% Vertical Structure
% A simple veritical line in the image because we can compute it by hand.

vertical = zeros( 5 );
vertical(:,ceil(size(vertical,2)./2) ) = 1;

[F, xx] = SpatialStatsFFT( vertical, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true);

clc;  
disp( 'Image' )
disp( vertical )
disp( 'Spatial Statistics' )
disp( [ NaN xx{1};
        xx{2}' F ] )

%% Perturbed Vertical Structure
% A simple veritical line in the image because we can compute it by hand.

vertical1 = vertical;
vertical1( 2, : ) = 0;

[Fnp, xx] = SpatialStatsFFT( vertical1, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', false );

[Fp, xx] = SpatialStatsFFT( vertical1, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', true );

clc;
disp( 'Image' )
disp( vertical1 )
disp( 'Spatial Statistics :: Non-Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fnp ] )
disp( '(Special Case) Spatial Statistics :: Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fp ] )


%% Diagonal Structure
% Let's wander over to Flatland.

dgnl = diag( ones(1,5) );% diagonal is a reserved word everywhere in the world.
          
[Fnp, xx] = SpatialStatsFFT( dgnl, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', false );

[Fp, xx] = SpatialStatsFFT( dgnl, [], ... Autocorrelation of the ones ``1``'s in ``structure``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', true );

clc;
disp( 'Image' )
disp( dgnl )
disp( 'Spatial Statistics :: Non-Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fnp ] )
disp( '(Special Case) Spatial Statistics :: Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fp ] )

%% Cross-Correlations!!
% Now we're gonna mix it up, woop woop!

[Fnp, xx] = SpatialStatsFFT( dgnl, vertical1, ... Autocorrelation of the ones ``1``'s in ``dgnl`` + ``vertical1``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', false );

[Fp, xx] = SpatialStatsFFT( dgnl, vertical1, ... Crosscorrelation of the ones ``1``'s in ``dgnl`` + ``vertical1``
                                'display', false, ...
                                'shift', true, ...
                                'periodic', true );
                            
clc;
disp( 'Image :: Head' )
disp( vertical1 )
disp( 'Image :: Tail' )
disp( dgnl )
disp( 'Spatial Statistics :: Non-Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fnp ] )
disp( '(Special Case) Spatial Statistics :: Periodic' )
disp( [ NaN xx{1};
        xx{2}' Fp ] )

%% End Sanity Check
    
