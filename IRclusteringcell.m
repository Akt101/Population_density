clc;
clear all;
I = imread('riot1.jpg');
I_cropped=I;
% I_cropped = I(400:900, 465:965);
% figure
% imshow(I_cropped)

I_eq = adapthisteq(I_cropped,'Numtiles',[20,20],'Distribution','exponential');
figure
imshow(I_eq)

se=strel('disk',20);
tpht = imtophat(I_eq,se);
I_eq=tpht;
figure
imshow(I_eq)

bw = im2bw(I_eq, graythresh(I_eq));
figure
imshow(bw)

bw2 = imfill(bw,'holes');
bw3 = imopen(bw2, ones(3,3));
bw4 = bwareaopen(bw3, 40);
bw4_perim = bwperim(bw4);
figure
imshow(bw4_perim)
overlay1 = imoverlay(I_eq, bw4_perim, [.3 1 .3]);
figure
imshow(overlay1)

mask_em = imextendedmax(I_eq, 35);
figure
imshow(mask_em)

mask_em = imclose(mask_em, ones(8,8));
mask_em = imfill(mask_em, 'holes');
mask_em = bwareaopen(mask_em, 40);
overlay2 = imoverlay(I_eq, bw4_perim | mask_em, [.3 1 .3]);
figure
imshow(overlay2)

I_eq_c = imcomplement(I_eq);

I_mod = imimposemin(I_eq_c, ~bw4 | mask_em);

L = watershed(I_mod);

figure
imshow(histeq(L));

% imwrite (I2, 'pout2.png');
% imwrite (I2, 'pout2.png');
% imwrite (L, 'watershed.png');
% imwrite (histeq(L), 'Final_map.png');