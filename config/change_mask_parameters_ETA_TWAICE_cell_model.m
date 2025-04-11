function[virtual_battery_tester_mask,eta_cell_model_mask] = ...
        change_mask_parameters_ETA_TWAICE_cell_model(test_table_simulation_X,...
        virtual_battery_tester_mask,eta_cell_model_mask)
% This function overwrites the values in the TWAICE ETA Cell model mask
% with the values entered in the Testing Table for the automated simulation
% with the virtual battery tester
%
% Inputs:
%       - testing table of simulation X
%       - mask of the virtual battery tester
%       - mask of the eta cell model initial parameters
%
% Outputs:
%       - updated mask of the virtual battery tester
%       - updated mask of the eta cell model initial parameters
% Copyright 2022-2023 TWAICE Technologies GmbH, Munich, Germany   
%%
names_vbt_mask = {};
for i = 1:length(virtual_battery_tester_mask.Parameters)
    names_vbt_mask{i,1} = virtual_battery_tester_mask.Parameters(i).Name;
end
%-------------------------------------------------------------------------------------------%
% Charge
if strcmp(test_table_simulation_X.charge_type, 'Current / A')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_current_ch'))).Value = 'on';  %Turn Current Trigger on
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_power_ch'))).Value = 'off'; %Turn Power Trigger off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_profile_ch'))).Value = num2str(test_table_simulation_X.charge_type_value);
elseif strcmp(test_table_simulation_X.charge_type, 'Power / W')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_current_ch'))).Value = 'off';  %Turn Current Trigger off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_power_ch'))).Value = 'on'; %Turn Power Trigger on  
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_profile_ch'))).Value = num2str(test_table_simulation_X.charge_type_value);
end  
% Pause after charge
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
    'value_charge_pause'))).Value = num2str(test_table_simulation_X.charge_pause);

%-------------------------------------------------------------------------------------------%
% Discharge
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'discharge_type'))).Value = virtual_battery_tester_mask.Parameters(1,...
        find(contains(names_vbt_mask,'discharge_type'))).TypeOptions{1,1};  ...
        % Set discharge to constant instead of timeseries
if strcmp(test_table_simulation_X.discharge_type, 'Current / A')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_current_dis'))).Value = 'on';  %Turn Current Trigger on
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_power_dis'))).Value = 'off'; %Turn Power Trigger off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_profile_dis'))).Value = num2str(test_table_simulation_X.discharge_type_value);
elseif strcmp(test_table_simulation_X.discharge_type, 'Power / W')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_current_dis'))).Value = 'off';  %Turn Current Trigger off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_power_dis'))).Value = 'on'; %Turn Power Trigger on  
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_profile_dis'))).Value = num2str(test_table_simulation_X.discharge_type_value);
end 
% Pause after discharge
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
    'value_discharge_pause'))).Value = num2str(test_table_simulation_X.discharge_pause);

%-------------------------------------------------------------------------------------------%
% Cycle Depth Stop Discharge
if strcmp(test_table_simulation_X.discharge_stop, 'Voltage / V')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_dis_U'))).Value = 'on';  %Turn Voltage Tick Box on
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_dis_soc'))).Value = 'off'; %Turn SOC Tick Box off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_depth_dis_U'))).Value = num2str(test_table_simulation_X.discharge_stop_value);
elseif contains(test_table_simulation_X.charge_stop, 'SOC / ')
    if test_table_simulation_X.discharge_stop_value > 1 || test_table_simulation_X.discharge_stop_value < 0
        error('SOC criteria charging must be defined between 0 to 1')
    end
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_dis_U'))).Value = 'off';  %Turn Voltage Tick Box off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_dis_soc'))).Value = 'on'; %Turn SOC Tick Box on   
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_depth_dis_soc'))).Value = num2str(test_table_simulation_X.discharge_stop_value);
end

% CV Phase Discharging
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
    'trigger_cv_discharge'))).Value = test_table_simulation_X.discharge_cv_trigger;
if strcmp(test_table_simulation_X.discharge_cv_trigger, 'on')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_cv_discharge_stop'))).Value = num2str(test_table_simulation_X.discharge_cv_cutoff_I);
else
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_cv_discharge_stop'))).Value = num2str(0);
end

