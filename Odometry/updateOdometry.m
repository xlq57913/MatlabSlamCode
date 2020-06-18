function [O,P] = updateOdometry(Rt,Odometry,Trajectory,picnum)
    P = zeros(3,1);
    for j = picnum:-1:1
        P=Rt(j).R*P+Rt(j).t;
    end
    O = Odometry(:,picnum) + P-Trajectory(:,picnum);
end