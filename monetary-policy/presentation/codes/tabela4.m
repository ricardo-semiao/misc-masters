%----------------------------------------------------------------
% tabela4.m - Executa 21 simulações combinando 3 conjuntos de
% parâmetros com 7 combinações de choques
%----------------------------------------------------------------
% Script para executar simulações Dynare com diferentes conjuntos de
% parâmetros e combinações de choques, calculando a função de perda e variâncias.
%----------------------------------------------------------------

%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------
clear all;        % Limpa todas as variáveis do workspace
close all;        % Fecha todas as figuras abertas
clc;               % Limpa a janela de comandos

%----------------------------------------------------------------
% 1. Adicionar Caminho do Dynare
%----------------------------------------------------------------
% Atualize o caminho abaixo conforme a instalação do Dynare em seu sistema
addpath('C:\dynare\6.2\matlab'); % Substitua pelo caminho correto do Dynare

%----------------------------------------------------------------
% 2. Definir Diretório do Modelo
%----------------------------------------------------------------
% Atualize o diretório abaixo para o local onde está o arquivo .mod
model_dir = 'C:\Users\Eco\Desktop\Monetary Policy\Trabalho Final\UnconventionalModel'; % Substitua pelo seu diretório
cd(model_dir); % Muda o diretório de trabalho para o diretório do modelo

%----------------------------------------------------------------
% 3. Definir Combinações de Parâmetros
%----------------------------------------------------------------
% Cada linha representa uma combinação de [gampi, gamY, gampiQE, gamYQE]
param_combinations = [
    1.49, 2.16, 0.00, 0.00;
    1.49, 2.16, 0.04, 1.78;
    1.67, 0.00, 0.00, 18.22
];

num_param_combinations = size(param_combinations, 1); % Número de combinações de parâmetros

%----------------------------------------------------------------
% 4. Definir Combinações de Choques
%----------------------------------------------------------------
% Cada célula define uma combinação de choques com seus respectivos stderrs
shock_combinations = {
    {'epsnu', 0.0025};          % Combinação 1: apenas epsnu ativo
    {'epsksi', 0.0025};         % Combinação 2: apenas epsksi ativo
    {'epsC', 0.0025};            % Combinação 3: apenas epsC ativo
    {'epsL', 0.0025};            % Combinação 4: apenas epsL ativo
    {'epsG', 0.005};            % Combinação 5: apenas epsG ativo
    {'epsA', 0.01};            % Combinação 6: apenas epsA ativo
    {'epsthet', 0.06}          % Combinação 7: apenas epsthet ativo
};

num_shock_combinations = size(shock_combinations, 1); % Número de combinações de choques

%----------------------------------------------------------------
% 5. Preparar Arquivo de Resultados
%----------------------------------------------------------------
% Nome do arquivo de resultados
result_txt_file = 'Resultados_Simulacao.txt';

% Abrir arquivo .txt para escrita (sobrescreve se já existir)
fileID = fopen(result_txt_file, 'w');
if fileID == -1
    error('Não foi possível criar o arquivo %s.', result_txt_file);
end

fprintf(fileID, 'Resultados das Simulações:\n\n');

%----------------------------------------------------------------
% 6. Nome Base do Arquivo .mod
%----------------------------------------------------------------
base_mod_file = 'UnconventionalShockType.mod';

%----------------------------------------------------------------
% 7. Definir Lista de Choques
%----------------------------------------------------------------
list_of_shocks = {'epsnu', 'epsksi', 'epsC', 'epsL', 'epsG', 'epsA', 'epsthet'};

%----------------------------------------------------------------
% 8. Loop sobre as Combinações de Parâmetros e Choques
%----------------------------------------------------------------
simulation_counter = 1; % Contador de simulações

