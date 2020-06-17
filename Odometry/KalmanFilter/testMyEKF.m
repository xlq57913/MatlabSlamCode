function [f,xV,zV] = testMyEKF(Ptrajectory,t_true,timestamps)
    [xV,zV] = EKF(Ptrajectory',timestamps);

    f = plot(Ptrajectory(1,:),Ptrajectory(2,:),'b--',xV(1,:),xV(2,:),'r-',zV(1,:),zV(2,:),'g-.');
    hold on
    plot(t_true(2,:),t_true(1,:),'r','linewidth',2);
    hold off
end