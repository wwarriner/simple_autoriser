function patch_handles = plot_iso( stl, volume_data, levels, scale, origin, m, n, p, color )

if nargin < 6
    color = [ 0.9 0.9 0.9 ];
end
if nargin < 5
    origin = [ 0 0 0 ];
end
if nargin < 4
    scale = 1;
end
if nargin < 3 || isempty( levels )
    if islogical( volume_data )
        levels = 1;
    else
        levels = unique( volume_data );
    end
end

count = length( levels );
patch_handles = cell( count, 1 );
axh = subplot( m, n, p );
cla( axh );
patch( stl, 'facecolor', color, 'edgealpha', 0, 'facealpha', 0.2 );
for i = 1 : count
    
    fv = isosurface( volume_data > levels( i ), 0.5 );
    fv.vertices = fv.vertices * scale + origin;
    patch_handles{ i } = patch( axh, fv, 'facecolor', color, 'edgealpha', 0 );
    
end
axis( axh, 'square', 'equal', 'vis3d', 'off' ); hold( axh, 'on' );
camlight( axh, 'right' );
fprintf('%.2f\n',levels);

end

