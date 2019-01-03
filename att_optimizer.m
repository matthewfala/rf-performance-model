% Return format: Cell array -- [error, chain] error is true or false
% mode options: 'dyn_range' or 'fixed_nf'
% Returns chain with attenuators set to produce a close to target_nf nf
% If the function is unable to do so, it returns a number instead. 

function cells = att_optimizer(chain, mode, target_nf, att_indx, default_indexed_comps,  x, splitter)
    invalid_nf_return_value = 0;
    
    % Concave down optimization
    % mode = 'dyn_range'; % options: 'dyn_range' or 'fixed_nf'
    nf_error = .05; % for determining valid nf result
    acceptable_error = 0.5; % for optimization
    %disp(x);
    error = length(x);
    
    L = 1;
    LV = optscore(chain, L);

    R = length(x);
    RV = optscore(chain, R);

    P = floor((L + R) / 2 + 0.5);
    PV = optscore(chain, P);

    i = 0;
    while error > acceptable_error
        i=i+1;
        LH = floor((L + P) / 2 + 0.5);
        LHV = optscore(chain, LH);

        RH = floor((R + P) / 2 + 0.5);
        RHV = optscore(chain, RH);

%         disp([L LH P RH R]);
%         disp([LV LHV PV RHV RV]);
%         disp(isequal([L,LH,P,RH,R], L:(L+4)));

        % peak adjustment
        if isequal([L,LH,P,RH,R], L:(L+4)) % break opperation
            break;
        elseif RHV > PV && RHV > RV % zoom on RH
            L = P;
            LV = PV;
            P = RH;
            PV = RHV;        
        elseif LHV > PV && LHV > LV % zoom on LH
            R = P;
            RV = LV;
            P = LH;
            PV = LHV; 
        elseif LV >= LHV % zoom on left border
            R = P;
            RV = PV;
            P = LH;
            PV = LHV;
        elseif RV >= RHV % zoom on right border
            L = P;
            LV = PV;
            P = RH;
            PV = RHV;
            %display('Rexp');
            
        elseif PV >= LHV && PV >= RHV % zoom on P
            L = LH;
            LV = LHV;
            R = RH;
            RV = RHV;
        else
            display('Binary_Optimize_Error');
        end
        error = error/2;
    end

    max = P;
    maxV = PV;
    if RV > PV
        max = R;
        maxV = RV;
    elseif LV > PV
        max = L;
        maxV = LV;
    end
    
    % end of the parabolic optimizer
    split_att = splitter(x(max), default_indexed_comps);
    for i = 1:length(att_indx)
        chain(att_indx(i)).gain = x(max)*split_att(i);
        chain(att_indx(i)).nf = abs(chain(att_indx(i)).gain);
    end
    
    my_chain_info = chain_info(chain);
    [nf, iip3, ip1db, powercap] = deal(my_chain_info{:}); 
    
    % if nf of the optimized chain is greater than 7 then return
    if isequal(mode, 'fixed_nf')
        if nf_error < abs(target_nf-nf);
            % chain = invalid_nf_return_value;
            o_err = 1;
        else
            o_err = 0;
        end
    elseif isequal(mode, 'dyn_range')
        o_err = 0;
    end
    
    % return values
    cells = {o_err, chain};
    
    function myoptscore = optscore(chain, loc)
%         display(att_nf(chain, x(loc), att_indx, default_indexed_comps, splitter));
        if isequal(mode, 'fixed_nf')
            myoptscore = - abs(target_nf - att_nf(chain, x(loc), att_indx, default_indexed_comps, splitter));
            %display(['optscore = ' num2str(myoptscore)]);
        elseif isequal(mode, 'dyn_range')
            myoptscore = att_range(chain, x(loc), att_indx, default_indexed_comps, splitter);
        end
    end
    
end
