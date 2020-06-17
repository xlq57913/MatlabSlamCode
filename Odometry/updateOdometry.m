function P = updateOdometry(Rt,Odometry,picnum)
    P=Rt.R*Odometry(:,picnum)+Rt.t;
end