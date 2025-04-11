function[testing_table,capacity_nominal] = import_automation_file(filename_automation_xlsx)
% This function read the data from the .xlsx file covering a 
% testing table for automated simulation with the TWAICE Virtual Battery
% Tester
%
% Inputs:
%       - Name of the .xlsx file 
%
%
% Outputs:
%       - Struct covering the testing table
% Copyright 2022 TWAICE Technologies GmbH, Munich, Germany   
%%
warning('off','all') 
opts = detectImportOptions(filename_automation_xlsx);
opts = setvartype(opts,'char'); 
auto_sim_table = readtable(filename_automation_xlsx,opts,'sheet','Simulation Matrix');
opts_config = detectImportOptions(filename_automation_xlsx);
opts_config = setvartype(opts_config,'char'); 
opts_config.DataRange = 'A1';
config_sheet = readtable(filename_automation_xlsx,opts_config,'sheet','Config');
capacity_nominal = config_sheet.(config_sheet.Properties.VariableNames{6}){2};
capacity_nominal = str2double(capacity_nominal);
%%
inx_row_start = find(strcmp(auto_sim_table{:,1}, 'Simulation Number'));
inx_row_start = inx_row_start(end);
% inx_row_end = inx_row_start+find(auto_sim_table{inx_row_start:end,1} == "",1)-2;
inx_row_end = size(auto_sim_table,1);
inx_column_end = find(strcmp(auto_sim_table{inx_row_start,:}, 'CV Cutoff Current / A'));
inx_column_end = inx_column_end(end)+1;
%%
testing_table = [];
i_sim = 1;
disp('##########################################################################################################')
fprintf("Importing simulation test cases from %s...\n",filename_automation_xlsx)
for inx_sim_table = inx_row_start+1:inx_row_end
    %%%%GENERAL%%%%%
    testing_table(1,i_sim).simulation_number = str2num(cell2mat((auto_sim_table{inx_sim_table,1})));
    testing_table(1,i_sim).T_amb = str2num(cell2mat((auto_sim_table{inx_sim_table,2})));
    stop_condition = char(auto_sim_table{inx_sim_table,3});
    if contains(stop_condition, 'SOHc /')
        stop_condition = 'SOHc /';
    elseif strcmp(stop_condition, 'Time / h')
        stop_condition = 'Time / h';
    elseif strcmp(stop_condition, 'EFC / -')
        stop_condition = 'Equivalent Full Cycles / -';
    elseif strcmp(stop_condition, 'Cycles / -')
        stop_condition = 'Cycles / -';
    end
    testing_table(1,i_sim).stop_condition = stop_condition;
    testing_table(1,i_sim).stop_value = str2num(cell2mat((auto_sim_table{inx_sim_table,4})));
    %%%%CHARGING%%%%    
    testing_table(1,i_sim).charge_type = char(auto_sim_table{inx_sim_table,5});
    testing_table(1,i_sim).charge_type_value = str2num(cell2mat((auto_sim_table{inx_sim_table,6})));
    testing_table(1,i_sim).charge_stop = char(auto_sim_table{inx_sim_table,7});
    testing_table(1,i_sim).charge_stop_value = str2num(cell2mat((auto_sim_table{inx_sim_table,8})));
    testing_table(1,i_sim).charge_cv_trigger = char(auto_sim_table{inx_sim_table,9});
    testing_table(1,i_sim).charge_cv_cutoff_I = str2num(cell2mat((auto_sim_table{inx_sim_table,10})));
    if contains(testing_table(1,i_sim).charge_stop, 'SOC /') && strcmp(testing_table(1,i_sim).charge_cv_trigger ,'on')
        testing_table(1,i_sim).charge_cv_trigger = 'off';    
        fprintf("Simulation Number %d: Set CV phase charge to OFF as SOC is selected as charge stop criteria!\n",i_sim)
    end
    testing_table(1,i_sim).charge_pause = str2num(cell2mat((auto_sim_table{inx_sim_table,11})));

    %%%%DISCHARGING%%%%
    testing_table(1,i_sim).discharge_type = char(auto_sim_table{inx_sim_table,12});
    testing_table(1,i_sim).discharge_type_value = str2num(cell2mat((auto_sim_table{inx_sim_table,13})));
    testing_table(1,i_sim).discharge_stop = char(auto_sim_table{inx_sim_table,14});
    testing_table(1,i_sim).discharge_stop_value = str2num(cell2mat((auto_sim_table{inx_sim_table,15})));
    testing_table(1,i_sim).discharge_cv_trigger = char(auto_sim_table{inx_sim_table,16});
    testing_table(1,i_sim).discharge_cv_cutoff_I = str2num(cell2mat((auto_sim_table{inx_sim_table,17})));
    if contains(testing_table(1,i_sim).discharge_stop, 'SOC /') && strcmp(testing_table(1,i_sim).discharge_cv_trigger ,'on')
        testing_table(1,i_sim).discharge_cv_trigger = 'off';    
        fprintf("Simulation Number %d: Set CV phase discharge to OFF as SOC is selected as discharge stop criteria!\n",i_sim)
    end
    testing_table(1,i_sim).discharge_pause = str2num(cell2mat((auto_sim_table{inx_sim_table,18})));
    i_sim = i_sim+1;
end
while isempty(testing_table(1).simulation_number) || isempty(testing_table(1).T_amb) 
    testing_table(1) = [];
end
while isempty(testing_table(end).simulation_number)
    testing_table(end) = [];
end
fprintf("Imported %d simulation test cases!\n", size(testing_table,2))
disp('##########################################################################################################')

