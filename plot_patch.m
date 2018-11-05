function plot_patch( axh, fvs, overlay_fv, overlay_color )
%% INPUT HANDLING
if isempty( fvs )
    fvs = {};
end
if ~iscell( fvs )
    fvs = { fvs };
end
if nargin < 3
    overlay_fv = [];
    overlay_color = [ 0.9, 0.9, 0.9 ];
end
count = numel( fvs );

%% COLORS
avoided_colors = [ 0 0 0; overlay_color; 1 1 1 ];
colors = distinguishable_colors( count, avoided_colors );

%% DRAW
for i = 1 : count
    patch( axh, fvs{ i }, 'facecolor', colors( i, : ), 'edgealpha', 0 );
end
if ~isempty( overlay_fv )
    patch( axh, overlay_fv, 'facecolor', overlay_color, 'edgealpha', 0 );
end
setup_axes( axh ); drawnow();
    
end