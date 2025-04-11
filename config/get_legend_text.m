function[legend_text,file_name_save] = get_legend_text(testing_table)
%% extracts the stress condition in format to be printed in legend

if strcmp(testing_table.charge_type, 'Power / W')
    unit_charge = 'W';
else
    unit_charge = 'A';
end

if strcmp(testing_table.discharge_type, 'Power / W')
    unit_discharge = 'W';
else
    unit_discharge = 'A';
end

if strcmp(testing_table.charge_stop, 'Voltage / V')
    charge_stop_type = 'V';
else
    charge_stop_type = 'SOC';
    testing_table.charge_stop_value = 100 * testing_table.charge_stop_value;
end

if strcmp(testing_table.discharge_stop, 'Voltage / V')
    discharge_stop_type = 'V';
else
    discharge_stop_type = 'SOC';
    testing_table.discharge_stop_value = 100*testing_table.discharge_stop_value;
end

%%
legend_text = strcat(['Sim',sprintf('%03d', testing_table.simulation_number) ': ',...
    num2str(testing_table.T_amb), 'degC, ',...
    num2str(testing_table.discharge_stop_value),discharge_stop_type, ' to '...
    num2str(testing_table.charge_stop_value),charge_stop_type, ', '...
    num2str(testing_table.discharge_type_value), unit_discharge, ' discharge, ',...
    num2str(testing_table.charge_type_value), unit_charge, ' charge'
    ]);

file_name_save = strcat(['Sim',sprintf('%03d', testing_table.simulation_number) '_',...
    num2str(testing_table.T_amb), 'degC_',...
    num2str(testing_table.discharge_stop_value),discharge_stop_type, '_to_'...
    num2str(testing_table.charge_stop_value),charge_stop_type, '_'...
    num2str(testing_table.discharge_type_value), unit_discharge, '_discharge_',...
    num2str(testing_table.charge_type_value), unit_charge, '_charge'
    ]);

end