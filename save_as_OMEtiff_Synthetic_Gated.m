function save_as_OMEtiff_Synthetic_Gated(ometiffname)


% replace paths for your own machine
addpath('/Users/imunro/FLIMfit/FLIMfitFrontEnd/BFMatlab');



nbins = 3;       % No of time bins/gates

% synthetic data 
% dimensions here are (x, y , Z, C(hannels) nbins )
data = uint16(ones(2, 2, 1, 1, nbins)) .* 200;

if nbins < 12
   delays = 0:1000:(nbins-1)* 1000;
else
   delays = 0:(nbins -1);
end
   
data(:,:,1,1,1) = uint16(400);
data(:,:,1,1,2) = uint16(1000);
data(:,:,1,1,3) = uint16(700);
%data(:,:,1,1,6) = uint16(300);
%data(:,:,1,1,7) = uint16(250);
%data(:,:,1,1,8) = uint16(210);
   
size(data)


 tStart = tic; 
 
% verify that enough memory is allocated
bfCheckJavaMemory();

autoloadBioFormats = 1;

% load the Bio-Formats library into the MATLAB environment
status = bfCheckJavaPath(autoloadBioFormats);
assert(status, ['Missing Bio-Formats library. Either add loci_tools.jar '...
            'to the static Java path or add it to the Matlab path.']);

% initialize logging
loci.common.DebugTools.enableLogging('ERROR');



outputPath = [pwd filesep ometiffname];

java.lang.System.setProperty('javax.xml.transform.TransformerFactory', 'com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl');

metadata = createMinimalOMEXMLMetadata(data);


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


    