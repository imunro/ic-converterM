function save_as_OMEtiff(folder, outputPath, data, delays)



% replace paths for your own machine
addpath('/Users/imunro/Imperial-FLIMfit/FLIMfitFrontEnd/BFMatlab');



if nargin < 3   % need to generate data from files
    
    
    
    fnames = dir([folder filesep '*.tif'])

    num_files = length(fnames);
    
    
    info = imfinfo([folder filesep fnames(1).name]);
    
    data = uint16(zeros(info.Height, info.Width, 1, 1, num_files));
    delays = zeros(1,num_files);
   
    for f = 1 : num_files   
        filename = fnames(f).name;
        fnamestruct = parse_DIFN_format1(filename);
       
        delays(f) = str2num(fnamestruct.delaystr);

        data(:,:,f)  = imread([folder filesep filename]);            
        
    end
else
    if ~strcmp(class(data),'uint16')
        disp( 'Only uint16 data allowed!');
        return;
    end
end



 tStart = tic; 
 
size(data) 
 

% check for Labview butchering of sign bit 
if min(data(data > 0)) > 32500
    data = data - 32768;    % clear the sign bit which is set by labview
end

% verify that enough memory is allocated
bfCheckJavaMemory();

autoloadBioFormats = 1;

% load the Bio-Formats library into the MATLAB environment
status = bfCheckJavaPath(autoloadBioFormats);
assert(status, ['Missing Bio-Formats library. Either add loci_tools.jar '...
            'to the static Java path or add it to the Matlab path.']);

% initialize logging
loci.common.DebugTools.enableLogging('ERROR');



java.lang.System.setProperty('javax.xml.transform.TransformerFactory', 'com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl');

metadata = createMinimalOMEXMLMetadata(data);

%metadata.setXMLAnnotationID('Annotation:Modulo:0', 0);
%metadata.setXMLAnnotationNamespace('openmicroscopy.org/omero/dimension/modulo', 0);

modlo = loci.formats.CoreMetadata();

modlo.moduloT.type = loci.formats.FormatTools.LIFETIME;
modlo.moduloT.unit = 'ps';
% replace with 'TCSPC' if appropriate
modlo.moduloT.typeDescription = 'Gated';

modlo.moduloT.labels = javaArray('java.lang.String',length(delays));
for i=1:length(delays)
    modlo.moduloT.labels(i)= java.lang.String(num2str(delays(i)));
end



OMEXMLService = loci.formats.services.OMEXMLServiceImpl();

OMEXMLService.addModuloAlong(metadata,modlo,0);

if exist(outputPath, 'file') == 2
    delete(outputPath);
end
bfsave(data, outputPath, 'metadata', metadata);

tElapsed = toc(tStart)


    