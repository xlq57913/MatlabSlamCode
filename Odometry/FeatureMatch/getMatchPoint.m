function k = getMatchPoint(p,d)
    n = length(p);
    k=-1*ones(n,1);
    for i = 1:n
        if(p(i)==-1)
            continue;
        end
        [~,b]=min(d(p(i),:));
        k(p(i)) = b;
    end

end