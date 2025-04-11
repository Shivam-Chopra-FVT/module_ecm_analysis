function output_str = fin_convert(input_str)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz^<>{}\"/|;:.,~!?@#$%^=&*]()[-_+';


for i=1:length(input_str)  
    output_str(i,1) = strfind(chars,input_str(i));
end