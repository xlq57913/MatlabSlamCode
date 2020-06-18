function lmk = makeLandMark(GlobalPoint,landmarks)
    [n,~] = size(GlobalPoint);
    Mapkeys = keys(landmarks);
    m = length(Mapkeys);
    lmk = zeros(4,n);
    TOL = 1.2e3;
    num = 0;
    savenum = 0;
    for a = 1:n
        p = GlobalPoint(a,:);
        flag = true;
        for b = 1:m
            key = cell2mat(Mapkeys(b));
            landmark = landmarks(key);
            if(norm(landmark.point-p)<TOL)
                landmark.count = landmark.count + 1;
                landmarks(key) = landmark;
                fprintf('match! \n');
                if(landmark.count > 3)
                    num = num+1;
                    lmk(1:2,num) = p(1:2);
                    lmk(3:4,num) = landmark.point(1:2);
                end
            elseif(norm(landmark.point-p)<TOL*3)
                flag = false;
                break;
            end
            %norm(landmark.point-p)
        end
        if(flag)
            savenum = savenum+1;
            name = sprintf('%d', m+savenum);
            tmp.point = p;
            tmp.count = 0;
            landmarks(name)= tmp;
        end
    end
    if(num==0)
        lmk = [];
    else
        lmk = lmk(:,1:num);
    end
end