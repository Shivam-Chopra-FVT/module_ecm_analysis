%% TWAICE_CI_colors
function[clr_code] = colorcode()

%% Brand
% blue500=[21 98 252]./255;       %Brand primary color(blue-500)
% bluegray700=[68 84 106]./255;   %Brand secondary color(blue-gray-700)
% gray100=[230 230 230]./255;     %Brand light color(gray-100)
dark000=[0 0 0]./255;           %Brand dark color(dark-000)
% 
% orange500=[237 137 54]./255;    %Brand warning color(orange-500)
% red500=[245 101 101]./255;      %Brand danger color(red-500)
% green500=[72 187 120]./255;     %Brand success color(green-500)

%% Definition of Colors
%Blue
blue100=[238 246 255]./255;         %blue100
blue200=[192 218 249]./255;         %blue200
blue300=[137 188 247]./255;         %blue300
blue400=[72 155 255]./255;          %blue400
blue500=[21 98 252]./255;           %blue500
blue600=[0 81 198]./255;            %blue600
blue700=[4 71 153]./255;            %blue700
blue800=[0 57 114]./255;            %blue800
blue900=[21 98 252]./255;           %blue900 

% Blue-gray
bluegray100=[247 250 252]./255;     %bluegray100
bluegray200=[237 242 247]./255;     %bluegray200
bluegray300=[226 232 240]./255;     %bluegray300
bluegray400=[203 213 224]./255;     %bluegray400 
bluegray500=[160 147 192]./255;     %bluegray500  
bluegray600=[113 128 150]./255;     %bluegray600
bluegray700=[74 85 104]./255;       %bluegray700
bluegray800=[45 55 72]./255;        %bluegray800
bluegray900=[26 32 44]./255;        %bluegray900

% Gray
gray100=[230 230 230]./255;         %gray100
gray200=[204 204 204]./255;         %gray200
gray300=[179 179 179]./255;         %gray300
gray400=[153 153 153]./255;         %gray400 
gray500=[128 128 128]./255;         %gray500  
gray600=[102 102 102]./255;         %gray600
gray700=[77 77 77]./255;            %gray700
gray800=[51 51 51]./255;            %gray800
gray900=[26 26 26]./255;            %gray900

% Green
green100=[240 255 244]./255;        %green100
green200=[198 246 213]./255;        %green200
green300=[154 230 180]./255;        %green300
green400=[104 211 145]./255;        %green400 
green500=[72 187 120]./255;         %green500  
green600=[56 161 105]./255;         %green600
green700=[47 133 90]./255;          %green700
green800=[39 103 73]./255;          %green800
green900=[34 84 61]./255;           %green900

% Red
red100=[255 245 245]./255;          %red100
red200=[254 215 215]./255;          %red200
red300=[254 178 178]./255;          %red300
red400=[252 129 129]./255;          %red400 
red500=[245 101 101]./255;          %red500  
red600=[229 62 62]./255;            %red600
red700=[197 48 48]./255;            %red700
red800=[155 44 44]./255;            %red800
red900=[116 42 42]./255;            %red900

% Orange
orange100=[255 250 240]./255;       %orange100
orange200=[254 235 200]./255;       %orange200
orange300=[251 211 141]./255;       %orange300
orange400=[246 173 85]./255;        %orange400 
orange500=[237 137 54]./255;        %orange500  
orange600=[221 107 32]./255;        %orange600
orange700=[192 86 33]./255;         %orange700
orange800=[156 66 33]./255;         %orange800
orange900=[123 52 30]./255;         %orange900

%% Define Colororder for PLots
clr_code = [blue500;    
    bluegray700;
    gray300;
    dark000;
    orange500;
    green500;
    blue700;
    bluegray500;
    gray700;
    orange700;
    green700;
    ];

end