%-------------------------------------------------------------------------------------------%
% Cycle Depth Stop Charge
if strcmp(test_table_simulation_X.charge_stop, 'Voltage / V')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_ch_U'))).Value = 'on';  %Turn Voltage Tick Box on
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_ch_soc'))).Value = 'off'; %Turn SOC Tick Box off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_depth_ch_U'))).Value = num2str(test_table_simulation_X.charge_stop_value);
elseif contains(test_table_simulation_X.charge_stop, 'SOC / ')
    if test_table_simulation_X.charge_stop_value > 1 || test_table_simulation_X.charge_stop_value < 0
        error('SOC criteria charging must be defined between 0 to 1')
    end
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_ch_U'))).Value = 'off';  %Turn Voltage Tick Box off
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_depth_ch_soc'))).Value = 'on'; %Turn SOC Tick Box on   
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_depth_ch_soc'))).Value = num2str(test_table_simulation_X.charge_stop_value);
end

% CV Phase Charging
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
    'trigger_cv_charge'))).Value = test_table_simulation_X.charge_cv_trigger;
if strcmp(test_table_simulation_X.charge_cv_trigger, 'on')
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_cv_charge_stop'))).Value = num2str(test_table_simulation_X.charge_cv_cutoff_I);
else
    virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'value_cv_charge_stop'))).Value = num2str(0);
end

%-------------------------------------------------------------------------------------------%
% Pre-Charge for resting after cycling
% Placeholder release model v8.1.1 included in Automation Script
% In v7 turn pre-charge for resting off
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,...
        'trigger_custom_part_resting'))).Value = 'off';  % Turn Enable resting after cycling off


%-------------------------------------------------------------------------------------------%
% Ambient Temperature
virtual_battery_tester_mask.Parameters(1, find(contains(names_vbt_mask,... 
    'T_amb_set'))).Value = num2str(test_table_simulation_X.T_amb);
eta_cell_model_mask.Parameters(1, 3).Value = num2str(test_table_simulation_X.T_amb);

%-------------------------------------------------------------------------------------------%
% Stop Condition
stop_condition = test_table_simulation_X.stop_condition;
inx_stop_cyc_gen = find(contains(names_vbt_mask,'stop_parameter'));
inx_stop_cyc_gen = inx_stop_cyc_gen(1);
if contains(stop_condition, 'SOHc /')    
    virtual_battery_tester_mask.Parameters(1,inx_stop_cyc_gen).Value = ...
        virtual_battery_tester_mask.Parameters(1,inx_stop_cyc_gen).TypeOptions{4,1};
else
    virtual_battery_tester_mask.Parameters(1,inx_stop_cyc_gen).Value = ...
        char(test_table_simulation_X.stop_condition);
end
inx_stopvalue_cyc_gen = find(contains(names_vbt_mask,'stop_value'));
inx_stopvalue_cyc_gen = inx_stopvalue_cyc_gen(1);
virtual_battery_tester_mask.Parameters(1,inx_stopvalue_cyc_gen).Value = ...
    num2str(test_table_simulation_X.stop_value);


%-------------------------------------------------------------------------------------------%
% Initial  SOC in Cell Model Mask (only if it is a SOC based charge criteria)
if contains(test_table_simulation_X.charge_stop, 'SOC / ')
    eta_cell_model_mask.Parameters(1, 4).Value = num2str(test_table_simulation_X.charge_stop_value);
end

%-------------------------------------------------------------------------------------------%
% Set Enable Resting SOC tickbox to off
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'trigger_custom_part_resting'))).Value = 'off';
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'value_repeating_cycles'))).Enabled = 'off';
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'value_resting_time'))).Enabled = 'off';
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'value_resting_soc'))).Enabled = 'off';



%-------------------------------------------------------------------------------------------%
% Use default fitted parameters for thermal settings
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'default_thermal_settings_cycgen'))).Value = 'Use default fitted parameters';   
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'value_htc_cycgen'))).Enabled = 'off';
virtual_battery_tester_mask.Parameters(1,find(contains(names_vbt_mask,...
    'value_Pcool_cycgen'))).Enabled = 'off';
    
end