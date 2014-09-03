       function ret = parse_DIFN_format1(DelayedImageFileName)

        ret = [];

            

                str = strsplit(DelayedImageFileName,' ');                            

                if 1 == numel(str)

                    str1 = strsplit(DelayedImageFileName,' ');                            
                    str2 = char(str1(2));
                    str3 = strsplit(str2,'.');
                        ret.delaystr = num2str(str2num(char(str3(1))));    

                elseif 2 == numel(str)

                     str = strsplit(DelayedImageFileName,' ');                            
                     str1 = char(str(1));     
                     str2 = char(str(2));
                     
                     str3 = strsplit(str2,'.');
                     str4 = char(str3(1));
                     str5 = strsplit(str4,'_');
                        ret.delaystr = num2str(str2num(char(str5(2))));
                                    
                end

           
        end