%% TWAICE Simulation Study Automation Toolkit
%  Reads in the test matrix designed in the xlsm file
%  TWAICE_Simulation_Study_Automation_Toolkit.xlsm.
%   
%  User can select a folder where to store the simulation outputs.
%  After selection the designed test matrix is simulated one testcase
%  after the other.
%
%  Saves:  Figure_SOHc, Figure_SOHr
%          All Simulations compact with only SOHc, SOHr, Q_Ah, time_s
%          Each simulation output with all simulated quantities
%              - the latter one can take huge space on drive
%              - if not all the simulation output should be save due
%                limited memory line 116 can be commented out
%
%  Note: If a licensed simulation model is used, the license key
%        must be entered in the RunMe_TWAICE_Cell_Model[...].mat file
%        beforehand.
%
%  Copyright 2022-2023 TWAICE Technologies GmbH, Munich, Germany 

%% Preamble
clear
close all hidden
clc
bdclose
restoredefaultpath
addpath('./config'); % Add path with configuration files

%% Load the TWAICE ETA Cell Model
files = dir;
inx_runme = contains({files.name},'RunMe_TWAICE_Cell_Model');
run(files(inx_runme).name);

%% Import save folder and the .xlsx automation file
disp('Select folder to store simulation outputs in pop-up window...')
save_folder_simulation_outputs = uigetdir('','Select folder to store simulation outputs:');
if save_folder_simulation_outputs == 0
    error('No folder selected to store simulation outputs!');
else
    disp('Folder successfully selected!')
end
filename_automation_xlsx = 'TWAICE_Simulation_Study_Automation_Toolkit.xlsm';
[testing_table,capacity_nominal] = import_automation_file(filename_automation_xlsx);

%% Run Simulations and save individual simulations under selected folder
warning('off','all')
virtual_battery_tester_mask = Simulink.Mask.get(strcat(model,'/Virtual Battery Tester'));
eta_cell_model_mask = Simulink.Mask.get(strcat(model,'/TWAICE Cell Model'));
virtual_battery_tester_mask.Parameters(1,1).Value = 'Cycle Generator'; % Set to Timeseries Data

results_all_simulations = [];
figure_all_simulations_sohc = figure;
figure_all_simulations_sohr = figure;
line_style = {'-', '--', ':', '-.'};
line_style_counter = 1;
clr_counter = 1;
clr = colorcode;
d = datetime('now','TimeZone','local','Format','yyyyMMdd');
d = convertCharsToStrings(char(d));   
for inx_sim_run = 1:size(testing_table,2)
    fprintf("Running simulation %d of %d...\n", inx_sim_run, size(testing_table,2));
    % Overwrite Mask Parameters
    [virtual_battery_tester_mask,eta_cell_model_mask] = ...
        change_mask_parameters_ETA_TWAICE_cell_model(testing_table(inx_sim_run), ...
        virtual_battery_tester_mask,eta_cell_model_mask);
    % Run Simulation
    simulation_output = sim(model);
    
    % Store results
    results_all_simulations(inx_sim_run).simulation_number = testing_table(inx_sim_run).simulation_number;
    results_all_simulations(inx_sim_run).test_table = testing_table(inx_sim_run);
    results_all_simulations(inx_sim_run).SOHc = simulation_output.SOHc.Data;
    results_all_simulations(inx_sim_run).SOHr = simulation_output.SOHr.Data;
    results_all_simulations(inx_sim_run).Q_Ah = simulation_output.total_Ah.Data;
    results_all_simulations(inx_sim_run).t_s = simulation_output.total_Ah.time;
      
    % Plotting
    [legend_text, file_name] = get_legend_text(results_all_simulations(inx_sim_run).test_table);
    
    % SOHc over EFC
    figure(figure_all_simulations_sohc.Number)
    subplot(1,2,1)
    plot(results_all_simulations(inx_sim_run).Q_Ah/(2*capacity_nominal), 100*results_all_simulations(inx_sim_run).SOHc,line_style{line_style_counter},'Color', clr(clr_counter,:),'DisplayName', legend_text, 'LineWidth', 1.5)
    hold on; grid on; box on; set(gcf,'color','w');
    ylabel('SOHc / %'), xlabel('EFC / -')
    legend show
    % SOHc over time
    subplot(1,2,2)
    plot(results_all_simulations(inx_sim_run).t_s/(3600*24), 100*results_all_simulations(inx_sim_run).SOHc,line_style{line_style_counter},'Color', clr(clr_counter,:),'DisplayName', legend_text, 'LineWidth', 1.5)
    hold on; grid on; box on; set(gcf,'color','w');
    ylabel('SOHc / %'), xlabel('Time / days')
    legend show
    
    % SOHr over EFC
    figure(figure_all_simulations_sohr.Number)
    subplot(1,2,1)
    plot(results_all_simulations(inx_sim_run).Q_Ah/(2*capacity_nominal), 100*results_all_simulations(inx_sim_run).SOHr,line_style{line_style_counter},'Color', clr(clr_counter,:),'DisplayName', legend_text, 'LineWidth', 1.5)
    hold on; grid on; box on; set(gcf,'color','w');
    ylabel('SOHr / %'); xlabel('EFC / -')
    legend show
    % SOHr over Time
    subplot(1,2,2)
    plot(results_all_simulations(inx_sim_run).t_s/(3600*24), 100*results_all_simulations(inx_sim_run).SOHr,line_style{line_style_counter},'Color', clr(clr_counter,:),'DisplayName', legend_text, 'LineWidth', 1.5)
    hold on; grid on; box on; set(gcf,'color','w');
    ylabel('SOHr / %'); xlabel('Time / days')
    legend show
    
    line_style_counter = line_style_counter + 1;
    if line_style_counter == 5
        line_style_counter = 1;
    end
    
    clr_counter = clr_counter + 1;
    if clr_counter == 12
        clr_counter = 1;
    end
    
    % Save Simulation Output (Note: can take huge space on drive!)
    fprintf("Saving simulation %d of %d!\n", inx_sim_run, size(testing_table,2));
    save(strcat(save_folder_simulation_outputs,filesep,d,'_',file_name, '.mat'), 'simulation_output',"-v7.3")
    pause(5);
    
end

figure_all_simulations_sohc.Position = ([50,80,1500,830]);
figure_all_simulations_sohr.Position = ([50,80,1500,830]);
figure(figure_all_simulations_sohc.Number)

%% Save overall results and figure
save(strcat(save_folder_simulation_outputs,filesep,d,'_Sim_All_Compact_SOHc_SOHr.mat'), 'results_all_simulations')
savefig(figure_all_simulations_sohc,strcat(save_folder_simulation_outputs,filesep,d,'_Figure_SOHc.fig'))
savefig(figure_all_simulations_sohr,strcat(save_folder_simulation_outputs,filesep,d,'_Figure_SOHr.fig'))

%% End
disp('_________________________')
disp('******* Finished *******')
