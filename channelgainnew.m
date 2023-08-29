function [G, min2maxG] = channelgainnew(dist, lengthCoorT)
global a dr;

%% Indoor Fading Channel
    c = 3*10^8;             % Light Speed
    f = 5*10^9;             % 5 GHz
    l = c / f;
    InitGain =20;             
    K = 10^(log10(l/(4*3.14*dr)));
    G = InitGain* K * ((dr./dist).^a);
    

%% Note: The subsequent codes are utilized for extended simulation, which is neglected for this simulation.
    %%---------->> Sum Rate Each pairs <<----------%%%
    zeroCG = G;
    for i=1:lengthCoorT    
        zeroCG(i,i) = 0;
    end
    min2maxG = sort(zeroCG,2);
    min2maxG = exclude(min2maxG,1,'col');  % Menghilangkan 0 pada firs kolom
    
%%---------->> Sum Rate Each pairs <<----------%%
%      %%---------->>Finding 5 nearest nerighbor<<---------------%%
%     urutIte = (neighbor*2);
%     for i=1: length(coorT)
%         for j=1:urutIte
%             [raw2, idxG1(i,j)] = find( G(i,:) == min2maxG(i,j) );
%         end
%     end

end
