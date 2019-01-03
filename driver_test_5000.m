% Current Limitations
% The test process screws up the components list,
% That means target component's listing is changed when target values are
% tested...
%           so don't re-add components that have been updated!!!!


clear all;

global my_ui_table;
global txt;
global PAPR;
global output_evm_cap;

TH_NF_1HZ = - 174;
slider_start = 0;

% ########  IMPORTS  ########

file = fullfile('components.m');
run('components');

%file = fullfile('x_splitter_functions.m');
%run('x_splitter_functions');

splitter_functions = x_splitter_functions();

% ######## SETTINGS #########

% general
bandwidth = 10e6;
output_evm_cap = 50;
TH_NF = TH_NF_1HZ + 10*log10(bandwidth);
PAPR = 8;

% target alteration settings
test_mode = 'Gain'; % options -> NoiseFigure, Gain, OIP3, IIP3
test_field = 'gain'; % options -> nf, gain, oip3, iip3
test_target_indices =  []; %[1, 8]; %[13]; %[1,5];  % indices of altered components
test_splitter_function = splitter_functions{1};  % choose from x_splitter_functions file

% attenuator index hack
num_atten = 2;
atten_name = 'Part1';

pad_on = true;
pad_val = -0;
pad_indx = 15;

% pad optimization parabolic
opt_pad_indx = [21];
opt_pad_range = [0; -20];
target_nf = 7;

% component alteration range
test_range_mode = 'auto-start'; % options -> auto-start, manual
test_range_start = [];
test_range_end = -44;
test_step = 4;

% x-axis power range
dbm_range_min = -100; %TH_NF;
dbm_range_max = 40;
dbm_range_step = 0.05;

% invert graph (true or false)
invert_graph = true;
multiple_figures = true;

board_direction = 'rx';
if isequal(board_direction, 'tx')
    'Test mode, TX';
    graph_mode = 'output_pw'; % options -> 'input_pw' 'output_pw'
    opt_mode = 'dyn_range';  % options -> 'dyn_range' or 'fixed_nf'
    test_splitter_function = splitter_functions{3};
elseif isequal(board_direction, 'rx')
    'Test mode, RX';
    graph_mode = 'input_pw';
    opt_mode = 'fixed_nf';
    test_splitter_function = splitter_functions{1};
end


% ########  BOARD LAYOUTS  #########  
% BOARD To Send To Qualcom
WJX_RX_2011_Recieve = {'Part1', 'PCB', 'Part2', 'PCB', 'Part1', 'PCB', 'Part3', ...
    'PCB', 'Part4', 'Halfer', 'Part5', 'Part6', 'Part7', 'COMB_IQ'};
% ...

board_mode = 'off'; % for pad opt
opt_pad_test = false;
opt_pad_indx = [16, 24];
opt_pad_range = [0, 0 ;-2, -10];

sch = WJX_RX_2011_Recieve

% atten indice hack
att_find_ind = 1;
for i = 1:length(sch)
    if strcmp(sch(i), atten_name) && att_find_ind <= num_atten
        test_target_indices(att_find_ind) = i;
        att_find_ind = att_find_ind + 1;
    end
end
%disp(test_target_indices);

% Flip board and att indices if TX
if board_direction == 'tx'
    sch = flip(sch);
    for i = 1:length(test_target_indices)
        test_target_indices(i) = length(sch)-(test_target_indices(i)-1);
    end
    for i = 1:length(opt_pad_indx)
        opt_pad_indx(i) = length(sch)-(opt_pad_indx(i)-1);
    end
elseif board_direction == 'rx'
end

display(opt_pad_indx, 'opt pad ind');

% ########  CODE  #########

% auto find range start
if strcmp(test_range_mode, 'auto-start')
    test_range_start = 0;
    for i = 1:length(test_target_indices) % sum of components default x
        % get component
        for j = 1:length(comp)
           if strcmp(comp(j).pn,sch(test_target_indices(i))) || ...
                   strcmp(comp(j).desc,sch(test_target_indices(i)))
               default_indexed_comps(i) = comp(j);
           end
        end
        test_range_start = test_range_start + ...
            getfield(default_indexed_comps(i), test_field); %default
    end
