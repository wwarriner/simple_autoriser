%% determine_feeders by William Warriner, 2018 %%
%function [ feeders, stl, mesh ] = determine_feeders( file, element_count )
%% SETUP
lightgray = [ 0.9 0.9 0.9 ];
avoided_colors = [ 0 0 0; lightgray; 1 1 1 ];
colors = distinguishable_colors( feeders.count, avoided_colors );
fh = figure( 'color', 'w', 'position', [ 10 10 800 700 ] );
%% GEOMETRY IMPORT
[ stl.faces, stl.vertices ] = CONVERT_meshformat( READ_stl( file ) );
geo_ax = subplot( 2, 2, 1 );
patch( stl, 'facecolor', lightgray, 'edgealpha', 0 );
axis( geo_ax, 'square', 'equal', 'vis3d', 'off' ); hold( geo_ax, 'on' );
camlight( 'right' );
%% VOXELIZATION
mesh.origin = min( stl.vertices );
mesh.lengths = max( stl.vertices ) - mesh.origin;
mesh.scale = ( prod( mesh.lengths ) / element_count ) ^ ( 1 / 3 );
shape = ceil( mesh.lengths / mesh.scale );
mesh.interior = VOXELISE( shape( 1 ), shape( 2 ), shape( 3 ), stl );
mesh.interior = padarray( mesh.interior, [ 1 1 1 ], 'both' );
mesh.shape = size( mesh.interior );
%% DISTANCE FIELD BASED SOLIDIFICATION ORDER FIELD
mesh.surface = mesh.interior & ...
    ~imerode( mesh.interior, conndef( 3, 'minimal' ) );
feeders.edt = mesh.scale .* bwdistsc( mesh.surface | ~mesh.interior );
%% FILTERING
max_edt = max( feeders.edt( : ) );
normalized_edt = feeders.edt ./ max_edt;
TOLERANCE = 1e-4;
height = ( 1 + TOLERANCE ) / max_edt;
filtered_edt = max_edt .* imhmax( normalized_edt, height );
edt_ax = subplot( 2, 2, 2 );
np = permute( normalized_edt, [ 2 1 3 ] );
level = 0.5;
plot_iso( stl, np, level, mesh.scale, mesh.origin, 2, 2, 2, lightgray );
b = uicontrol('Parent',fh,'Style','slider','Position',[450,350,300,23],...
              'value', level, 'min',0, 'max',1);
bgcolor = fh.Color;
bl3 = uicontrol('Parent',fh,'Style','text','Position',[550,320,100,23],...
                'String','EDT Level','BackgroundColor',bgcolor);
b.Callback = @(es,ed)plot_iso( stl, np, es.Value, mesh.scale, mesh.origin, 2, 2, 2, lightgray );
% stuff here
%% WATERSHED SEGMENTATION
filtered_edt( ~mesh.interior ) = -inf;
feeders.segments = watershed( -filtered_edt );
feeders.segments( ~mesh.interior ) = 0;
feeders.count = max( feeders.segments( : ) );
ws_ax = subplot( 2, 2, 3 );
p = permute( feeders.segments, [ 2 1 3 ] );
for i = 1 : feeders.count
    fv = isosurface( p == i, 0.5 );
    fv.vertices = fv.vertices * mesh.scale + mesh.origin;
    patch( fv, 'facecolor', colors( i, : ), 'edgealpha', 0 );
end
axis( ws_ax, 'square', 'equal', 'vis3d', 'off' ); hold( ws_ax, 'on' );
camlight( 'right' );
%% DETERMINE SEGMENT INFORMATION
largest_edt = zeros( feeders.count, 1 );
largest_edt_index = zeros( feeders.count, 1 );
for i = 1 : feeders.count
    segment_edt = feeders.edt;
    segment_edt( feeders.segments ~= i ) = 0;
    [ largest_edt( i ), largest_edt_index( i ) ] = max( segment_edt( : ) );
end
segment_volumes = zeros( feeders.count, 1 );
shape_factors = zeros( feeders.count, 1 );
for i = 1 : feeders.count
    segment_mask = mesh.interior;
    segment_mask( feeders.segments ~= i ) = 0;
    segment_volumes( i ) = ( mesh.scale ^ 3 ) * sum( segment_mask( : ) );
    dilated_segment_mask = imdilate( segment_mask, conndef( 3, 'maximal' ) );
    distance = bwdistgeodesic( ...
        dilated_segment_mask, ...
        largest_edt_index( i ), ...
        'quasi-euclidean' ...
        );
    segment_boundary = dilated_segment_mask & ~segment_mask;
    values = mesh.scale .* distance( segment_boundary );
    L = max( values( : ) );
    W = median( values( : ) );
    T = 2 .* largest_edt( i );
    shape_factors( i ) = ( L + W ) / T;
end
%% GENERATE FEEDER GEOMETRIES
[ edt_x, edt_y, edt_z ] = ind2sub( mesh.shape, largest_edt_index );
feeders.position = ( mesh.scale .* [ edt_x edt_y edt_z ] ) + mesh.origin;
feeders.volume = 2.51 .* segment_volumes .* ( shape_factors .^ -0.74 );
feeders.radius = ( feeders.volume / ( 3 .* pi ) ) .^ ( 1 / 3 );
feeders.height = 3 .* feeders.radius + largest_edt;
feeders.fvs = cell( feeders.count, 1 );
for i = 1 : feeders.count
    fv = capped_cylinder( feeders.radius( i ), feeders.height( i ), 60, 'triangles' );
    fv.vertices = fv.vertices + feeders.position( i, : );
    feeders.fvs{ i } = fv;
end
feed_ax = subplot( 2, 2, 4 );
patch( stl, 'facecolor', lightgray, 'edgealpha', 0 );
for i = 1 : feeders.count    
    ph = patch( feeders.fvs{ i }, 'facecolor', colors( i, : ), 'edgealpha', 0 );
end
axis( feed_ax, 'square', 'equal', 'vis3d', 'off' ); hold( feed_ax, 'on' );
camlight( 'right' );

geo_ax.CameraViewAngleMode = 'manual';
Link = linkprop( [ geo_ax, edt_ax, ws_ax, feed_ax ], ...
   { 'CameraUpVector', 'CameraPosition', 'CameraTarget', 'CameraViewAngle', 'CameraViewAngleMode' } );
setappdata( fh, 'camera_link', Link );
view( 3 );
camzoom( 0.8 );
zoom( geo_ax, 'off' );