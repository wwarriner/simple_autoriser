%% determine_feeders by William Warriner, 2018 %%
function [ feeders, stl, mesh ] = determine_feeders( file, element_count )
%% GEOMETRY IMPORT
[ stl.faces, stl.vertices ] = CONVERT_meshformat( READ_stl( file ) );
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
%% WATERSHED SEGMENTATION
filtered_edt( ~mesh.interior ) = -inf;
feeders.segments = watershed( -filtered_edt );
feeders.segments( ~mesh.interior ) = 0;
feeders.count = max( feeders.segments( : ) );
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