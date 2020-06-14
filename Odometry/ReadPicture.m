function [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPicture(picnum)
if picnum<=9
    Image1_l=imread(sprintf('LeftCamera/data/000000000%d.png',picnum-1));
    Image1_r=imread(sprintf('RightCamera/data/000000000%d.png',picnum-1));
    Image2_l=imread(sprintf('LeftCamera/data/000000000%d.png',picnum));
    Image2_r=imread(sprintf('RightCamera/data/000000000%d.png',picnum));
elseif picnum==10
    Image1_l=imread(sprintf('LeftCamera/data/0000000009.png'));
    Image1_r=imread(sprintf('RightCamera/data/0000000009.png'));
    Image2_l=imread(sprintf('LeftCamera/data/0000000010.png'));
    Image2_r=imread(sprintf('RightCamera/data/0000000010.png'));
elseif picnum<=99
    Image1_l=imread(sprintf('LeftCamera/data/00000000%d.png',picnum-1));
    Image1_r=imread(sprintf('RightCamera/data/00000000%d.png',picnum-1));
    Image2_l=imread(sprintf('LeftCamera/data/00000000%d.png',picnum));
    Image2_r=imread(sprintf('RightCamera/data/00000000%d.png',picnum));
elseif picnum==100
    Image1_l=imread(sprintf('LeftCamera/data/0000000099.png'));
    Image1_r=imread(sprintf('RightCamera/data/0000000099.png'));
    Image2_l=imread(sprintf('LeftCamera/data/0000000100.png'));
    Image2_r=imread(sprintf('RightCamera/data/0000000100.png'));
else
    Image1_l=imread(sprintf('LeftCamera/data/0000000%d.png',picnum-1));
    Image1_r=imread(sprintf('RightCamera/data/0000000%d.png',picnum-1));
    Image2_l=imread(sprintf('LeftCamera/data/0000000%d.png',picnum));
    Image2_r=imread(sprintf('RightCamera/data/0000000%d.png',picnum));
end
end

