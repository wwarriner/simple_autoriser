function plot_iso( volume_data, level, mesh, overlay_fv, axh )
%% NOTE TO USER
anh = annotation( ...
    'textbox', [ 0.7 0.75 0 0 ], ...
    'string', 'Updating...', ...
    'linestyle', 'none', ...
    'backgroundcolor', [ 1 1 1 ], ...
    'fitboxtotext', 'on' );
drawnow();

%% STORE CAMERA
cp = axh.CameraPosition;
ct = axh.CameraTarget;
cv = axh.CameraViewAngle;
cu = axh.CameraUpVector;

%% DRAW
cla( axh, 'reset' );
LIGHT_GRAY = [ 0.9 0.9 0.9 ];
ORANGE = [ 1 0.65 0 ];    
fv = isosurface( volume_data > level, 0.5 );
if ~isempty( fv.vertices )
    fv.vertices = fv.vertices * mesh.scale + mesh.origin;
    patch( axh, fv, 'facecolor', ORANGE, 'edgealpha', 0 );
end
patch( axh, overlay_fv, 'facecolor', LIGHT_GRAY, 'edgealpha', 0, 'facealpha', 0.2 );
axis( axh, 'square', 'equal', 'vis3d', 'off' ); hold( axh, 'on' );

%% RESTORE CAMERA
axh.CameraPosition = cp;
axh.CameraTarget = ct;
axh.CameraViewAngle = cv;
axh.CameraUpVector = cu;
camlight( axh, 'right' );

%% TEARDOWN
delete( anh );
drawnow();

end