end

% fix range step polarity
if test_range_end < test_range_start
    test_step = -1*test_step;
end

% alteration test values
x = test_range_start:test_step:test_range_end;

% input X-Axis power
dbm = dbm_range_min:dbm_range_step:dbm_range_max;

% complete the data
for n = 1:length(comp)

    % nf from gain
    if comp(n).gain < 0
        comp(n).nf = -comp(n).gain;
    end

    % i <-> o IP3 conversion
    if isempty(comp(n).oip3)
        comp(n).oip3 = comp(n).iip3 + comp(n).gain;
        comp(n).default = 'iip3';
    elseif isempty(comp(n).iip3)
        comp(n).iip3 = comp(n).oip3 - comp(n).gain;
        comp(n).default = 'oip3';
    end

    % i <-> o P1dB conversion
    if isempty(comp(n).op1db)
        comp(n).op1db = comp(n).ip1db + (comp(n).gain - 1);
        comp(n).p1db_default = 'ip1db';
    elseif isempty(comp(n).ip1db)
        comp(n).ip1db = comp(n).op1db - (comp(n).gain - 1);
        comp(n).p1db_default = 'op1db';
    end
end

% add components to list
sch_comp(length(sch)) = comp(1);  % init sch_comp


% add components to list and rfchain
rfch = rfchain();
for n = 1:length(sch)
    name = sch(n);
    for m = 1:length(comp)
        if (strcmp(comp(m).pn, name) || strcmp(comp(m).desc, name))
            sch_comp(n) = comp(m);
            addstage(rfch, comp(m).gain, comp(m).nf, comp(m).oip3, 'Name', comp(m).desc);
        end
    end
end

% % sch_comp_default = sch_comp;
% if opt_pad_test
%     sch_comp = component_optimizer(sch_comp, x, opt_pad_indx, ...
%         opt_pad_range, test_splitter_function, test_target_indices, ...
%         default_indexed_comps, 1);
% end

sch_comp_default = sch_comp;

% component alteration hacks ####################
% if pad_on == true
%     sch_comp(pad_indx).gain = pad_val;
%     sch_comp(pad_indx).nf = abs(pad_val);
% end

nf = x;
oip3 = x;
iip3 = x;

% data structures to calc evm
EVM = zeros(length(x), length(dbm));
nf_dist = zeros(length(x), length(dbm));
third_harm_dist = zeros(length(x), length(dbm));
p1db_caps = zeros(1, length(x));

% data structures for slider
all_component_gain = zeros(length(x), length(sch));
all_cumu_gain = zeros(length(x), length(sch));
all_p1db_in = zeros(length(x), length(sch));
all_iip3 = zeros(length(x), length(sch));
all_nf = zeros(length(x), length(sch));

%EVM(:,1) = x';

data_index = 1;

