function [xV,zV] = EKF(vs,ts)
    N = length(vs);
    n = 6;
    q = 0.2;
    r = 0.1;
    Q = q^2*eye(n);
    R = r^2;
    TOL = 1;
    dh = seconds(ts(N)-ts(1))/(N-1);
    f = @(x) [x(1)+x(3)*dh;x(2)+x(4)*dh;x(3)+x(5)*dh;x(4)+x(6)*dh;x(5);x(6)];
    h = @(x) [x(1);x(2)];
    J = [1 0 dh 0 0 0; 0 1 0 dh 0 0; 0 0 1 0 dh 0; 0 0 0 1 0 dh; 0 0 0 0 1 0; 0 0 0 0 0 1];
    H = [1 0 0 0 0 0; 0 1 0 0 0 0];

    x = [0;0;0;0;0;0];
    P = eye(n);
    xV = zeros(n,N);
    zV = zeros(2,N);

    for k = 1:N
        if(k == 1)
            z = [vs(k,1);vs(k,2)];
        else
            z = [vs(k,1)-vs(k-1,1)+x(1);vs(k,2)-vs(k-1,2)+x(2)];
            % z = [vs(k,1);vs(k,2);(vs(k,1)-vs(k-1,1))/dt;(vs(k,2)-vs(k-1,2))/dt];
        end
        zV(:,k) = z;

        % [x1,A] = jaccsd(f,x);
        x1 = f(x);
        P = J*P*J' + Q;

        % [z1,H] = jaccsd(h,x1);
        z1 = h(x1);

        K = P*H'*inv(H*P*H'+R);
        x = x1+K*(z-z1);
        P = P-K*H*P;

        if(norm(x(5:6))>TOL)
            x(5:6) = TOL/norm(x(5:6)) * x(5:6);
        end

        xV(:,k) = x;
    end

end

