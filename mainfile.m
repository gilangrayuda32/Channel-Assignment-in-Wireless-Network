% This is a simple code to investigate the impact of channel allocation 
% on throughgput performance.

% This code was made by Gilang Raka Rayuda Dewa (gil@snut.ac.kr)
% You can correspond by email for discussion and collaboration.

% If you use this code for learning and etc., please kindly cite my work
% https://ieeexplore.ieee.org/document/9515972

% Thank you.

clear 
clc
clear all
global a dr Zn neighbor Npair;

%%---------------------initialization---------------------%%%
PndB = (-50:5:20);              % in dB 
a = 3.7;                        % Path loss Exponent 
dr = 1;                         % Refrence of Distance in meter 
Z= -100;                        % Noise power in dBm
BW = 15*10^3;                   % Hz
C = 900;                        % Sub Carrier Spacing    

%%---------------------Convert unit---------------------%%%
Pn = 10.^(PndB./10);            % Convert Power transmission from dB to mW
Zn = (10^(Z/10));               % Noise power from dB to mW
orthoChan = [1:1:3];            % Number of Channel (You can change the max channel)

%%---------------------Generate N AP-STA Pairs---------------------%%%
Npair = 50;                      % Create N AP-STA Pairs
Npairref = Npair;
neighbor =5;
[num,txt,raw] = xlsread('dataiot','data');
coorT = num(:,1:2);
coorR = num(:,3:4);

for Chan = 1:length(orthoChan);
for j = 1 : length(PndB)
%% Input CoorT and CoorR
    lengthCoorT = length(coorT);
    [dist, min2maxdist, idxDist] = distance(coorT, coorR);

    %%---------------------Calculate Gain Channel---------------------%%%
    [G, min2maxG] = channelgainnew(dist, lengthCoorT); % Calculate Indoor Fading Channel

        NumInit = 1;      
            for i = 1:orthoChan(Chan)
                        NumIdx = round(((i/orthoChan(Chan))*Npair));
                        ChannelChosen{i} = transpose(NumInit:NumIdx);
                        NumInit= NumIdx + 1;
            end
end 


 %% Update Channel Gain for Conflicting Node in same Channel
          memberCh = zeros(length(ChannelChosen),Npairref);
            for iter = 1:length(ChannelChosen)
                memberCh(iter,ChannelChosen{iter}) = 1;
            end
        
                for g = 1:orthoChan(Chan)
                    indexchan = ChannelChosen{g};
                    for n = 1:length(indexchan)
                         for nc = 1:length(indexchan)
                                G1{g}(n,nc) = G(indexchan(n),indexchan(nc));
                         end  
                    end   
                end   
        
              Gnol = G1;
          for r = 1:length(ChannelChosen)
              for kl = 1:length(ChannelChosen{r})
                Gnol{r}(kl,kl) = 0;
              end
          end

   
    
  %% Assign Power to Calculate Throughput
    
    for z=1: length(Pn)
         % Calculate Sum Rate in each Channel When Power transmission is Pn
        for i=1:length(ChannelChosen)
            indexPairingCh = zeros(1,length(ChannelChosen{i}));
            indexPairingCh = find(memberCh(i,:) == 1);
            for j=1:length(indexPairingCh)
                SINRn_each_Ch = (G(indexPairingCh(1,j),indexPairingCh(1,j)) * Pn(z)) ./ ((( sum(Gnol{i}(:,j))) * Pn(z)) + Zn);     
                   RnCh(j) = log2(1  + SINRn_each_Ch);
            end %
            Rch(i) = sum(RnCh);
        end  
              R(z,Chan) = sum(Rch);
        Rch = 0;
        RnCh = 0;
    end 
end 

%%%----------Plot Graph Transmit Power vs Throughput-------------%%%
    figure (1) 
    hold on;
        for xx = 1:length(orthoChan)
            h = plot(PndB,R(:,xx),'LineWidth',2);
            title('Power Transmission vs Sum Rate ');
            xlabel('Power Transmission [dBm]');
            ylabel('Sum Rate [bps/Hz]');
            str=compose('Number of Channels = %0.2f', orthoChan)
            legend(str');
        end


% %---------------------Plot Graph in Area---------------------%%% 
figure;
hold on
axis([0 100 0 100])
plot(coorT(:,1),coorT(:,2),'o'); % Plot transmitter
plot(coorR(:,1),coorR(:,2),'x'); % Plot Reciever

%Line plot
for i=1:Npair
    plot([coorT(i,1) coorR(i,1)],[coorT(i,2) coorR(i,2)]);
end

title('Node distribution');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off
hold off


% %%---------------------Plot Graph in Channel 1---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 1
for n=1:length(ChannelChosen{i})
    plot(coorT(ChannelChosen{i}(n),1),coorT(ChannelChosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChosen{i}(n),1),coorR(ChannelChosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChosen{i})
    plot([coorT(ChannelChosen{i}(n),1) coorR(ChannelChosen{i}(n),1)],[coorT(ChannelChosen{i}(n),2) coorR(ChannelChosen{i}(n),2)]);
end

title('Node distribution in Channel 1');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off

%---------------------Plot Graph in Channel 2---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 2
for n=1:length(ChannelChosen{2})
    plot(coorT(ChannelChosen{i}(n),1),coorT(ChannelChosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChosen{i}(n),1),coorR(ChannelChosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChosen{i})
    plot([coorT(ChannelChosen{i}(n),1) coorR(ChannelChosen{i}(n),1)],[coorT(ChannelChosen{i}(n),2) coorR(ChannelChosen{i}(n),2)]);
end

title('Node Distribution in Channel 2');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off

%---------------------Plot Graph in Channel 3---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 3
for n=1:length(ChannelChosen{i})
    plot(coorT(ChannelChosen{i}(n),1),coorT(ChannelChosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChosen{i}(n),1),coorR(ChannelChosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChosen{i})
    plot([coorT(ChannelChosen{i}(n),1) coorR(ChannelChosen{i}(n),1)],[coorT(ChannelChosen{i}(n),2) coorR(ChannelChosen{i}(n),2)]);
end

title('Node distribution in Channel 3');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off
