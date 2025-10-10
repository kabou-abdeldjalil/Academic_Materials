clear all;
close all;
clc

%%
x1 = randn(1,50); %bb
x2 = sin(2*pi*(1:50)*.1); %sin
x3 = sin(2*pi*(1:50)*.1).*exp(-(-24:25).^2/100);
x4 = sin(2*pi*(1:50).^2/100);

Rxx1b=xcorr(x1,x1,'biased');
Rxx2b=xcorr(x2,x2,'biased');
Rxx3b=xcorr(x3,x3,'biased');
Rxx4b=xcorr(x4,x4,'biased');

Rxx1nb=xcorr(x1,x1,'unbiased');
Rxx2nb=xcorr(x2,x2,'unbiased');
Rxx3nb=xcorr(x3,x3,'unbiased');
Rxx4nb=xcorr(x4,x4,'unbiased');


bruit25=randn(500,1)*0.25;
bruit5=randn(500,1)*0.5;
bruit1=randn(500,1)*1;

%% 4.1

sin15=zeros(1,500);sin15(15:15+length(x2)-1)=x2;
sin120=zeros(1,500);sin120(120:120+length(x2)-1)=x2;
sin136=zeros(1,500);sin136(136:136+length(x2)-1)=x2;
sin379=zeros(1,500);sin379(379:379+length(x2)-1)=x2;
sin400=zeros(1,500);sin400(400:400+length(x2)-1)=x2;
sin379(501:end)=[];
sin400(501:end)=[];

sin=sin15+sin120+sin136+sin379+sin400;

Rx2sinb=xcorr([x2,zeros(1,length(sin)-length(x2))],sin,'biased');
figure,plot(Rx2sinb);
grid;grid minor;title('Sinus | Bruit 0.25');xlabel('n');

%%

bb15=zeros(1,500);bb15(15:15+length(x1)-1)=x1;
bb120=zeros(1,500);bb120(120:120+length(x1)-1)=x1;
bb136=zeros(1,500);bb136(136:136+length(x1)-1)=x1;
bb379=zeros(1,500);bb379(379:379+length(x1)-1)=x1;
bb400=zeros(1,500);bb400(400:400+length(x1)-1)=x1;


bb=bb15+bb120+bb136+bb379+bb400+bruit5';

Rx2bbb=xcorr(bb,[x1,zeros(1,length(bb)-length(x1))],'biased');
figure,plot(Rx2bbb);
grid;grid minor;title('Bruit Blanc | Bruit 0.5');xlabel('n');

%%

c15=zeros(1,500);c15(15:15+length(x4)-1)=x4;
c120=zeros(1,500);c120(120:120+length(x4)-1)=x4;
c136=zeros(1,500);c136(136:136+length(x4)-1)=x4;
c379=zeros(1,500);c379(379:379+length(x4)-1)=x4;
c400=zeros(1,500);c400(400:400+length(x4)-1)=x4;


c=c15+c120+c136+c379+c400+bruit5';

Rx2cb=xcorr(c,[x4,zeros(1,length(c)-length(x4))],'biased');

figure,plot(Rx2cb);
grid;grid minor;title('Chirp | Bruit 0.5');xlabel('n');
%%
dc=find(Rx2cb(500:end)>(0.7*max(Rx2cb)))
db=find(Rx2bbb(500:end)>(0.7*max(Rx2bbb)))

%%


















