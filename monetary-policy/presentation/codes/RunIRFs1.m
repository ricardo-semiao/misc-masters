
% Script para rodar o modelo ModeloIRFs no Dynare usando Octave e plotar as IRFs

%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

% Limpar o ambiente: remove todas as variáveis, fecha figuras e limpa o console
clear all;
close all;
clc;

%----------------------------------------------------------------
% 1. Adicionar o Caminho do Dynare
%----------------------------------------------------------------

% Adicionar o caminho do Dynare (ajuste conforme a instalação no seu sistema)
addpath('C:\dynare\6.2\matlab');

%----------------------------------------------------------------
% 2. Navegar até o Diretório do Modelo
%----------------------------------------------------------------

% Definir o diretório onde o arquivo .mod está localizado
cd('C:\Users\Eco\Desktop\Monetary Policy\Trabalho Final\UnconventionalModel');

%----------------------------------------------------------------
% 3. Executar o Modelo Dynare
%----------------------------------------------------------------

% Executar o arquivo Dynare
dynare ModeloIRFs.mod

%----------------------------------------------------------------
% 4. Gerar Variáveis para Plotagem
%----------------------------------------------------------------

% Verificar se a IRF para 'Pi_epsnu' existe antes de usá-la
if isfield(oo_.irfs, 'Pi_epsnu')
    t = 1:length(oo_.irfs.Pi_epsnu);  % Criar vetor de tempo baseado na IRF
else
    error('IRF para Pi_epsnu não encontrada. Verifique o nome da variável.');
end

% Criar um vetor de zeros para referência nas plotagens
z = zeros(length(t),1);

%----------------------------------------------------------------
% 5. Replicação da Figura 1 (Resposta ao Choque epsnu)
%----------------------------------------------------------------

figure

% Subplot 1: IRF de Pi (Inflação)
subplot(4,3,1)
plot(t, oo_.irfs.Pi_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 4e-04])
title('\Pi','FontSize',10);
xlabel('Períodos');
ylabel('Resposta \Pi');
grid on;

% Subplot 2: IRF de Y (Produto)
subplot(4,3,2)
plot(t, oo_.irfs.Y_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-04 5e-04])
title('Y','FontSize',10);
xlabel('Períodos');
ylabel('Resposta Y');
grid on;

% Subplot 3: IRF de i (Taxa de Juros)
subplot(4,3,3)
plot(t, oo_.irfs.i_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-03 5e-03])
title('i','FontSize',10);
xlabel('Períodos');
ylabel('Resposta i');
grid on;

% Subplot 4: IRF de P^B (Preço do Short-Term Bond)
subplot(4,3,4)
plot(t, oo_.irfs.PB_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-03 5e-03])
title('P^B','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^B');
grid on;

% Subplot 5: IRF de P^Q (Preço do Long-Term Bond)
subplot(4,3,5)
plot(t, oo_.irfs.PQ_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.05 0.05])
title('P^Q','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^Q');
grid on;

% Subplot 6: IRF de P^S * s (Savings)
subplot(4,3,6)
plot(t, oo_.irfs.Pss_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.02 0])
title('P^S * s','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^S * s');
grid on;

% Subplot 7: IRF de b (Balanço)
subplot(4,3,7)
plot(t, oo_.irfs.b_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.02 0])
title('b','FontSize',10);
xlabel('Períodos');
ylabel('Resposta b');
grid on;

% Subplot 8: IRF de q (Quantidade)
subplot(4,3,8)
plot(t, oo_.irfs.q_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.02 0.02])
title('q','FontSize',10);
xlabel('Períodos');
ylabel('Resposta q');
grid on;

% Subplot 9: IRF de s (Savings)
subplot(4,3,9)
plot(t, oo_.irfs.s_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.02 0])
title('s','FontSize',10);
xlabel('Períodos');
ylabel('Resposta s');
grid on;

% Subplot 10: IRF de q^{CB} (Quantidade de Central Bank)
subplot(4,3,10)
plot(t, oo_.irfs.qCB_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-0.02 0.02])
title('q^{CB}','FontSize',10);
xlabel('Períodos');
ylabel('Resposta q^{CB}');
grid on;

