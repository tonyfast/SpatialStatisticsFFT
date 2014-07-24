function [Stats, Apart, Bpart ] = partition_stats( A, B, varargin )
% ``varargin`` takes in hybridized arguments from SpatialStatsFFT &
% partition_space.
% ``partitition_space`` has an argument called ``window`` that is
% supplanted by the ``cutoff`` value in SpatialStatistics

if ~exist( 'B','var')
    B = [];
end


% Create a default
partition_space_keys = {'center';'corner'};
hybrid_keys = {'cutoff'};

if exist( 'varargin', 'var' ) && ~isempty( varargin )
    ref_id = find( cellfun( ...
                    @(x)ismember( x, partition_space_keys ), ...
                    {varargin{1:2:end}} ) );

    if ~isempty( ref_id ) ref_id = ref_id * 2 - 1; end
    
    hyb_id = find( cellfun( ...
                    @(x)ismember( x, hybrid_keys ), ...
                    {varargin{1:2:end}} ) );
    
    if ~isempty( hyb_id ) hyb_id = hyb_id * 2 - 1; end
else
    varargin = {'corner', ceil(size(A)./2), 'cutoff', [ 101, 101, 101] };
    [ref_id, hyb_id] = deal( 1, 3 );
end

if ~isempty( hyb_id )
    switch varargin{ref_id}
        case 'center'
            w = [-1*varargin{hyb_id +1}, varargin{hyb_id +1}];
        case 'corner'
            w = [ 2.*varargin{hyb_id+1}]+1;
    end
else
    
end

            
Apart = partition_space( A, ...
                        varargin{ref_id}, varargin{ref_id+1},... 
                        'window', w );

if ~isempty(B)
    Bpart = partition_space( B, ...
                            varargin{ref_id}, varargin{ref_id+1},...
                            'window', w );
elseif iscell( Apart )
    Bpart = cell( size(Apart ) );
else
    Bpart = [];
end

%% Compute spatial statistics 
% Ignore arguments specifically for partitioning space.

varargin( ref_id + [0:1] ) = [];
varargin{ end +1 } = 'display'; varargin{ end + 1} = false;
if iscell( Apart )
    Stats = cellfun( @(a,b)SpatialStatsFFT( a, b, varargin{:} ), Apart, Bpart, 'UniformOutput',false );
else
    Stats = SpatialStatsFFT( Apart, Bpart , varargin{:} );
end