x_index = 1;
for x_step = x
    % alter components based on x and test_mode
    if exist('default_indexed_comps', 'var') == 1
        x_splitted = x_step*test_splitter_function(x_step, default_indexed_comps);
    end
    
    for altered_comp_index = 1:length(test_target_indices)
        mecomponent = test_target_indices(altered_comp_index);
        n = x_splitted(altered_comp_index);
        
        % update data structure component
        % gain
        if strcmp(test_mode, 'Gain')
            sch_comp(mecomponent).gain = n;
            if strcmp(sch_comp(mecomponent).default, 'oip3')
                sch_comp(mecomponent).iip3 = sch_comp(mecomponent).oip3 - sch_comp(mecomponent).gain;  % change to gain_cor on final
            end
            if strcmp(sch_comp(mecomponent).default, 'iip3')
                sch_comp(mecomponent).oip3 = sch_comp(mecomponent).iip3 + sch_comp(mecomponent).gain;  % change to gain_cor on final
            end 
            if sch_comp(mecomponent).gain < 0
                sch_comp(mecomponent).nf = -sch_comp(mecomponent).gain;
            end  
        end

        % oip3
        if strcmp(test_mode, 'OIP3')
            sch_comp(mecomponent).default = 'oip3';
            sch_comp(mecomponent).oip3 = n;
            sch_comp(mecomponent).iip3 = sch_comp(mecomponent).oip3 - sch_comp(mecomponent).gain;  % change to gain_cor on final
        end

        % iip3
        if strcmp(test_mode, 'IIP3')
            sch_comp(mecomponent).default = 'iip3';
            sch_comp(mecomponent).iip3 = n;
            sch_comp(mecomponent).oip3 = sch_comp(mecomponent).iip3 + sch_comp(mecomponent).gain;  % change to gain_cor on final
        end

        % nf
        if strcmp(test_mode, 'NoiseFigure')
            sch_comp(mecomponent).nf = n;
            % does not change anything if gain_cor is less than 0
            if sch_comp(mecomponent).gain < 0
                sch_comp(mecomponent).nf = -sch_comp(mecomponent).gain;
            end  
        end
    
        % update cascade target stage
        setstage(rfch, mecomponent, sch_comp(mecomponent).gain,sch_comp(mecomponent).nf, sch_comp(mecomponent).oip3);
        
    end
    
    % get a list of gains
    gains(length(sch_comp)) = 1;
    for i = 1:length(sch_comp)
        gains(i) = sch_comp(i).gain;
    end
    all_component_gain(x_index, :) = gains;

    % determine cascaded values & store
    g = cumgain(rfch);
    all_cumu_gain(x_index, :) = g;
    g_rat = 10.^(gains/10);

    tmp_nf = cumnoisefig(rfch);
    all_nf(x_index, :) = tmp_nf;

    tmp_oip3 = cumoip3(rfch);
    tmp_iip3 = cumiip3(rfch);
    all_iip3(x_index, :) = tmp_iip3;

    % determine p1db cascade value
    tmp_p1db_mw = zeros(1, length(sch));
    tmp_p1db_mw(1) = 10^(sch_comp(1).op1db/10);

    % cascade the other p1db values (mW)
    for p = 2:length(sch)
        component_p1db_mw = 10^(sch_comp(p).op1db/10);
        tmp_p1db_mw(p) = 1/((1/(tmp_p1db_mw(p-1)*g_rat(p)) + 1/(component_p1db_mw)));
    end

    % p1db for cascade
    tmp_p1db_out = 10*log10(tmp_p1db_mw);
    tmp_p1db_in = tmp_p1db_out - (g - 1);
    all_p1db_in(x_index, :) = tmp_p1db_in;

    % system values
    pt_nf = tmp_nf(end);
    pt_nfloor = TH_NF + pt_nf;
    pt_oip3 = tmp_oip3(end);
    pt_iip3 = tmp_iip3(end);
    pt_p1db = tmp_p1db_in(end);

    % get nf and third_harm caps
    dist_nf_full(x_index, :) = dbm - pt_nfloor;
    dist_nf(x_index, :) = max(dist_nf_full(x_index, :), 0);

    % (3*dbm - 2*pt_iip3) is the third harm
    dist_third_harm(x_index, :) = dbm - (3*dbm - 2*pt_iip3);
    dist_third_harm(x_index, :) = max(dist_third_harm(x_index, :), 0);
    p1db_caps(x_index) = pt_p1db;
    
    right_iip3_limit(x_index) = -output_evm_cap/2 + pt_iip3; 

    x_index = x_index+1;
end

% calculations
iip3_per_nf = 5;
range = iip3 - nf;
score = iip3 - 5*nf;
p1db = 1:length(dbm);
output_evm_cap_vector(1:length(dbm)) = output_evm_cap;

