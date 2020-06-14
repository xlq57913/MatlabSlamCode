img = imread('./figure/13.jpeg');
[~,~,d] = size(img);
if(d==3)
    gimg = rgb2gray(img);
else
    gimg = img;
end
colormap gray;
[B,F] = ExtractORB(gimg,1000);
imagesc(gimg);
hold on
plot(F(:,2),F(:,1),'r.');