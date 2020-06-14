function [A,b]=compute_A_and_b_Gauss_Newton(current_betas,rho,L)

A=zeros(6,4);
b=zeros(6,1);

cb=current_betas;

B=[cb(1)*cb(1),
   cb(1)*cb(2),
   cb(2)*cb(2),
   cb(1)*cb(3),
   cb(2)*cb(3),
   cb(3)*cb(3),
   cb(1)*cb(4),
   cb(2)*cb(4),
   cb(3)*cb(4),
   cb(4)*cb(4)];

for i=1:6
    A(i,1)=2*cb(1)*L(i,1)+cb(2)*L(i,2)+cb(3)*L(i,4)+cb(4)*L(i,7);
    A(i,2)=cb(1)*L(i,2)+2*cb(2)*L(i,3)+cb(3)*L(i,5)+cb(4)*L(i,8);
    A(i,3)=cb(1)*L(i,4)+cb(2)*L(i,5)+2*cb(3)*L(i,6)+cb(4)*L(i,9);
    A(i,4)=cb(1)*L(i,7)+cb(2)*L(i,8)+cb(3)*L(i,9)+2*cb(4)*L(i,10);
        
    b(i)=(rho(i)-L(i,:)*B);    
end 
end



    

