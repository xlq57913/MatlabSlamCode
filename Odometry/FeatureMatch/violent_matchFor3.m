function [k1,k2]=violent_matchFor3(d1,d2)
    [n,~]=size(d1);
    t=max(min(min(d1)),min(min(d2)));
    if(t==0)
        t=1;
    end
    if(t<4)
        t = 6*t;
    else
        t = 4*t;
    end
    k1=-1*ones(n,1);
    k2=-1*ones(n,1);
    for i=1:n
        dist=max(min(d1(i,:)),min(d2(i,:)));
        if dist<t
            [~,b1] = min(d1(i,:));
            [~,b2] = min(d2(i,:));
            k1(i)=b1;
            k2(i)=b2;
        end
    end
end