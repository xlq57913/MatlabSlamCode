function [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPicture(picnum,num)
    if(num == 1)
        Image1_l=imread(sprintf('LeftCamera/data/%010d.png',picnum-1));
        Image1_r=imread(sprintf('RightCamera/data/%010d.png',picnum-1));
        Image2_l=imread(sprintf('LeftCamera/data/%010d.png',picnum));
        Image2_r=imread(sprintf('RightCamera/data/%010d.png',picnum));
    elseif(num == 2)
        Image1_l=imread(sprintf('LeftCamera/data2/%010d.png',picnum-1));
        Image1_r=imread(sprintf('RightCamera/data2/%010d.png',picnum-1));
        Image2_l=imread(sprintf('LeftCamera/data2/%010d.png',picnum));
        Image2_r=imread(sprintf('RightCamera/data2/%010d.png',picnum));
    else
        Image1_l=imread(sprintf('LeftCamera/data3/%010d.png',picnum-1));
        Image1_r=imread(sprintf('RightCamera/data3/%010d.png',picnum-1));
        Image2_l=imread(sprintf('LeftCamera/data3/%010d.png',picnum));
        Image2_r=imread(sprintf('RightCamera/data3/%010d.png',picnum));
    end
end

