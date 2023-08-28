clear 
clc
clear all
global a dr Zn neighbor Npair;

%%---------------------initialisasi---------------------%%%
PndB = (-50:5:20);              % in dB 
a = 3.7;                        % Path loss Exponent 
dr = 1;                         % Refrence of Distance in meter 
Z= -100;                        % Noise power in dBm
BW = 15*10^3;                   % Hz
C = 900;                        % Sub Carrier Spacing    

%%---------------------Convert unit---------------------%%%
Pn = 10.^(PndB./10);            % Convert Power transmission form dB to mW
Zn = (10^(Z/10));               % Noise power from dB to mW
orthoChan = [1:1:3];

%%---------------------Generate N AP-STA Pairs---------------------%%%
Npair = 50;                      % Craet N AP-STA Pairs
Npairref = Npair;
neighbor =5;
% [coorT, coorR] = coordinate(Npair);
[num,txt,raw] = xlsread('dataiot','data');
coorT = num(:,1:2);
coorR = num(:,3:4);

for Chan = 1:length(orthoChan);
for j = 1 : length(PndB)
%% Input CoorT and CoorR
    lengthCoorT = length(coorT);
    [dist, min2maxdist, idxDist] = distance(coorT, coorR);

    %%---------------------Calculate Gain Channel---------------------%%%
    [G, min2maxG] = channelgainnew(dist, lengthCoorT); % Calculate Gain Channel
    Garsip =G;
        NumInit = 1;      
            for i = 1:orthoChan(Chan)
                        NumIdx = round(((i/orthoChan(Chan))*Npair));
                        ChannelChoosen{i} = transpose(NumInit:NumIdx);
                        NumInit= NumIdx + 1;
            end
end 


 %% Assign Power


  memberCh = zeros(length(ChannelChoosen),Npairref);
    for iter = 1:length(ChannelChoosen)
        memberCh(iter,ChannelChoosen{iter}) = 1;
    end

        for g = 1:orthoChan(Chan)
            indexchan = ChannelChoosen{g};
            for n = 1:length(indexchan)
                 for nc = 1:length(indexchan)
                        G1{g}(n,nc) = Garsip(indexchan(n),indexchan(nc));
                 end  
            end   
        end   

      Gnol = G1;
  for r = 1:length(ChannelChoosen)
      for kl = 1:length(ChannelChoosen{r})
        Gnol{r}(kl,kl) = 0;
      end
  end

   
    
  Powern = 10.^(PndB./10);            % Convert Power transmission form dB to mW
    
    for z=1: length(Powern)
         % Calculate Sum Rate in each Channel When Power transmission is Pn
        for i=1:length(ChannelChoosen)
            indexPairingCh = zeros(1,length(ChannelChoosen{i}));
            indexPairingCh = find(memberCh(i,:) == 1);
            for j=1:length(indexPairingCh)
                SINRn_each_Ch = (Garsip(indexPairingCh(1,j),indexPairingCh(1,j)) * Powern(z)) ./ ((( sum(Gnol{i}(:,j))) * Powern(z)) + Zn);     
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
            str=compose('Channel = %0.2f', orthoChan)
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
hold off


% %%---------------------Plot Graph in Channel 1---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 1
for n=1:length(ChannelChoosen{i})
    plot(coorT(ChannelChoosen{i}(n),1),coorT(ChannelChoosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChoosen{i}(n),1),coorR(ChannelChoosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChoosen{i})
    plot([coorT(ChannelChoosen{i}(n),1) coorR(ChannelChoosen{i}(n),1)],[coorT(ChannelChoosen{i}(n),2) coorR(ChannelChoosen{i}(n),2)]);
end

title('Proposed Algorithm, Channel=1, Assignment Nodes =13');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off

%---------------------Plot Graph in Channel 2---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 2
for n=1:length(ChannelChoosen{2})
    plot(coorT(ChannelChoosen{i}(n),1),coorT(ChannelChoosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChoosen{i}(n),1),coorR(ChannelChoosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChoosen{i})
    plot([coorT(ChannelChoosen{i}(n),1) coorR(ChannelChoosen{i}(n),1)],[coorT(ChannelChoosen{i}(n),2) coorR(ChannelChoosen{i}(n),2)]);
end

title('Proposed Algorithm, Channel=2, Assignment Nodes =13');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off

%---------------------Plot Graph in Channel 3---------------------%%% 
figure;
hold on
axis([0 100 0 100])
for i = 3
for n=1:length(ChannelChoosen{i})
    plot(coorT(ChannelChoosen{i}(n),1),coorT(ChannelChoosen{i}(n),2),'o'); % Plot transmitter
    plot(coorR(ChannelChoosen{i}(n),1),coorR(ChannelChoosen{i}(n),2),'x'); % Plot Reciever
end
end

%Line plot
for n=1:length(ChannelChoosen{i})
    plot([coorT(ChannelChoosen{i}(n),1) coorR(ChannelChoosen{i}(n),1)],[coorT(ChannelChoosen{i}(n),2) coorR(ChannelChoosen{i}(n),2)]);
end

title('Proposed Algorithm, Channel=3, Assignment Nodes =13');
xlabel('X Position [m]');
ylabel('Y Position [m]');
hold off