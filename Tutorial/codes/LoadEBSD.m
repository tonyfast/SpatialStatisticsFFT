%  function  LoadEBSD( );

    filnm = 'Large grain AZ31, Step 0 area 1.txt'
    
    fo = fopen( filnm );
    
    % Skip file headers
    headerlines = 10;
    for ii = 1 : headerlines fgetl( fo ); end
    
    % Encode Data
    tmp = fscanf( fo, '%f %f %f %f %f %f %f %f %i %*i %*s \n', [9 Inf] )';
    
    data = struct( 'phi1', tmp(:,1), ...
                   'PHI', tmp(:,2), ...
                   'phi2', tmp(:,3), ...
                   'x', tmp(:,4), ...
                   'y', tmp(:,5), ...
                   'ImageQuality', tmp(:,6), ...
                   'ConfidenceIndex', tmp(:,7), ...
                   'Fit', tmp(:,8), ...
                   'GrainIndex', tmp(:,9) );
                   
                   
    
    fclose( fo );
    
    
    % Unique grid points from the experiment
    [ xx, yy] = deal( unique( single( data.x ) ), ...
                      unique( single( data.y ) ) );
    
    % New image size 
    nsz = [ numel( xx ) numel( yy ) ];
    
    % Normalize the sampling positions to indices
    [~, rix ] = ismember( data.x, xx );
    [~, riy  ] = ismember( data.y, yy );
    
    data.('sz') = nsz;
    data.('id') = sub2ind( nsz, rix, riy );
    
    
    fld = 'GrainIndex'
    Map = zeros( data.sz ); 
    Map( data.('id') ) = getfield( data, fld );
    
    
    
    
%  end
 
    
    
    
   