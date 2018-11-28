function stlwrite_example( feeders, input_file )
%% FILE MANAGEMENT
[ path, base_name, ~ ] = fileparts( input_file );
%% WRITING
for i = 1 : feeders.count    
    name = sprintf( '%s_feeder_%i.stl', base_name, i );
    outfile = fullfile( path, name );
    stlwrite( outfile, feeders.fvs{ i } );    
end