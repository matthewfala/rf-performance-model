%Settings
EXTRA_LOSS = 0.5;

%Component List
comp_index = 1;

% Template
% Temp
comp(comp_index).pn = 'TMP';
comp(comp_index).desc = 'TMP';
comp(comp_index).gain = 0;
comp(comp_index).nf = 0;
comp(comp_index).oip3 = 0;
comp(comp_index).iip3 = [];%
comp(comp_index).op1db = -EXTRA_LOSS; % Choose 1 p1db
comp(comp_index).ip1db = []; % 
comp_index = comp_index + 1;

% PCB Extra Insertion Loss
comp(comp_index).pn = 'PCB';
comp(comp_index).desc = 'pcb';
comp(comp_index).gain = -0.5;
comp(comp_index).nf = [];
comp(comp_index).oip3 = 1000; % Choose 1 ip3
comp(comp_index).iip3 = 1000;%
comp(comp_index).op1db = 1000; % Choose 1 p1db
comp(comp_index).ip1db = 1000; % 
comp_index = comp_index + 1;

% PadTestdB
comp(comp_index).pn = 'PadTestdB';
comp(comp_index).desc = 'PadTestdB';
comp(comp_index).gain = -0.001;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Combine IQ 
comp(comp_index).pn = 'Combine_IQ';
comp(comp_index).desc = 'COMB_IQ';
comp(comp_index).gain = 3;
comp(comp_index).nf = 0;
comp(comp_index).oip3 = 1000; % Choose 1 ip3
comp(comp_index).iip3 = 1000; %
comp(comp_index).op1db = 1000; % Choose 1 p1db
comp(comp_index).ip1db = 1000; % 
comp_index = comp_index + 1;

% Part3
comp(comp_index).pn = 'P3';
comp(comp_index).desc = 'Part3';
comp(comp_index).gain = 14;
comp(comp_index).nf = 3;
comp(comp_index).oip3 = 40;
comp(comp_index).iip3 = [];
comp(comp_index).op1db = 22;
comp_index = comp_index + 1;

% Part2
comp(comp_index).pn = 'P2';
comp(comp_index).desc = 'Part2';
comp(comp_index).gain = 17;
comp(comp_index).nf = 1.8;
comp(comp_index).oip3 = 26;
comp(comp_index).iip3 = [];
comp(comp_index).op1db = 11.5;
comp_index = comp_index + 1;

% Part5
comp(comp_index).pn = 'P5';
comp(comp_index).desc = 'Part5';
comp(comp_index).gain = 0;  % -3;
comp(comp_index).nf = 11;
comp(comp_index).oip3 = 49; %37;
comp(comp_index).iip3 = [];
comp(comp_index).op1db = 50; %13.5;
comp_index = comp_index + 1;

% Part6
comp(comp_index).pn = 'P6';
comp(comp_index).desc = 'Part6';
comp(comp_index).gain = 0;  % -3;
comp(comp_index).nf = 6.5;
comp(comp_index).oip3 = 49; %37;
comp(comp_index).iip3 = [];
comp(comp_index).op1db = 19.5; %13.5;
comp_index = comp_index + 1;


% Halfer
comp(comp_index).pn = 'Halfer';
comp(comp_index).desc = 'Halfer';
comp(comp_index).gain = -3;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Halfer - EP2C
comp(comp_index).pn = 'EP2C';
comp(comp_index).desc = 'EP2C';
comp(comp_index).gain = -4.1;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Part1
comp(comp_index).pn = 'P1';
comp(comp_index).desc = 'Part1';
comp(comp_index).gain = -0.75;  % Minimum % Check this
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 55;
comp(comp_index).ip1db = 28; % input power!!!
comp_index = comp_index + 1;

% Part4
comp(comp_index).pn = 'P4';
comp(comp_index).desc = 'Part4';
comp(comp_index).gain = 5.8;
comp(comp_index).nf = 15; % 11.6;
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 20; % 27;
comp(comp_index).op1db = 11.6;
comp_index = comp_index + 1;

