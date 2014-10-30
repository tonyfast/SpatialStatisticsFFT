function [ V xx ] = Point2Grid( Data, Lims, Out_SZ );

if ~exist( 'Lims', 'var' ) || numel( Lims ) == 0 
    Lims = [min(Data)',max(Data)'];
end

SUBS = bsxfun( @minus, Data, Lims(:,1)');
SUBS(:) = bsxfun( @rdivide, SUBS, diff(Lims,[],2)');
SUBS(:) = bsxfun( @plus, SUBS, 1./Out_SZ(:)'./2 );
SUBS(:) = round(bsxfun( @times, SUBS, Out_SZ(:)'));

%%
if numel( Out_SZ) == 1
    V = zeros(  [Out_SZ 1]);
else
    V = zeros(  Out_SZ );
end

switch numel(Out_SZ)
    case 1
        V(:) = accumarray( SUBS(:,1), ...
            ones( size(SUBS(:,1))), ...
            [ prod(Out_SZ),1], @sum);
    case 2
        V(:) = accumarray( sub2ind( Out_SZ, SUBS(:,1), SUBS(:,2)), ...
            ones( size(SUBS(:,1))), ...
            [ prod(Out_SZ),1], @sum);
    case 3
        
        V(:) = accumarray( sub2ind( Out_SZ, SUBS(:,1), SUBS(:,2), SUBS(:,3)), ...
            ones(size(SUBS(:,1))), ...
            [ prod(Out_SZ),1], @sum);
end

if nargout == 2
    for ii = 1 : numel( Out_SZ );
        dx = diff(Lims(ii,:))./(Out_SZ);
        xx.values{ii} = (Lims(ii,1) + dx/2):dx:(Lims(ii,2));
    end
end