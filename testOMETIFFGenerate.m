function  testOMETIFFGenerate(  )

% replace path to BFMatlab Toolbox  for your own machine
%addpath('/Users/imunro/FLIMfit/FLIMfitFrontEnd/BFMatlab');

% verify that enough memory is allocated
bfCheckJavaMemory();

autoloadBioFormats = 1;

% load the Bio-Formats library into the MATLAB environment
status = bfCheckJavaPath(autoloadBioFormats);
assert(status, ['Missing Bio-Formats library. Either add loci_tools.jar '...
            'to the static Java path or add it to the Matlab path.']);

% initialize logging
loci.common.DebugTools.enableLogging('ERROR');


% this section just generates synthetic data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 sizeT = 3
 sizeZ = 2;
            
 sizeY = 3;
 sizeX = 5;
 
% actual sizet (FLIM relative time)
sizet = 3;
 

data = int16(zeros(sizeX,sizeY,1,1,sizet));


for t = 1:sizet
    ii = 100 - (10 * t);
    
    % 0
    z = 1;
    data(:,:,z,1,t) = ii;
    data(2:4,2,z,1,t) = 0;
   
    %1
    z = 2;
    data(1:5,2,z,1,t) = ii;
    
    %2
    z = 3;
    data(3:5,1,z,1,t) = ii;
    data(1,1,z,1,t) = ii;
    data(1:3,3,z,1,t) = ii;
    data(5,3,z,1,t) = ii;
    data(1:2:5,2,z,1,t) = ii;
    
     %3
    z = 4;
    data(:,:,z,1,t) = ii;
    data(2,1:2,z,1,t) = 0;
    data(4,1:2,z,1,t) = 0;
    
    
     %4
    z = 5;
    data(1,1:2:3,z,1,t) = ii;
    data(2,:,z,1,t) = ii;
    data(3,3,z,1,t) = ii;
    data(4,3,z,1,t) = ii;
    data(5,3,z,1,t) = ii;
    
end

data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% NB this line has been found to be crucial
java.lang.System.setProperty('javax.xml.transform.TransformerFactory', 'com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl');

metadata = createMinimalOMEXMLMetadata(data);


modlo = loci.formats.CoreMetadata();

modlo.moduloT.type = loci.formats.FormatTools.LIFETIME;
modlo.moduloT.unit = 'ps';
% replace with 'Gated' if appropriate
modlo.moduloT.typeDescription = 'TCSPC';
modlo.moduloT.start = 0;

%
step = 1000;
modlo.moduloT.step = step;
modlo.moduloT.end = (sizet -1) * step;


OMEXMLService = loci.formats.services.OMEXMLServiceImpl();

OMEXMLService.addModuloAlong(metadata,modlo,0);

% important to delete old versions before writing.
outputPath = [pwd  filesep 'synthetic.ome.tiff']
if exist(outputPath, 'file') == 2
    delete(outputPath);
end
bfsave(data, outputPath, 'metadata', metadata);






end

