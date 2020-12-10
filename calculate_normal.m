function N = calculate_normal(States, target)
    P_t = States(1:3);
    V_t = States(4:6);
    
    func_Posf_of_N = @ (N) landing_position(N, 2, 9.8, 0.95, V_t, P_t);
    func_XofN = @ (N) (dot(func_Posf_of_N(N), [1 0 0]));
    func_YofN = @ (N) (dot(func_Posf_of_N(N), [0 1 0]));
    
    func_DistofN = @ (N) ((func_XofN(N) - target(1))^2 + (func_YofN(N) - target(2))^2);
    
    search_options = optimset('MaxFunEvals', 1000);
    N = fminsearch(func_DistofN, [0; 0; 1], search_options);
    N = N/norm(N);
end