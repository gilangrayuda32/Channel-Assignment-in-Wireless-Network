function [dist, min2maxdist, idxDist1] = distance(coorT, coorR)
global neighbor;
    indexX = 1;     % Index untuk transmitter
    indexY = 2;     % Index untuk Receiver
    
    for c = 1:length(coorT)
        % Calculate distance beetween two coordinate
        for z=1:length(coorT)
             dist(c,z) = sqrt((coorR(c,indexX)-coorT(z,indexX))^2+ (coorR(c,indexY)-coorT(z,indexY))^2); 
        end 
    end
    
    zerodist = dist;
    for i=1:length(coorT)
        zerodist(i,i) = 0;
    end
    min2maxdist = sort(zerodist,2);             % Sudah diurutkan
    min2maxdist = exclude(min2maxdist,1,'col');  % Menghilangkan 0 pada firs kolom
    
    %%---------->>Menentukan index 5 distence terdekat<<---------------%%
    urutIte = (neighbor*2);
    for i=1: length(coorT)
        for j=1:urutIte
            [raw1, idxDist1(i,j)] = find( dist(i,:) == min2maxdist(i,j) );
        end
    end

end