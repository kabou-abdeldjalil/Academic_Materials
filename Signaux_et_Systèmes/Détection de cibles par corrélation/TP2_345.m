clear all;
close all;
clc
%%
x1 = randn(1,50); %bb
x2 = sin(2*pi*(1:50)*.1); %sin
x3 = sin(2*pi*(1:50)*.1).*exp(-(-24:25).^2/100);%sg
x4 = sin(2*pi*(1:50).^2/100);%chrip

Rxx1b=xcorr(x1,x1,'biased');
Rxx2b=xcorr(x2,x2,'biased');
Rxx3b=xcorr(x3,x3,'biased');
Rxx4b=xcorr(x4,x4,'biased');

Rxx1nb=xcorr(x1,x1,'unbiased');
Rxx2nb=xcorr(x2,x2,'unbiased');
Rxx3nb=xcorr(x3,x3,'unbiased');
Rxx4nb=xcorr(x4,x4,'unbiased');


figure;plot(Rxx1b);hold on;plot(Rxx1nb);grid;
title('Autocorrelation bruit blanc');
legend('biaisé','non biaisé')
figure;plot(Rxx2b);hold on;plot(Rxx2nb);grid
title('Autocorrelation sinusoide');
legend('biaisé','non biaisé')
figure;plot(Rxx3b);hold on;plot(Rxx3nb);grid
title('Autocorrelation sinusoide modulée par une gaussienne');
legend('biaisé','non biaisé')
figure;plot(Rxx4b);hold on;plot(Rxx4nb);grid
title('Autocorrelation chirp');
legend('biaisé','non biaisé')

% théoriquement ,l'autocorrelation du bruit blanc est un diract au 0, dans
% la figure on voit un pique au milieu qui correspond au théorie mais avec
% quelque autre moins important au périfiriques 

% théoriquement ,l'autocorrelation d'un sin est, une autre sina avec une
% fréquence doublé 
%% 3.4.

% Parmi les 4 motifs pr Ì?esent Ì?es ci-dessus, sont ceux qui nous 
% semblent les plus appropri Ì?es pour l utilisation en d Ì?etection de cible
% sont le signal chirp parce le décalage est mesurable parce que la
% fréquence estt variable.

%% 3.4

% l'estimateur biasé est plus approprié parce que suivant le graph il ne
% présente pas l'effet de bords contrairement au celui qui est non biaisé

%% 4. détection des cibles dans le cas non-bruité

% Signal envoyé: sinus
sin15=zeros(1,500);sin15(15:15+length(x2)-1)=x2;
sin120=zeros(1,500);sin120(120:120+length(x2)-1)=x2;
sin136=zeros(1,500);sin136(136:136+length(x2)-1)=x2;
sin379=zeros(1,500);sin379(379:379+length(x2)-1)=x2;
sin400=zeros(1,500);sin400(400:400+length(x2)-1)=x2;

sin=sin15+sin120+sin136+sin379+sin400;

Rx2sinb=xcorr([x2,zeros(1,length(sin)-length(x2))],sin,'biased');
figure,plot(Rx2sinb);
grid;grid minor;
title('Intercorrelation Sinus et signal renvoyé')
xlabel('n');

%% Signal envoyé: Bruit blanc

bb15=zeros(1,500);bb15(15:15+length(x1)-1)=x1;
bb120=zeros(1,500);bb120(120:120+length(x1)-1)=x1;
bb136=zeros(1,500);bb136(136:136+length(x1)-1)=x1;
bb379=zeros(1,500);bb379(379:379+length(x1)-1)=x1;
bb400=zeros(1,500);bb400(400:400+length(x1)-1)=x1;

bb=bb15+bb120+bb136+bb379+bb400;

Rx1bbb=xcorr(bb,[x1,zeros(1,length(bb)-length(x1))],'biased');
figure,plot(Rx1bbb);
title('Intercorrelation bruit blanc et signal renvoyé')
grid;grid minor;
xlabel('n');
%% Signal envoyé : chrip

c15=zeros(1,500);c15(15:15+length(x4)-1)=x4;
c120=zeros(1,500);c120(120:120+length(x4)-1)=x4;
c136=zeros(1,500);c136(136:136+length(x4)-1)=x4;
c379=zeros(1,500);c379(379:379+length(x4)-1)=x4;
c400=zeros(1,500);c400(400:400+length(x4)-1)=x4;

c=c15+c120+c136+c379+c400;

Rx4cb=xcorr(c,[x4,zeros(1,length(c)-length(x4))],'biased');

figure,plot(Rx4cb);
grid;grid minor;
title('Intercorrelation Sinus et signal renvoyé')
xlabel('n');
%%

sg15=zeros(1,500);sg15(15:15+length(x3)-1)=x3;
sg120=zeros(1,500);sg120(120:120+length(x3)-1)=x3;
sg136=zeros(1,500);sg136(136:136+length(x3)-1)=x3;
sg379=zeros(1,500);sg379(379:379+length(x3)-1)=x3;
sg400=zeros(1,500);sg400(400:400+length(x3)-1)=x3;

sg=sg15+sg120+sg136+sg379+sg400;

Rx3sgb=xcorr(c,[x3,zeros(1,length(sg)-length(x3))],'biased');

figure,plot(Rx3sgb);
grid;grid minor;
title('Intercorrelation une sinusoide gaussienne et signal renvoyé')
xlabel('n');
%%
dc=find(Rx4cb(500:end)>0.7*max(Rx4cb))
db=find(Rx1bbb(500:end)>0.7*max(Rx1bbb))

















