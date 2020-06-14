function d=hamming(B1,B2)
% d(i,j):hamming distance between
% the ith feature point of picture1(B1)
% and the jth of p2(B2);
[m1,~]=size(B1);
[m2,~]=size(B2);
% [~,~]=size(B1);
d=zeros(m1,m2);
% hamming distance
% for i=1:m1
%     for j=1:m2
%         count=0;
%         for k=1:n
%             if(B1(i,k)~=B2(j,k))
%                 count=count+1;
%             end
%         end
%         d(i,j)=count;
%     end
% end
for i=1:m1
   for j=1:m2
       d(i,j)=sum(abs((B1(i,:)-B2(j,:))));
   end
end