% Part7
comp(comp_index).pn = 'P7';
comp(comp_index).desc = 'Part7';
comp(comp_index).gain = 0;
comp(comp_index).nf = 31;
comp(comp_index).oip3 = 55;
comp(comp_index).iip3 = [];
%comp(comp_index).op1db = 10;
comp(comp_index).op1db = 13;
comp_index = comp_index + 1;


% Attenuators
 % removed components ...

% Mixers
 % removed components ...

% Amplifiers
 % removed components ...

%ADC
 % removed components ...


% Pads
% Pad0dB
comp(comp_index).pn = 'Pad0dB';
comp(comp_index).desc = 'Pad0dB';
comp(comp_index).gain = -0.001;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad1dB
comp(comp_index).pn = 'Pad1dB';
comp(comp_index).desc = 'Pad1dB';
comp(comp_index).gain = -1;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad2dB
comp(comp_index).pn = 'Pad2dB';
comp(comp_index).desc = 'Pad2dB';
comp(comp_index).gain = -2;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad3dB
comp(comp_index).pn = 'Pad3dB';
comp(comp_index).desc = 'Pad3dB';
comp(comp_index).gain = -3;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad4dB
comp(comp_index).pn = 'Pad4dB';
comp(comp_index).desc = 'Pad4dB';
comp(comp_index).gain = -4;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad5dB
comp(comp_index).pn = 'Pad5dB';
comp(comp_index).desc = 'Pad5dB';
comp(comp_index).gain = -5;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad6dB
comp(comp_index).pn = 'Pad6dB';
comp(comp_index).desc = 'Pad6dB';
comp(comp_index).gain = -6;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad7dB
comp(comp_index).pn = 'Pad7dB';
comp(comp_index).desc = 'Pad7dB';
comp(comp_index).gain = -7;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

%Pad8dB
comp(comp_index).pn = 'Pad8dB';
comp(comp_index).desc = 'Pad8dB';
comp(comp_index).gain = -8;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad9dB
comp(comp_index).pn = 'Pad9dB';
comp(comp_index).desc = 'Pad9dB';
comp(comp_index).gain = -9;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad10dB
comp(comp_index).pn = 'Pad10dB';
comp(comp_index).desc = 'Pad10dB';
comp(comp_index).gain = -10;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad11dB
comp(comp_index).pn = 'Pad11dB';
comp(comp_index).desc = 'Pad11dB';
comp(comp_index).gain = -11;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad12dB
comp(comp_index).pn = 'Pad12dB';
comp(comp_index).desc = 'Pad12dB';
comp(comp_index).gain = -12;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad13dB
comp(comp_index).pn = 'Pad13dB';
comp(comp_index).desc = 'Pad13dB';
comp(comp_index).gain = -13;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad14dB
comp(comp_index).pn = 'Pad14dB';
comp(comp_index).desc = 'Pad14dB';
comp(comp_index).gain = -14;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad15dB
comp(comp_index).pn = 'Pad15dB';
comp(comp_index).desc = 'Pad15dB';
comp(comp_index).gain = -15;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad16dB
comp(comp_index).pn = 'Pad16dB';
comp(comp_index).desc = 'Pad16dB';
comp(comp_index).gain = -16;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad17dB
comp(comp_index).pn = 'Pad17dB';
comp(comp_index).desc = 'Pad17dB';
comp(comp_index).gain = -17;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad18dB
comp(comp_index).pn = 'Pad18dB';
comp(comp_index).desc = 'Pad18dB';
comp(comp_index).gain = -18;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad19dB
comp(comp_index).pn = 'Pad19dB';
comp(comp_index).desc = 'Pad19dB';
comp(comp_index).gain = -19;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad20dB
comp(comp_index).pn = 'Pad20dB';
comp(comp_index).desc = 'Pad20dB';
comp(comp_index).gain = -20;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;

% Pad37dB
comp(comp_index).pn = 'Pad37dB';
comp(comp_index).desc = 'Pad37dB';
comp(comp_index).gain = -37;  % Minimum 
comp(comp_index).nf = [];
comp(comp_index).oip3 = [];
comp(comp_index).iip3 = 1000;
comp(comp_index).ip1db = 1000; % Used max input power!!! (change with gain change)
comp_index = comp_index + 1;