% Subplot 11: IRF de L (Leisure)
subplot(4,3,11)
plot(t, oo_.irfs.L_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 2e-03])
title('L','FontSize',10);
xlabel('Períodos');
ylabel('Resposta L');
grid on;

% Subplot 12: IRF de w (Wage)
subplot(4,3,12)
plot(t, oo_.irfs.w_epsnu, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 1e-03])
title('w','FontSize',10);
xlabel('Períodos');
ylabel('Resposta w');
grid on;



%----------------------------------------------------------------
% 6. Replicação da Figura 2 (Resposta ao Choque epsksi)
%----------------------------------------------------------------

figure

% Subplot 1: IRF de Pi (Inflação) para epsksi
subplot(4,3,1)
plot(t, oo_.irfs.Pi_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 5e-05])
title('\Pi','FontSize',10);
xlabel('Períodos');
ylabel('Resposta \Pi');
grid on;

% Subplot 2: IRF de Y (Produto) para epsksi
subplot(4,3,2)
plot(t, oo_.irfs.Y_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-05 5e-05])
title('Y','FontSize',10);
xlabel('Períodos');
ylabel('Resposta Y');
grid on;

% Subplot 3: IRF de i (Taxa de Juros) para epsksi
subplot(4,3,3)
plot(t, oo_.irfs.i_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 5e-05])
title('i','FontSize',10);
xlabel('Períodos');
ylabel('Resposta i');
grid on;

% Subplot 4: IRF de P^B (Preço do Short-Term Bond) para epsksi
subplot(4,3,4)
plot(t, oo_.irfs.PB_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-05 0])
title('P^B','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^B');
grid on;

% Subplot 5: IRF de P^Q (Preço do Long-Term Bond) para epsksi
subplot(4,3,5)
plot(t, oo_.irfs.PQ_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-5e-03 5e-03])
title('P^Q','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^Q');
grid on;

% Subplot 6: IRF de P^S * s (Savings) para epsksi
subplot(4,3,6)
plot(t, oo_.irfs.Pss_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-2e-03 0])
title('P^S * s','FontSize',10);
xlabel('Períodos');
ylabel('Resposta P^S * s');
grid on;

% Subplot 7: IRF de b (Balanço) para epsksi
subplot(4,3,7)
plot(t, oo_.irfs.b_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-2e-03 0])
title('b','FontSize',10);
xlabel('Períodos');
ylabel('Resposta b');
grid on;

% Subplot 8: IRF de q (Quantidade) para epsksi
subplot(4,3,8)
plot(t, oo_.irfs.q_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-1e-03 1e-03])
title('q','FontSize',10);
xlabel('Períodos');
ylabel('Resposta q');
grid on;

% Subplot 9: IRF de s (Savings) para epsksi
subplot(4,3,9)
plot(t, oo_.irfs.s_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-2e-03 0])
title('s','FontSize',10);
xlabel('Períodos');
ylabel('Resposta s');
grid on;

% Subplot 10: IRF de q^{CB} (Quantidade de Central Bank) para epsksi
subplot(4,3,10)
plot(t, oo_.irfs.qCB_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([-1e-03 1e-03])
title('q^{CB}','FontSize',10);
xlabel('Períodos');
ylabel('Resposta q^{CB}');
grid on;

% Subplot 11: IRF de L (Leisure) para epsksi
subplot(4,3,11)
plot(t, oo_.irfs.L_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 2e-04 ])
title('L','FontSize',10);
xlabel('Períodos');
ylabel('Resposta L');
grid on;

% Subplot 12: IRF de w (Wage) para epsksi
subplot(4,3,12)
plot(t, oo_.irfs.w_epsksi, 'black', t, z, 'red', 'LineWidth', 1.5)
xlim([1 20])
ylim([0 1e-04 ])
title('w','FontSize',10);
xlabel('Períodos');
ylabel('Resposta w');
grid on;


