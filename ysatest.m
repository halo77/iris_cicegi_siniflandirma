test=xlsread('test_girdi2.xlsx');


minCU=min(test(:,1));
maxCU=max(test(:,1));
minCG=min(test(:,2));
maxCG=max(test(:,2));
minTU=min(test(:,3));
maxTU=max(test(:,3));
minTG=min(test(:,4));
maxTG=max(test(:,4));

V1=0.8*((test(:,1)-minCU)/(maxCU-minCU))+0.1;
V2=0.8*((test(:,2)-minCG)/(maxCG-minCG))+0.1;
V3=0.8*((test(:,3)-minTU)/(maxTU-minTU))+0.1;
V4=0.8*((test(:,4)-minTG)/(maxTG-minTG))+0.1;

for k=1:30
E1=V1(k,1)*W(1,1)+V2(k,1)*W(2,1)+V3(k,1)*W(3,1)+V4(k,1)*W(4,1)+b(1,1);      %net girdi
E2=V1(k,1)*W(1,2)+V2(k,1)*W(2,2)+V3(k,1)*W(3,2)+V4(k,1)*W(4,2)+b(2,1);
E3=V1(k,1)*W(1,3)+V2(k,1)*W(2,3)+V3(k,1)*W(3,3)+V4(k,1)*W(4,3)+b(3,1);


Fnet1=1/(1+exp(-E1));                                                       %sigmoid fonk.
Fnet2=1/(1+exp(-E2));
Fnet3=1/(1+exp(-E3));

Ecikti=Fnet1*Wgizli_katman(1,1)+Fnet2*Wgizli_katman(2,1)+Fnet3*Wgizli_katman(3,1)+b2;        %net cýktý hesabý
Fcikti=1/(1+exp(-Ecikti));

sonucuyaz(k)=Fcikti; % 30 satýr 1 sütun 0-1 arasý degerler
end

for y=1:30
    denormalizehal(y)=((sonucuyaz(y)-0.1)/0.8)*(3-1)+1;                    % denormalize halleri yazdýrdýk 1-2-3 seklinde
end

denormalizehal
sonucuyaz ;                                                                % bunu yazdýrmadýk 0.1  ,  0,5   , 0.9 lu hali bu
                                     
 for k1=1:30
    if(denormalizehal(k1)>0 &&denormalizehal(k1)<1.5 )
         disp('setosa');
     end
     if(denormalizehal(k1)>1.5 &&denormalizehal(k1)<2.5 )
        disp('versicolor');
     end
     if(denormalizehal(k1)>2.5 &&denormalizehal(k1)<3.5 )
         disp('virginia');
     end
     
 end 
%bias deðerleri
