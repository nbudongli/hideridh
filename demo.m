%% ====== This is a demo for hiding the embedding traces left by PEE-HS based RIDH ====
%% For any problems, please feel free to contact Li Dong at dongli@nbu.edu.cn

clc;clear;
close all;
% ==== load image ===
% I = double(imread('lena.png'));
I = double(imread('peppers.png'));
% I = double(imread('baboon.png'));

ER = 0.3; % bits per pixel (bpp)
[M,N] = size(I);
range = -20:19;

% === original JS-div value ====
[ptemphist_org, jsdist_og] = PEHypthosis( I, range , 'Original prediction error histogram');


% ==== generate data (random bitstream) ===
paysize = floor(M*N*ER);
payload = randi([0,1],paysize,1);

% ==== data embedding ===
[ markImg, headerInfo ] = embed( I, payload );

my_psnr = psnr(I, double(markImg),255);
my_ssim = ssim(I, double(markImg));

% === JS-div value ====
[ ptemphist, jsdist] = PEHypthosis( double(markImg), range , 'Prediction error histogram after embedding');

figure;imshow(I,[]);title('Original image');
figure;imshow(markImg);title(strcat('Embedded image: ',num2str(my_psnr),' dB/ ',num2str(my_ssim)));

% === data extraction and image recovery ====
[ recI, dataextracted] = recover( markImg, headerInfo );
% === test the reversiblity, both min(testdata(:)) and min(testimg(:)) shall be 1 ===
testdata = uint8(payload == dataextracted);
testimg = uint8(I == recI);