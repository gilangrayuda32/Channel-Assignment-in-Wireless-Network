function [G, min2maxG] = channelgainnew(dist, lengthCoorT)
global a dr;
  c = 3*10^8;             % Light Speed
    f = 5*10^9;             % 5 GHz
    l = c / f;
    g =20;                  % saya ubah menjadi ini
    K = 10^(log10(l/(4*3.14*dr)));
    G = g* K * ((dr./dist).^a);
    
    %%---------->> Sum Rate Each pairs <<----------%%%
    zeroCG = G;
    for i=1:lengthCoorT    
        zeroCG(i,i) = 0;
    end
    min2maxG = sort(zeroCG,2);
    min2maxG = exclude(min2maxG,1,'col');  % Menghilangkan 0 pada firs kolom
    
    %%---------->> Sum Rate Each pairs <<----------%%%
%      %%---------->>Menentukan index 5 distence terdekat<<---------------%%
%     urutIte = (neighbor*2);
%     for i=1: length(coorT)
%         for j=1:urutIte
%             [raw2, idxG1(i,j)] = find( G(i,:) == min2maxG(i,j) );
%         end
%     end

end