function [k1,k2,k3,kd]=violent_matchFor4(d1,d2,d3)
    [n,~]=size(d1);
    t=max([min(min(d1)),min(min(d2)),min(min(d3))]);
    if(t==0)
        t=1;
    end
    if(t<4)
        t = 10*t;
    else
        t = 6*t;
    end
    k = -1*ones(n,4);
    for i=1:n
        dist1=max(min(d1(i,:)),min(d2(i,:)));
        if dist1<t
            [~,b1] = min(d1(i,:));
            [~,b2] = min(d2(i,:));
            [dist2,b3] = min(d3(b2,:));
            if(dist2<t)
                k(i,1)=b1;
                k(i,2)=b2;
                k(i,3)=b3;
                k(i,4)=max(dist1,dist2);
            end
        end
    end
    k1 = k(:,1);
    k2 = k(:,2);
    k3 = k(:,3);
    kd = k(:,4);
    