for param_idx = 1:num_param_combinations
    % Extrair os valores atuais dos parâmetros
    current_gampi = param_combinations(param_idx, 1);
    current_gamY = param_combinations(param_idx, 2);
    current_gampiQE = param_combinations(param_idx, 3);
    current_gamYQE = param_combinations(param_idx, 4);

    for shock_idx = 1:num_shock_combinations
        % Extrair a combinação de choques atual
        current_shocks = shock_combinations{shock_idx};

        % Identificar o choque ativo
        active_shock = '';
        active_stderr = 0;
        for sc = 1:2:length(current_shocks)
            if current_shocks{sc+1} > 0
                active_shock = current_shocks{sc};
                active_stderr = current_shocks{sc+1};
                break; % Apenas um choque ativo por combinação
            end
        end

        % Exibir informações da simulação no console
        fprintf('Simulação %d: gampi=%.2f, gamY=%.2f, gampiQE=%.2f, gamYQE=%.2f, Choque em %s\n', ...
                simulation_counter, current_gampi, current_gamY, current_gampiQE, current_gamYQE, active_shock);

        % Escrever informações da simulação no arquivo de resultados
        fprintf(fileID, 'Simulação %d:\n', simulation_counter);
        fprintf(fileID, 'gampi = %.2f\n', current_gampi);
        fprintf(fileID, 'gamY = %.2f\n', current_gamY);
        fprintf(fileID, 'gampiQE = %.2f\n', current_gampiQE);
        fprintf(fileID, 'gamYQE = %.2f\n', current_gamYQE);
        fprintf(fileID, 'Choques Ativos:\n');
        for sc = 1:2:length(current_shocks)
            if current_shocks{sc+1} > 0
                fprintf(fileID, '  %s (stderr=%.4f)\n', current_shocks{sc}, current_shocks{sc+1});
            end
        end
        fprintf(fileID, '\n');

        % Ler o conteúdo do arquivo .mod original
        fid = fopen(base_mod_file, 'r');
        if fid == -1
            error('Não foi possível abrir o arquivo %s.', base_mod_file);
        end
        mod_content = fread(fid, '*char')'; % Ler todo o conteúdo como uma string
        fclose(fid);

        % Substituir os valores dos parâmetros usando regex
        mod_content = regexprep(mod_content, '(gampi\s*=\s*)\d+\.?\d*', ['$1' num2str(current_gampi)]);
        mod_content = regexprep(mod_content, '(gamY\s*=\s*)\d+\.?\d*', ['$1' num2str(current_gamY)]);
        mod_content = regexprep(mod_content, '(gampiQE\s*=\s*)\d+\.?\d*', ['$1' num2str(current_gampiQE)]);
        mod_content = regexprep(mod_content, '(gamYQE\s*=\s*)\d+\.?\d*', ['$1' num2str(current_gamYQE)]);

        % Reconstituir o bloco de choques com apenas o choque ativo descomentado
        new_shocks_block = 'shocks;\n';
        for shock = 1:length(list_of_shocks)
            shock_var = list_of_shocks{shock};
            if strcmp(shock_var, active_shock)
                % Choque ativo: definir stderr adequado
                new_shocks_block = [new_shocks_block, sprintf('    var %s; stderr %.4f;\n', shock_var, active_stderr)];
            else
                % Choques inativos: definir stderr igual a zero
                new_shocks_block = [new_shocks_block, sprintf('    var %s; stderr 0.0000;\n', shock_var)];
            end
        end
        new_shocks_block = [new_shocks_block, 'end;\n'];

        % Substituir o bloco de choques no mod_content
        mod_content = regexprep(mod_content, '(?s)shocks;.*?end;', new_shocks_block);

        % Definir o nome do arquivo temporário
        temp_mod_file = sprintf('UnconventionalShockType_temp%d.mod', simulation_counter);

        % Escrever o conteúdo modificado no arquivo temporário
        fid = fopen(temp_mod_file, 'w');
        if fid == -1
            error('Não foi possível criar o arquivo temporário %s.', temp_mod_file);
        end
        fwrite(fid, mod_content);
        fclose(fid);

        % Executar Dynare com o arquivo temporário
        try
            dynare(temp_mod_file, 'noclearall');
        catch ME
            fprintf('Erro ao executar Dynare para a simulação %d: %s\n', simulation_counter, ME.message);
            % Registrar o erro e continuar
            results(simulation_counter, :) = [current_gampi, current_gamY, current_gampiQE, current_gamYQE, NaN];
            fprintf(fileID, 'Erro na Simulação %d: %s\n\n', simulation_counter, ME.message);
            % Remover o arquivo temporário antes de continuar
            delete(temp_mod_file);
            simulation_counter = simulation_counter + 1;
            continue;
        end

        % Coletar resultados da execução
        try
            % Verificar se o modelo foi resolvido corretamente
            if isempty(oo_.var)
                error('Variâncias não foram calculadas. Verifique a solução do modelo.');
            end

            % Encontrar índices das variáveis endógenas
            idx_Pi = find(strcmp(M_.endo_names, 'Pi'));
            idx_Y = find(strcmp(M_.endo_names, 'Y'));
            idx_i = find(strcmp(M_.endo_names, 'i'));
            idx_iQ = find(strcmp(M_.endo_names, 'iQ'));

            % Verificar se todas as variáveis foram encontradas
            if isempty(idx_Pi) || isempty(idx_Y) || isempty(idx_i) || isempty(idx_iQ)
                error('Uma ou mais variáveis endógenas não foram encontradas no modelo.');
            end

             % Extrair as variâncias e multiplicar pelos fatores especificados
            variance_Pi = oo_.var(idx_Pi, idx_Pi) * 1e5;
            variance_Y = oo_.var(idx_Y, idx_Y) * 1e5;
            variance_i = oo_.var(idx_i, idx_i) * 1e4;
            variance_iQ = oo_.var(idx_iQ, idx_iQ) * 1e4;

            % Calcular a função de perda
            loss = 0.8 * variance_Pi + 0.2 * variance_Y + 0 * variance_i + 0 * variance_iQ;

            % Armazenar os resultados
            results(simulation_counter, :) = [current_gampi, current_gamY, current_gampiQE, current_gamYQE, loss];

            % Escrever os resultados no arquivo .txt
            fprintf(fileID, 'Variance of Pi: %.8f\n', variance_Pi);
            fprintf(fileID, 'Variance of Y: %.8f\n', variance_Y);
            fprintf(fileID, 'Variance of i: %.8f\n', variance_i);
            fprintf(fileID, 'Variance of iQ: %.8f\n', variance_iQ);
            fprintf(fileID, 'Loss Function: %.8f\n\n', loss);

            fprintf('Função de perda: %.8f\n\n', loss);
        catch ME
            fprintf('Erro ao coletar resultados para a simulação %d: %s\n', simulation_counter, ME.message);
            results(simulation_counter, :) = [current_gampi, current_gamY, current_gampiQE, current_gamYQE, NaN];
            fprintf(fileID, 'Erro na Coleta de Resultados para Simulação %d: %s\n\n', simulation_counter, ME.message);
        end

        % Remover o arquivo temporário
        delete(temp_mod_file);

        % Limpar as variáveis específicas do Dynare para evitar conflitos
        clearvars -global M_ options_ oo_ estim_params_ bayestopt_ dataset_ exogen_ endogenous_

        % Incrementar o contador de simulações
        simulation_counter = simulation_counter + 1;
    end
end


%----------------------------------------------------------------
% 9. Fechar o Arquivo de Resultados
%----------------------------------------------------------------
fclose(fileID);

%----------------------------------------------------------------
% 10. Exibir Mensagem de Conclusão
%----------------------------------------------------------------
disp('Simulações concluídas e resultados armazenados em Resultados_Simulacao.txt');



