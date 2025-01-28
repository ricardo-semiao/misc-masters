%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------
clear all;
close all;
clc;

%----------------------------------------------------------------
% 1. Adicionar o Caminho do Dynare
%----------------------------------------------------------------
addpath('C:\dynare\6.2\matlab');

%----------------------------------------------------------------
% 2. Definir o Diretório do Modelo
%----------------------------------------------------------------
cd('C:\Users\Eco\Desktop\Monetary Policy\Trabalho Final\NK_ET14');



pkg load optim

%----------------------------------------------------------------
% 3. Função para Executar o Modelo e Calcular a Função de Perda
%----------------------------------------------------------------
function loss = run_dynare_and_compute_loss(params)
    gampi = params(1);
    gamY = params(2);

    % Modifica o arquivo .mod dinamicamente
    mod_file = 'NK_ET14_rep2.mod';
    replace_parameters_in_mod_file(mod_file, mod_file, gampi, gamY);

    % Executa o Dynare
    try
        dynare NK_ET14_rep2_temp.mod noclearall;
    catch ME
        disp('Erro ao rodar o modelo no Dynare.');
        disp(getReport(ME));
        loss = 1e6; % Penalidade alta se o modelo falhar
        return;
    end

    % Verifica se as variâncias estão disponíveis
    global oo_ M_;
    if ~exist('M_', 'var') || isempty(M_)
        disp('Erro: M_ não está definido.');
        loss = 1e6;
        return;
    end

    % Calcula a função de perda
    omega_Pi = 0.7;
    omega_Y = 0.3;
    try
        variance_Pi = oo_.var(strmatch('Pi', M_.endo_names, 'exact'), strmatch('Pi', M_.endo_names, 'exact'));
        variance_Y = oo_.var(strmatch('Y', M_.endo_names, 'exact'), strmatch('Y', M_.endo_names, 'exact'));
        loss = omega_Pi * variance_Pi + omega_Y * variance_Y;
    catch ME
        disp('Erro ao acessar as variâncias:');
        disp(getReport(ME));
        loss = 1e6;
    end
end


%----------------------------------------------------------------
% 4. Função para Substituir Parâmetros no Arquivo .mod com UTF-8
%----------------------------------------------------------------
function replace_parameters_in_mod_file(original_file, mod_file, gampi, gamY)
    % Lê o arquivo original com codificação UTF-8
    fid = fopen(original_file, 'r', 'n', 'UTF-8');
    if fid == -1
        error('Erro ao abrir o arquivo .mod.');
    end
    content = fread(fid, '*char')';
    fclose(fid);

    % Substitui os parâmetros
    content = regexprep(content, 'gampi = .*?;', sprintf('gampi = %.4f;', gampi));
    content = regexprep(content, 'gamY = .*?;', sprintf('gamY = %.4f;', gamY));

    % Salva em um novo arquivo temporário com codificação UTF-8
    fid = fopen(mod_file, 'w', 'n', 'UTF-8');
    if fid == -1
        error('Erro ao salvar o arquivo temporário .mod.');
    end
    fwrite(fid, content, 'char');
    fclose(fid);
end

%----------------------------------------------------------------
% 5. Optimize Taylor Rule Parameters
%----------------------------------------------------------------
initial_guess = [1.48, 2.22]; % Initial values for γΠ and γY
lb = [1.0, 0.0];          % Lower bounds for γΠ and γY
ub = [6.0, 6.0];          % Upper bounds for γΠ and γY

options = optimset('Display', 'iter', 'TolFun', 1e-4, 'MaxIter', 50);

% Optimize with constraints
[optimal_params, optimal_loss] = fmincon(@run_dynare_and_compute_loss, initial_guess, [], [], [], [], lb, ub, [], options);

% Display Results
disp('Optimized Parameters:');
disp(['γΠ = ', num2str(optimal_params(1))]);
disp(['γY = ', num2str(optimal_params(2))]);
disp(['Minimum Loss Function: ', num2str(optimal_loss)]);

%----------------------------------------------------------------
% 6. Cleanup
%----------------------------------------------------------------
delete('NK_ET14_rep2_temp.mod');
