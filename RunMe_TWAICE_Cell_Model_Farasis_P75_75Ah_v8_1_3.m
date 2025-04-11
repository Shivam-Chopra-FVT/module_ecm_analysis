%% RunMe File to Activate License, Load Data to Workspace and open Simulink
%  -----------------------------------------------------------------------
%  To be run before starting Simulation in Simulink
%  -----------------------------------------------------------------------
%  Input Data:
%  *Only relevant if own Data and not the Simulink Cycle Generator is used
%  Example if Input Data is not in timeseries but in double Format   
%  Using own Data/Profile for Charge AND Discharge
%  Data = timeseries([I,T_amb],t);
%  Using own Data/Profile for Discharge but Cycle Generator for Charge
%  Data_Discharge = timeseries(I,t); 
%
%  Copyright TWAICE Technologies GmbH, Munich, Germany 

%% Preamble
clear all
addpath('./config');

%% License Info
% License Key can be accessed after Login under twaice.cloud
%Prod_lic = 'E7A252-420A94-4FAB91-7AD18A-69D2F0-AF7A9D';  % Chris's License
Prod_lic = '211305-97D2BC-4534B4-57AE1E-46F959-7E7AA9';  % Shivam's License
lic_no = fin_convert(Prod_lic); 
act = 1; %1 for activation, 0 for deactivation

%% Exemplary data and simulation settings
load('Data');
load('Data_Discharge')
t_start = 0;
t_end = 1;
Ts = 1;

%% Read in Current Limits Based on T and SOC from Excel
% T_SOC_based_CurrentLimits.xlsx
% Charging Limits
chargelim = readtable('T_SOC_based_CurrentLimits.xlsx','sheet','Charging',...
    'ReadVariableNames',false);
inx_soc = find(contains([chargelim.Var1], 'SOC / %'));
soc_chlim = chargelim.Var2(inx_soc:end)';
I_chlim = [];
T_chlim = [];
for i = 1:size(chargelim,2)-2
    I_lim = table2array(chargelim(inx_soc:end,i+2));
    I_chlim(:,i) = I_lim;
    T_chlim(1,i) = table2array(chargelim(inx_soc-1,i+2));
end
% Discharging Limits
dischargelim = readtable('T_SOC_based_CurrentLimits.xlsx','sheet','Discharging',...
    'ReadVariableNames',false);
inx_soc = find(contains([dischargelim.Var1], 'SOC / %'));
soc_dislim = dischargelim.Var2(inx_soc:end)';
I_dislim = [];
T_dislim = [];
for i = 1:size(dischargelim,2)-2
    I_lim = table2array(dischargelim(inx_soc:end,i+2));
    I_dislim(:,i) = I_lim;
    T_dislim(1,i) = table2array(dischargelim(inx_soc-1,i+2));
end

%% Open TWAICE Electric-Thermal-Aging Model
model = 'TWAICE_Cell_Model_Farasis_P75_75Ah_v8_1_3';                
open(model);
disp('Model succesfully loaded!')

%% Visualization Example after Simulation
% can only be run once simulation is done and out file generated
% in MATLAB Workspace
% Plots SOHcapacity and SOHresistance over Throughput
if exist('out', 'var')
    figure;
    ax1 = subplot(2,1,1);
    plot(out.total_Ah.Data, out.SOHc.Data, '-', 'LineWidth', 2)
    hold on; grid on; box on
    ylabel('SOHc / -')
    xlabel('Throughput / Ah')
    ax1.XRuler.Exponent = 0;    

    ax2 = subplot(2,1,2);
    plot(out.total_Ah.Data, out.SOHr.Data, '-', 'LineWidth', 2)
    hold on; grid on; box on
    ylabel('SOHr / -')
    xlabel('Throughput / Ah')
    set(gcf,'color','w');
    linkaxes([ax1, ax2], 'x')
    ax2.XRuler.Exponent = 0;
end
