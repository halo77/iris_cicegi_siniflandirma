%input-output-test verileri excel dosyasýndan alýnýr.

input=xlsread('C:\Users\halit\Desktop\ysaYenilerinYenisi\veri_girdi2.xlsx');
output=xlsread('C:\Users\halit\Desktop\ysaYenilerinYenisi\veri_cikti2.xlsx');
test=xlsread('C:\Users\halit\Desktop\ysaYenilerinYenisi\test_girdi2.xlsx');
x=size(input);
ogrenme_ks=0.5;
momentum_ks=0.8;

%gecici agýrlýk güncellemesi

Wgecici(19,1)=0;

%Çanak Uzunluðu(CU),Çanak geniþliði(CG),Tac yaprak Uzunlugu(TU),Tac yaprak genisliði(TG)
%deðerlerden  min ve max deðerleri bulunur.

minCU=min(input(:,1));
maxCU=max(input(:,1));
minCG=min(input(:,2));
maxCG=max(input(:,2));
minTU=min(input(:,3));
maxTU=max(input(:,3));
minTG=min(input(:,4));
maxTG=max(input(:,4));

%%normalizasyon iþlemi

V1=0.8*((input(:,1)-minCU)/(maxCU-minCU))+0.1;
V2=0.8*((input(:,2)-minCG)/(maxCG-minCG))+0.1;
V3=0.8*((input(:,3)-minTU)/(maxTU-minTU))+0.1;
V4=0.8*((input(:,4)-minTG)/(maxTG-minTG))+0.1;

%bias deðerleri
b=rand(3,1);
b2=rand(1);

%%cikis için normalizasyon

minCikis=min(output(:,1));
maxCikis=max(output(:,1));
norm_cikis=0.8*((output(:,1)-minCikis)/(maxCikis-minCikis))+0.1;

%%1 deðer için aðýrlýklarý ayarlama
%%agýrlýk deðerleri rastgele atanýr.

hedef=norm_cikis;
W=rand(4,3);%giriþ ile arakatman
Wgizli_katman=rand(3,1);%%gizli katman ile çýkýþ aðýrlýk deðerleri
Wyenigizli_katman=0;

%%h1=W(1,:)                     % yeni gizli katman ve bu h ler nedir????
%%h2=W(2,:)
%%h3=W(3,:)



while j<15000

for i=1:120

%%E1=V1(:,1)*W(1,1)+V2(:,1)*W(1,2)+V3(:,1)*W(1,3)+V4(:,1)*W(1,4)
%%E=V1(1,1)*W(1,1)+V2(1,1)*W(1,2)+V3(1,1)*W(1,3)+V4(1,1)*W(1,4)
%girdi ve gizli katman aðýrlýklarý input deðerleri ile çarpýlýr

E1=V1(i,1)*W(1,1)+V2(i,1)*W(2,1)+V3(i,1)*W(3,1)+V4(i,1)*W(4,1)+b(1,1);         % ara katmana gelen net girdiler
E2=V1(i,1)*W(1,2)+V2(i,1)*W(2,2)+V3(i,1)*W(3,2)+V4(i,1)*W(4,2)+b(2,1);
E3=V1(i,1)*W(1,3)+V2(i,1)*W(2,3)+V3(i,1)*W(3,3)+V4(i,1)*W(4,3)+b(3,1);


%Sigmoid fonk ile F deðerleri hesaplanýr

Fnet1=1/(1+exp(-E1));
Fnet2=1/(1+exp(-E2));                                                          % ara katmana gelen net cýktýlar
Fnet3=1/(1+exp(-E3));


%Ara katman ile çýktý katmaný arasý sigmoid fonk hesaplanýr

Ecikti=Fnet1*Wgizli_katman(1,1)+Fnet2*Wgizli_katman(2,1)+Fnet3*Wgizli_katman(3,1)+b2;
Fcikti=1/(1+exp(-Ecikti));

%hata payý

error=hedef(i,1)-Fcikti; % formul

%gercek=((Fcikti-0.1)/0.8)*(3-1)+1%%gercek deðerine göre bakmak için

%aðýrlýk güncellemesi

cikti_hata=Fcikti*(1-Fcikti)*error;   % formul

delta_agirlik1=ogrenme_ks*cikti_hata*Fnet1+momentum_ks*Wgecici(13,1);       % formul 19 - 4 TANE BÝAS DEGERÝ. 15 gidilir geriye dogru
delta_agirlik2=ogrenme_ks*cikti_hata*Fnet2+momentum_ks*Wgecici(14,1);
delta_agirlik3=ogrenme_ks*cikti_hata*Fnet3+momentum_ks*Wgecici(15,1);

degisim_bias=ogrenme_ks*cikti_hata*1+momentum_ks*Wgecici(19,1);

Wgecici(13,1)=delta_agirlik1;            % hatadan sonra güncelledik agýrlýklarý ve bias ý
Wgecici(14,1)=delta_agirlik2;
Wgecici(15,1)=delta_agirlik3;
Wgecici(19,1)=degisim_bias;

