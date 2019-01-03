function best_chain = component_optimizer(chain, mode, x, opt_indxs, ...
    opt_ranges_gain, test_splitter_function, att_indices, ...
    att_default_indexed_comps, level)

% disp(att_default_indexed_comps);
% mode = 'dyn_range'; % options: 'dyn_range' or 'fixed_nf'

% function settings
target_nf = 7;
acceptable_error = 0.25; % check if points settings NOT VALUES are 0.25 off. 

% target pad index
tIndx = opt_indxs(1);

% the error is the range at the moment
gain_range = opt_ranges_gain(2, 1) - opt_ranges_gain(1, 1);

% record optimal values of layer 1
log_of_optimal = [];
log_of_gain = [];

% check every pad value in range
best_val = -1000; % max
best_chain = 'None';
disp('gain range');
%disp(opt_ranges_gain(1, 1):-1:opt_ranges_gain(2, 1));

for g = opt_ranges_gain(1, 1):-1:opt_ranges_gain(2, 1)
    error = 0; 
    
    % set the pads gain
    chain(tIndx).gain = floor(g+0.5);
    if chain(tIndx).gain < 0
        chain(tIndx).nf = abs(chain(tIndx).gain);
    end
    
    % if there are other pads to test
    if length(opt_indxs) > 1
        end_opchain = component_optimizer(chain, mode, x, opt_indxs(2:end), ...
            opt_ranges_gain(:, 2:end), test_splitter_function, ...
            att_indices, att_default_indexed_comps, level+1);    
        % check if nf could be attained
        if not(isstruct(end_opchain))
            % we will catch the nf problem later. use default chain for now
            end_opchain = chain;
        end  
    else
        end_opchain = chain;
    end
    
    %display(end_opchain);
    
    % attenuator setting
    att_op_output = att_optimizer(end_opchain, mode, target_nf, att_indices, ...
        att_default_indexed_comps,  x, test_splitter_function);
    [error, final_chain] = deal(att_op_output{:});
    
    if not(error)
        
        % find the p1db and range
        my_chain_info = chain_info(final_chain);
        [nf, iip3, ip1db, powercap] = deal(my_chain_info{:});
        range = powercap - (nf - 174);
        
        % log for level one
        if level == 1
            if isequal(mode, 'fixed_nf')
                display(powercap, 'Result');
                log_of_optimal(end+1) = powercap;
                log_of_gain(end+1) = g;
            elseif isequal(mode, 'dyn_range')
                display(range, 'Result-Range');
                log_of_optimal(end+1) = range;
                log_of_gain(end+1) = g;
            end
        end
        
        % update best
        if isequal(mode, 'fixed_nf')
            if powercap > best_val
               best_val = powercap;
               best_chain = final_chain;
            end
        elseif isequal(mode, 'dyn_range')
            if range > best_val
               best_val = range;
               best_chain = final_chain;
            end
        end
            
            
    else
        % move on
        if level == 1
            disp('error');
        end
    end 
    
    if level == 1
        display(g, 'Done with gain >');
    end
end

display([log_of_optimal; log_of_gain]);

% Display best values
if level == 1
   display('Pad Values');
   for i = opt_indxs
      pad_title = strcat('PadComponent:', num2str(i));
      disp(best_chain)
      display(best_chain(i).gain, pad_title);
   end
end
   

end