function [ F X meta] = f2( A, B, varargin );
% Computes the spatial correlation functions for input matrices A and B
% if B is empty then an autocorrelation is performed
%
% F = f2( A ); perform the autocorrelation on A and output the vector
% resolved statistics F.
%
% [ F X ] = f2( A ); perform the autocorrelation on A and output the vector
% resolved statistics F and the vectors in voxel vector values on X.
%
% [ F X ] = f2( A, B ); perform the crosscorrelation on A and B and output the vector
% resolved statistics F and the vectors in voxel vector values on X.
% If B is [] then f2 defaults to an autocorrelation.
%
% meta is saved for later
%
% Periodic - a logical vector which is the same number of dimensions as the
% input microstructures.  true indicates a dimension a periodic dimensions
% and false indicates a nonperiodic.  false is the default value.
%
% i.e. f2( A, B, 'Periodic', [ true false false ] );
% A and B are periodic in the 1 direction and nonperiodic in the [2,3]
% dimensions
%
% UnitLength - Normalizes the vectors in the statistics to convert the
% statistics from voxel units to length units.
%
% [ F X ] = f2( A, B, 'UnitLength', val ); the X vector is multiplied by
% val
%
% Integrate - Integrates the statistics over all of the angles of the
% statistics to generate the pair correlation function. default is false
% and returns the vector resolved statistics.  F and X will be vectors
% instead of arrays.
%
% i.e. f2( A, B, 'Integrate', true );
%
% MaskA - A mask for the A input image.  This mask indicates voxels in the
% image that contribute to the statistics and values that out to be
% ignored.  MaskA is a logical array of the same dimensions as the input
% image.  Default is a logical array of all ones.
%
% i.e. f2(A, B, 'MaskA', M ); where M is a logical matrix with all( size( A ) ==
% size( M ) ).
%
% MaskB - Creates a mask for B.  See Mask A.
%
% i.e. f2(A, B, 'MaskA', M1, 'MaskB', M2 ); M1 is a mask for A and M2 is a
% mask for B.  This statement allows heterogenous streams of information to
% be combined.
%
% Truncate - Truncate the vectors to return results shorter than a certain
% distance.
%
% ie. f2( A, B, 'Truncate', 10 ) returns statistics and vectors shorter
% than length 10.

auto_on = true;
if exist( 'B', 'var') && numel( B ) > 0;
    auto_on = false;
end

%% Options for the code
% Compile the metadata provided for the statistics

opt_on = false;
special_mask = false;

if exist( 'varargin', 'var')
    opt_on = true;
    per_arr = [ false false false ]; % false elements imply that the dimension is nonperiodic. {Default}
    integrate_on = false;
    fvector_on = false;
    rmax = [ Inf Inf Inf ];
    forceX = false; if nargout > 1 forceX = true; end
    xfull_on = false;
    xvector_on = false;
    normalize_on = true;
    
    nop = numel( varargin ); % number of option parameters
    if mod( nop, 2 ) ~= 0
        error('There are an unexpected number of option parameters.');
    else % ALLOCATED SPACE FOR THE META DATA and options
        for ii = 1 : 2 : numel( varargin )
            switch varargin{ ii }
                case 'Periodic'
                    per_arr = logical( varargin{ ii + 1} );
                    if numel( per_arr ) == 1
                        % Assume all directions are periodic
                        per_arr = per_arr * ones( 1, ndims(A));
                    end
                    if numel( per_arr ) ~= ndims( A )
                        error( 'Incorrect number of elements in "Periodic" argument.' );
                    end
                case 'MaskA'
                    Mask_A = logical( varargin{ ii + 1 } );
                    A = A .* Mask_A;   % place a mask on the input data, so vectors are not counted
                    special_mask = true;
                case 'MaskB'
                    if ~auto_on
                        Mask_B = logical( varargin{ ii + 1 } );
                        B = B .* Mask_B;
                        special_mask = true;
                    end
                case 'Integrate'
                    integrate_on = logical( varargin{ ii + 1 } );
                    forceX = true;  % Forces the vector to be output.
                case 'Normalize'
                    normalize_on = varargin{ ii + 1 };
                case 'Truncate'
                    rmax = varargin{ ii + 1 };
                    % for internal use.
                case 'FVector'
                    fvector_on = varargin{ ii + 1 };
                case 'XVector'
                    xvector_on = varargin{ ii + 1 };
                    xfull_on = varargin{ ii + 1 };
                case 'XFull'
                    xfull_on = varargin{ ii + 1 };
                otherwise
                    error( horzcat( varargin{ii}, '  is not a recognize keyword in f2np.') );
            end % switch
        end %ii ..
    end % if mod..
end % if exist

ndi = 1 : ndims(A);                 %  dimensionality of the raw data
szo = [ 1 1 1];
szo( 1 : ndims( A ) ) = size( A );  %  size of the original data
szs = szo;                          %  size of the statistics

szs( szs( ndi ) ~= 1 & ~per_arr( ndi ) ) = ...
    szs( szs( ndi ) ~= 1 & ~per_arr( ndi ) ) * 2;

%% Create masks if they are provided

if opt_on && (auto_on & special_mask && ~exist( 'Mask_A', 'var' ) )
    Mask_A = ones( szo );
