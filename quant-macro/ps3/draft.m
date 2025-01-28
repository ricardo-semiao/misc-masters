%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solves Mark Hugget's (1993) model with ex-ante identical agents
%
% Preferences: u(c)={c^{1-sigma}-1}{1-sigma}
%
% Agent's problem: v(a,z)=max(u(a+z-qa')+beta*E(v(a',z'))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
%%
% SECTION 1 - DEFINE PARAMETERS AND VARIABLES
% (similar values as in the paper)
% Preferences
beta=0.99322;   % Discount factor
sigma=1.5;      % Relative Risk Aversion
% Idiosyncratic states - productivity
n=2;    % Number of states
z=[1 0.1];  % Value of states - employed and unemployed
pr=[0.925 0.075; 0.5 0.5]; % Transition probability matrix
%
% Discretize the asset space
m=351;  % Number of states in the grid
a_l=-2; % Lower bound for the asset (negative number) {-2, -4, -6, -8}
a_h=2;  % Upper bound for the asset
a=(a_l:((a_h - a_l)/(m-1)):a_h)'; % Equaly spaced
%%
% SECTION 2 - SOLVE THE MODEL
% Guess the asset price (In the deterministic case q=beta).
% But there is precautionary savings in this model and q>beta
%
tol=0.001;     % Tolerance
qh=2;           % Highest value for q 
ql=beta+tol;    % Lowest possible value for q
q=(qh+ql)/2;    % Initial mid-point
security=1;     % Value for the loop
itersec=0;
%
while abs(security)>tol % Loop for the asset market
    itersec=itersec+1
    % Grid for consumption matrices (with vectorization)
    a1     = a;
    %
    c1     = ones(m,1)*(a+z(1))' - q*a1*ones(1,m);
    c2     = ones(m,1)*(a+z(2))' - q*a1*ones(1,m);
    %
    c1(c1<0)=tol;
    c2(c2<0)=tol;
    %
    % Grid for Utility
    U1 = (c1.^(1-sigma)-1)/(1-sigma);
    U2 = (c2.^(1-sigma)-1)/(1-sigma);
    %
    % SECTION 2 - VALUE FUNCTION ITERATIONS
    %
    check  = [1, 1];    % Initializes condition for stopping rule
    iter = 0;           % Initializes number of iterations
    o = ones(1,m);      % Auxiliary vector
    
    V1 = zeros(m,1);    % Initializes value function
    V2 = zeros(m,1);
    
    TV1 = (max(U1 + beta*V1*o))';   % Finds the first step iteration for TV
    TV2 = (max(U2 + beta*V2*o))';
    
    while max(check) > tol
        iter = iter + 1
        V1  = TV1;
        V2  = TV2;
        aux1 = pr(1,1)*V1+pr(1,2)*V2;
        aux2 = pr(2,1)*V1+pr(2,2)*V2;
        TV1 = (max(U1 + beta*aux1*o))';
        TV2 = (max(U2 + beta*aux2*o))';
        check  = [norm(TV1-V1)/norm(V1), norm(TV2-V2)/norm(V2)];
    end
% SECTION 3 - OPTIMAL POLICY FUNCTION
    
    % The following uses the last found V (i.e. V*) to find indeces for policy
    [TV1,j1] = max(U1 + beta*aux1*o);
    [TV2,j2] = max(U2 + beta*aux1*o);
    policy_a  = [a(j1), a(j2)];
    policy_c1=(a+z(1))-q*policy_a(:,1);
    policy_c2=(a+z(2))-q*policy_a(:,2);
    policy_c=[policy_c1, policy_c2];
% SECTION 4 - ENDOGENOUS MARKOV CHAIN
    proba1=zeros(m,m);
    proba2=zeros(m,m);
    
    for i=1:m,
        for j=1:m,
            if j1(i)==j
                proba1(i,j)=1;
            else
                proba1(i,j)=0;
            end
            if j2(i)==j
                proba2(i,j)=1;
            else
                proba2(i,j)=0;
            end
        end
    end
    
    %
    proba=zeros(n*m,n*m);
    for i=1:m,
        for j=1:m,
            proba(i*2-1,2*j-1)=pr(1,1)*proba1(i,j);
            proba(i*2-1,2*j)=pr(1,2)*proba1(i,j);
            proba(i*2,2*j-1)=pr(2,1)*proba2(i,j);
            proba(i*2,2*j)=pr(2,2)*proba2(i,j);
        end
    end
    
    % Unconditional stationary distribution
    maxit=1000;
    % Initial unconditional distribution
    I0=ones(1,n*m)/(n*m);
    
    for i=1:maxit,
        I=I0*proba;
        if norm(I-I0)<tol break
        end
        I0=I;
        int=i;
    end
    if i>=maxit
        sprintf('WARNING: Maximum number of % iterations reached',maxit)
    end
    
    % SECTION 4 - SECURITY MARKETS
    
    %anext=zeros(1,n*m);
    for i=1:m
        anext(i*2-1,1)=policy_a(i,1);
        anext(i*2,1)=policy_a(i,2);
    end
    
    security=I*anext;
    
    %q0(itersec)=q;
    %security0(itersec)=security;
    %end
    
    % Update the price
    if security>0
        ql=q;
    end
    if security<0
        qh=q;
    end
    q=(qh+ql)/2;
    q
    security
    %if itersec>=5 break
    %end

end

%%
% SECTION 3 - CALCULATE STATISTICS
% Annual interest rate
rb=1/q-1;
rag=(1+rb)^6;
ra=rag-1;
% Figure: Asset policy function for low and high states
%
figure(1)
plot(a, policy_a(:,1),'LineWidth',2)
grid
hold on
plot(a, policy_a(:,2), 'k','LineWidth',2)
plot(a, a, '--','LineWidth',2)
title('Optimal policy function', 'FontSize',12,'interpreter','latex')
xlabel('Asset level a','FontSize',12,'interpreter','latex')
ylabel('Asset policy','FontSize',12,'interpreter','latex')
legend('High state', 'Low state', '$45^0$ line','FontSize',12,'interpreter','latex')
hold off
%
% Figure: Stationary cumulative distribution
%
aux=[anext I'];
aux=sortrows(aux,1);
for i=1:m*n,
    cumI(i,1)=sum(aux(1:i,2));
end
figure(2)
plot(aux(:,1),cumI,'LineWidth',2)
grid
xlabel('Asset level a', 'FontSize',12,'interpreter','latex')
ylabel('$\Lambda(a,e)$', 'FontSize',12,'interpreter','latex')
title('Cumulative stationary distribution', 'FontSize',12,'interpreter','latex')
%
%
%

disp('Important results:')

disp('Security price:')
q
disp('Annual net interest rate:')
ra


