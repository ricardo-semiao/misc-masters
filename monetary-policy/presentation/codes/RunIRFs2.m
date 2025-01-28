% Script para rodar o modelo ModeloIRFs no Dynare com dois conjuntos de parâmetros diferentes e plotar IRFs comparativas

%----------------------------------------------------------------
% 0. Preparação do Ambiente
%----------------------------------------------------------------

clear all;
close all;
clc;

%----------------------------------------------------------------
% 1. Adicionar Caminho do Dynare
%----------------------------------------------------------------

addpath('C:\dynare\6.2\matlab');

%----------------------------------------------------------------
% 2. Navegar para o Diretório do Modelo
%----------------------------------------------------------------

cd('C:\Users\Eco\Desktop\Monetary Policy\Trabalho Final\UnconventionalModel');

%----------------------------------------------------------------
% 3. Definir Conjuntos de Parâmetros
%----------------------------------------------------------------

param_sets = {
    [1.49, 2.16, 0, 0], ...     % Conjunto 1: [gampi, gamY, gampiQE, gamYQE]
    [1.67, 0, 0, 18.22]          % Conjunto 2: [gampi, gamY, gampiQE, gamYQE]
};

num_param_sets = length(param_sets);

%----------------------------------------------------------------
% 4. Executar Dynare para Cada Conjunto de Parâmetros e Salvar Resultados
%----------------------------------------------------------------

for i = 1:num_param_sets
    % Extrair o conjunto de parâmetros atual
    gampi = param_sets{i}(1);
    gamY = param_sets{i}(2);
    gampiQE = param_sets{i}(3);
    gamYQE = param_sets{i}(4);

    % Ler o arquivo .mod base
    base_mod_file = 'ModeloIRFs2.mod';
    fid = fopen(base_mod_file, 'r');
    if fid == -1
        error('Não foi possível abrir o arquivo %s.', base_mod_file);
    end
    mod_content = fread(fid, '*char')'; % Ler todo o conteúdo como string
    fclose(fid);

    % Substituir os parâmetros usando regex
    mod_content = regexprep(mod_content, '(gampi\s*=\s*)\d+\.?\d*', ['$1' num2str(gampi)]);
    mod_content = regexprep(mod_content, '(gamY\s*=\s*)\d+\.?\d*', ['$1' num2str(gamY)]);
    mod_content = regexprep(mod_content, '(gampiQE\s*=\s*)\d+\.?\d*', ['$1' num2str(gampiQE)]);
    mod_content = regexprep(mod_content, '(gamYQE\s*=\s*)\d+\.?\d*', ['$1' num2str(gamYQE)]);

    % Definir o nome do arquivo .mod temporário
    temp_mod_file = sprintf('ModeloIRFs_temp%d.mod', i);

    % Escrever o conteúdo modificado no arquivo .mod temporário
    fid = fopen(temp_mod_file, 'w');
    if fid == -1
        error('Não foi possível criar o arquivo temporário %s.', temp_mod_file);
    end
    fwrite(fid, mod_content);
    fclose(fid);

    % Executar Dynare com o arquivo .mod temporário
    dynare(temp_mod_file, 'noclearall');

    % Salvar a saída para plotagem posterior
    save(sprintf('IRF_results_%d.mat', i), 'oo_');

    % Remover o arquivo .mod temporário
    delete(temp_mod_file);

    % Limpar variáveis do Dynare para evitar conflitos na próxima iteração
    clearvars -global M_ options_ oo_ estim_params_ bayestopt_ dataset_ exogen_ endogenous_
end

%----------------------------------------------------------------
% 5. Carregar Resultados e Plotar IRFs Comparativas
%----------------------------------------------------------------

% Carregar os resultados de ambas as simulações
load('IRF_results_1.mat', 'oo_');
irfs1 = oo_.irfs;
load('IRF_results_2.mat', 'oo_');
irfs2 = oo_.irfs;

% Definir vetor de tempo (assumindo que ambos os IRFs têm o mesmo comprimento)
t = 1:length(irfs1.Pi_epsthet);
z = zeros(length(t), 1); % Linha zero para referência

% Definir as variáveis a serem plotadas
variables = {'Pi', 'Y', 'i', 'PB', 'PQ', 'Pss', 'b', 'q', 's', 'qCB', 'L', 'w'};
shock = 'epsthet'; % O choque de interesse

% Criar a figura
figure;

% Inicializar arrays para armazenar os handles das plots
handles1 = [];
handles2 = [];

for idx = 1:length(variables)
    varname = variables{idx};
    subplot(4, 3, idx);

    % Plot IRF do primeiro conjunto de parâmetros
    h1 = plot(t, irfs1.([varname '_' shock]), 'black', 'LineWidth', 0.7);
    hold on;
    % Plot IRF do segundo conjunto de parâmetros
    h2 = plot(t, irfs2.([varname '_' shock]), 'blue', 'LineWidth', 0.7);
    % Plot linha zero para referência
    plot(t, z, 'red', 'LineWidth', 1);

    xlim([1 20]);
    title(varname, 'FontSize', 10);
    xlabel('Períodos');
    ylabel(['Response ' varname]);
    grid on;

    % Armazenar os handles das primeiras plots para criar a legenda global
    if idx == 1
        handles1 = h1;
        handles2 = h2;
    end
end

% Adicionar uma única legenda para todos os subplots
legend([handles1, handles2], {'Conventional', 'Conventional and Unconventional'}, ...
       'FontSize', 10, 'Box', 'off', 'Location', 'bestoutside');

% Ajustar o tamanho da figura para acomodar a legenda externa
set(gcf, 'Position', [100, 100, 1400, 800]); % [left, bottom, width, height]

% Exibir mensagem de conclusão
disp('IRFs comparativas plotadas com uma única legenda.');