end

if opt_on && (special_mask && ~exist( 'Mask_B', 'var' ) );
    Mask_B = ones( szo );
end

%%  Perform the correlation functions via Fourier Transform methods based 
%   on different conditions in the microstructure

F = zeros( szs );
F(:) = fft( fft( fft( A, szs(1) , 1), ...
    szs(2), 2), szs(3), 3);
if auto_on   % Wiener khinchin if autocorrelation
    F(:) = abs( F ).^2;
else            % FFT algorithm for correlation function
    fB = zeros( szs );
    fB(:) = fft( fft( fft( B, szs(1) , 1), ...
        szs(2), 2), szs(3), 3);
    F(:) = F .* conj( fB );
end % if auto_on

% Perform the inverse of the fourier transform
F(:) = ifft( F , [], 1);
F(:) = ifft( F , [], 2);
F(:) = ifft( F , [], 3);

% Suppress the imaginary parts if both inputs are real
if ( auto_on & isreal( A ) )  ||  ( ~auto_on & isreal(A) && isreal( B ) )
    F(:) = real( F );
end

%% Centering of the statistics
% There should be a leaner way to compute this.

pre_shift_cntr = F(1);
F(:) = fftshift( F );

if any( ~per_arr ) || opt_on && ( forceX | special_mask );
    % Only extract the vector values if the array statistics are
    % nonperiodic or the vectors are asked for
    cntr_id = find( F == pre_shift_cntr ); % index of the matrix where the <0,0,0> vector is
    if numel( cntr_id )  > 1
        % if there are multiple vectors that are equivalent then choose the
        % one closest to the center of the image.  This is a bit hacky and
        % ought to be fixed.
        [ ~, minv ] = min( abs( cntr_id - prod( szs )./2 ) );
        cntr_id = cntr_id( minv );
    end
    cntr_pos = zeros( 1, 3 );
    [ cntr_pos(1) cntr_pos(2) cntr_pos(3) ] = ...
        ind2sub( szs, cntr_id );     % subscript of the center position
    X = arrayfun( @(x)[ 1: szs(x)] - cntr_pos(x), 1 : 3, 'UniformOutput', false );
    vec_keep = arrayfun( @(x) abs( X{x} ) <= min( rmax(x), szo(x)./2), 1 : 3, 'UniformOutput', false );
    F = F( vec_keep{1}, vec_keep{2}, vec_keep{3}, : );
    X = cellfun( @(x,y)x( y ), X, vec_keep, 'UniformOutput', false );
end

%%

if all( per_arr ) & ( opt_on &&  ~special_mask )
    D = numel( A );
elseif ~special_mask
    D = zeros( cellfun( @sum, vec_keep ) );
    D(:) = bsxfun( @times, bsxfun( @times, permute( szo(2) - abs( X{2} ), [ 1 2 3] ), ...
        szo(1) - permute( abs( X{1} ), [ 2 1 3] ) ), ...
        szo(3) - permute( abs( X{3} ), [ 1 3 2] ) );
elseif special_mask
    D = fft( fft( fft( Mask_A, szs(1), 1 ), szs(2), 2 ), szs(3), 3 );
    if auto_on
        D(:) = abs( D ).^2;
    else
        Db = fft( fft( fft( Mask_A, szs(1), 1 ), szs(2), 2 ), szs(3), 3 );
        D(:) = D .* conj( Db );
    end
    D(:) = ifft( D,[],1);
    D(:) = ifft( D,[],2);
    D(:) = real( ifft( D,[],3) );
    
    % For some reason, the normalizations need to be forced to line up.
    % vvvvvvvvvvvvvvvvv
    cntr_pos_norm = zeros( 1, 3 );
    [ cntr_pos_norm(1) cntr_pos_norm(2) cntr_pos_norm(3) ] = ...
        ind2sub( szs, find( D == max(D(:)) ) );     % subscript of the center position
    D(:) = circshift( D, [ cntr_pos - cntr_pos_norm] );
    % ^^^^^^^^^^^^^^^^^^
    
    D = D( vec_keep{1}, vec_keep{2}, vec_keep{3} );
end

if normalize_on
F(:) = bsxfun( @rdivide, F, D );
end

% Output options
if opt_on && fvector_on
    F = F(:);
end
if opt_on && xfull_on
    X2 = X;
    X = zeros( [ cellfun( @numel, X ) 3] );
    [X(:,:,:,1), X(:,:,:,2), X(:,:,:,3) ] = ndgrid( X2{1}, X2{2}, X2{3} );
    if xvector_on
      X = reshape( X, numel(X)./3,3);
    end
end

if opt_on && integrate_on
    D = sqrt( bsxfun( @plus, bsxfun( @plus, permute( abs( X{2} ).^2, [ 1 2 3] ), ...
        permute( abs( X{1} ).^2, [ 2 1 3] ) ), ...
        permute( abs( X{3} ).^2, [ 1 3 2] ) ) );
    
    X = 0 : ceil( max( D(:) ) );
    [~, D(:)] = histc( D, X );
    sd = sum( D(:)~=0 );
    F = accumarray( D(D(:)~=0), F( D(:)~=0), [ numel(X), 1], @mean);
end