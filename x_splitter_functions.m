%###### SPLITTER FUNCTIONS ########
% Below are a list of general
% purpose functions to split
% total component alteration (x)
% amongst several components
%
% Each function should return
% an array with a length
% matching the number of 
% components whose values
% are to be incrementally altered
%
% Example: return [0.4, 0.6]
%     ~ This will pipe 40%
%       of x to the first indiced
%       component and 60% to the
%       second
%
% Example: return [.1, .6, .3]
%     ~ This will pipe x to 
%       3 indiced components
%
% Note: return array values
%       should add up to 1
%

function splitters = x_splitter_functions
    %dictionary 
    splitters{2} = @splitter_2;
    splitters{1} = @splitter_1;
    splitters{3} = @splitter_3;
    splitters{4} = @splitter_4;
    
    
    % The Hao Splitter
    % Supports 2 component indices
    function divs = splitter_1(gain, default_indexed_comps)
        % Low ADL 16.5 works best
        % 9.5 HMC -21.5 is optimal
        dBm_overflowto_comp1_after = 16.5;
        max_gain = 32;
        if (abs(gain) <= abs(max_gain + dBm_overflowto_comp1_after)) 
            if length(default_indexed_comps) == 2
                % Overflows into first indexed component
                % after second reaches the below value
                
                comp1gain = default_indexed_comps(1).gain;
                comp2gain = default_indexed_comps(2).gain;

                gain_comp2_before_overflow = gain - comp1gain;
                if (abs(gain_comp2_before_overflow) <= dBm_overflowto_comp1_after)
                    val1 = abs(comp1gain)/abs(gain);
                    val2 = 1 - val1;
                else 
                    val2 = (dBm_overflowto_comp1_after)/abs(gain);
                    val1 = 1 - val2;
                end

                divs = [val1, val2];
            else
                disp('ERROR: Hao splitter should only be used with 2 target indices');
                disp(default_indexed_comps);
            end
        else
            val1 = abs(max_gain/gain);
            val2 = 1 - val1;
            divs = [val1, val2];
        end
    end

    % Supports 1 component indices
    function divs = splitter_2(gain, default_indexed_comps)
        divs = [1];
    end

    % Supports 1 component indices
    function divs = splitter_3(gain, default_indexed_comps)
        divs = [0,1];
    end

    % Supports no indices
    function divs = splitter_4(gain, default_indexed_comps)
        divs = [];
    end



end

%>> fun = myfun2();
%>> y = fun{2}(t) % evaluates the second function