% Find min of nf_dist third_harm_dist p1db_caps
for m = 1:length(x)
    right_limit(m) = (p1db_caps(m) + 1) - PAPR;
    right_base_limit(m) = min([right_iip3_limit(m), right_limit(m)]);
    %right_base_limit(m) = 0; % above 0;
    for n = 1:length(EVM)
        EVM(m, n) = (-1)^invert_graph * min([dist_nf(m, n), dist_third_harm(m, n), output_evm_cap_vector(n)]);

        % dbm cap
        if dbm(n) > right_limit(m) % add 1 for hard limit (-10 for p1db)
            EVM(m, n) = 0;
        end
    end
end

% Find Component Output Noise Floor
comp_out_noise_floor = TH_NF_1HZ + (tmp_nf + g);

% ################## UI ###################
% figure
if multiple_figures 
    figure('Name','Cascade Component Test','NumberTitle','off')
end
clf;

% font size
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 12);

% plot
subplot(2,1,1);

component_names = '';
for i = 1:length(test_target_indices)
    component_names = [component_names sch_comp(test_target_indices(i)).pn ' and ']; 
end
% remove last and
component_names = component_names(1:end-5);

title(sprintf('%s Testing For Component(s) %s', test_mode, component_names));
hold on

if isequal(graph_mode, 'input_pw')
    xlabel('RF Input Power (dBm)') % x-axis label
elseif isequal(graph_mode, 'output_pw')
    xlabel('RF Output Power (dBm)') 
end

ylabel('EVM(dBm)') % y-axis label

for x_index = 1:length(x)
    x_value = x(x_index);
    if isequal(graph_mode, 'input_pw')
        plot(dbm,EVM(x_index, :),'DisplayName', sprintf('%s=%.3f', test_field, x_value))
    elseif isequal(graph_mode, 'output_pw')
        plot(dbm+all_cumu_gain(x_index, end),EVM(x_index, :),'DisplayName', sprintf('%s=%.3f', test_field, x_value))
    end
    grid on;
end

legend('Location','southeast')

% create the table
% title
if_split = '';
if length(test_target_indices) > 1
   if_split = 'Split'; 
end

% table
dummy_source.Value = slider_start;
ui_surf_x(dummy_source, [], test_range_start, test_mode, ...
    test_step, TH_NF_1HZ, sch, component_names, all_component_gain, all_cumu_gain, ...
    all_p1db_in, all_iip3, all_nf, right_limit, right_base_limit)

% create event driven slider
sld_x = 0.6;
sld_width = 0.3;
sld_y = 0.04;

% ticks
num_ticks = length(x);

for i = 1:num_ticks
    sld_box_x = 0.02;
    tk_space_width = sld_width - sld_box_x;
    tk_start_x = sld_x + sld_box_x/2;
    
    tick_x = tk_start_x + i*tk_space_width/num_ticks - tk_space_width/(2*num_ticks);
    uicontrol('Style','text', 'Units', 'Normalized', ...
        'Position',[tick_x, sld_y, .001, .012],...
        'FontWeight', 'bold', 'String', '|');
end

% slider
max_val = floor(abs((test_range_start - test_range_end)/test_step));
sld = uicontrol('Style', 'slider',...
    'Min',0,'Max',max_val, 'Units', 'normal', 'Value', slider_start,...
    'Position', [sld_x sld_y + 0.01 sld_width .05],...
    'Callback', {@ui_surf_x, test_range_start, test_mode, ...
    test_step, TH_NF_1HZ, sch, component_names, all_component_gain, all_cumu_gain, ...
    all_p1db_in, all_iip3, all_nf, right_limit, right_base_limit}); 

hold off
display('hi');

%myatt_chain = att_optimizer(sch_comp, target_nf, test_target_indices, default_indexed_comps, x, test_splitter_function);

if opt_pad_test
 mybest_chain = component_optimizer(sch_comp, opt_mode, x, opt_pad_indx, ...
      opt_pad_range, test_splitter_function, test_target_indices, ...
      default_indexed_comps, 1);
end


% % 
% % Test for optimal pad
% 
% if opt_pad_test == true
%     optimum_comps = component_optimizer(sch_comp, opt_pad_indx, opt_pad_range);
% end
% 
% disp optimum_comps;
% 