Wyenigizli_katman(1,1)=Wgizli_katman(1,1)+delta_agirlik1;            %yeni gizli katman ve gizli katman farkýný anla????????
Wyenigizli_katman(2,1)=Wgizli_katman(2,1)+delta_agirlik2;
Wyenigizli_katman(3,1)=Wgizli_katman(3,1)+delta_agirlik3;

Wgizli_katman(:)=Wyenigizli_katman(:);
Wyeni_bias=b2+degisim_bias;
b2=Wyeni_bias;

%giriþ ara katman arasý aðýrlýk deðiþimi

ara_hata1=Fnet1*(1-Fnet1)*cikti_hata*Wgizli_katman(1,1);            %aradaki hata hesabý
ara_hata2=Fnet2*(1-Fnet2)*cikti_hata*Wgizli_katman(2,1);
ara_hata3=Fnet3*(1-Fnet3)*cikti_hata*Wgizli_katman(3,1);

%giris ile ara katman arasý aðýrlýklarýn
 delta_girisagirlik(1,1)=ogrenme_ks*ara_hata1*V1(i,1)+momentum_ks*Wgecici(1,1);      % 12 tane agýrlýk vardý
 delta_girisagirlik(2,1)=ogrenme_ks*ara_hata1*V2(i,1)+momentum_ks*Wgecici(2,1);
 delta_girisagirlik(3,1)=ogrenme_ks*ara_hata1*V3(i,1)+momentum_ks*Wgecici(3,1);
 delta_girisagirlik(4,1)=ogrenme_ks*ara_hata1*V4(i,1)+momentum_ks*Wgecici(4,1);
 
 delta_girisagirlik(5,1)=ogrenme_ks*ara_hata2*V1(i,1)+momentum_ks*Wgecici(5,1);
 delta_girisagirlik(6,1)=ogrenme_ks*ara_hata2*V2(i,1)+momentum_ks*Wgecici(6,1);
 delta_girisagirlik(7,1)=ogrenme_ks*ara_hata2*V3(i,1)+momentum_ks*Wgecici(7,1);
 delta_girisagirlik(8,1)=ogrenme_ks*ara_hata2*V4(i,1)+momentum_ks*Wgecici(8,1);
 
 delta_girisagirlik(9,1)=ogrenme_ks*ara_hata3*V1(i,1)+momentum_ks*Wgecici(9,1);
 delta_girisagirlik(10,1)=ogrenme_ks*ara_hata3*V2(i,1)+momentum_ks*Wgecici(10,1);
 delta_girisagirlik(11,1)=ogrenme_ks*ara_hata3*V3(i,1)+momentum_ks*Wgecici(11,1);
 delta_girisagirlik(12,1)=ogrenme_ks*ara_hata3*V4(i,1)+momentum_ks*Wgecici(12,1);
 
 delta_bias(1,1)=ogrenme_ks*ara_hata1*1+momentum_ks*Wgecici(16,1);                      % 3 tane bias vardý
 delta_bias(2,1)=ogrenme_ks*ara_hata2*1+momentum_ks*Wgecici(17,1);
 delta_bias(3,1)=ogrenme_ks*ara_hata3*1+momentum_ks*Wgecici(18,1);
 
 
 Wgecici(1:12,1)=delta_girisagirlik(:,1);
 
 
Wyeni_girdi(1,1)=W(1,1)+delta_girisagirlik(1,1);
Wyeni_girdi(2,1)=W(2,1)+delta_girisagirlik(2,1);
Wyeni_girdi(3,1)=W(3,1)+delta_girisagirlik(3,1);
Wyeni_girdi(4,1)=W(4,1)+delta_girisagirlik(4,1);


Wyeni_girdi(1,2)=W(1,2)+delta_girisagirlik(5,1);
Wyeni_girdi(2,2)=W(2,2)+delta_girisagirlik(6,1);
Wyeni_girdi(3,2)=W(3,2)+delta_girisagirlik(7,1);
Wyeni_girdi(4,2)=W(4,2)+delta_girisagirlik(8,1);

Wyeni_girdi(1,3)=W(1,3)+delta_girisagirlik(9,1);
Wyeni_girdi(2,3)=W(2,3)+delta_girisagirlik(10,1);
Wyeni_girdi(3,3)=W(3,3)+delta_girisagirlik(11,1);
Wyeni_girdi(4,3)=W(4,3)+delta_girisagirlik(12,1);

Wyeni_bias(1,1)= b(1,1)+delta_bias(1,1);
Wyeni_bias(2,1)= b(2,1)+delta_bias(2,1);
Wyeni_bias(3,1)= b(3,1)+delta_bias(3,1);



W(:)=Wyeni_girdi(:);
b(:)=Wyeni_bias(:);
end

j=j+1;
end
W
Wgizli_katman
b
b2



    