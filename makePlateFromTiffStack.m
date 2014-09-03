function [list]  = makePlateFromTiffStack( requiredString )
%makePlateFromTiffStack Creates a single ome-tiff for each image a dir
%
%   platepath should point to the top-level dir
%   any dir whose name contains requiredString will be included


list = dir(['*' requiredString '*']);

mkdir('ome');

for d = 1:length(list)
    subdir = list(d);
    if subdir.isdir
        name = subdir.name;
         path = [pwd filesep name]
         
         %spl = strsplit(name,' ');
         %fname = [spl{:}]
         fname = [pwd filesep 'ome' filesep name];
         filename = [fname '.ome.tiff'];

         save_as_OMEtiff(path, filename);
        
    end
    
    
 

end

