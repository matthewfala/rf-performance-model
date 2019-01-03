% Returns input P1dB of the supplied chain
% To get values use:
% my_chain_info = chain_info(sch_comp);
% [nf, iip3, ip1db, powercap] = deal(my_chain_info{:}); 

function my_chain_info = chain_info(sch_comp)
    global PAPR;
    global output_evm_cap;
    
    % add components to list and rfchain
    rfch = rfchain();
    for n = 1:length(sch_comp)
        addstage(rfch, sch_comp(n).gain, sch_comp(n).nf, sch_comp(n).oip3, 'Name', sch_comp(n).desc);
    end
    
    % determine IIP3
    tmp_iip3 = cumiip3(rfch);
    pt_iip3 = tmp_iip3(end);
    
    % determine nf
    tmp_nf = cumnoisefig(rfch);
    pt_nf = tmp_nf(end);
    
    % gain
    g = cumgain(rfch);
    gains(length(sch_comp)) = 1;
    for i = 1:length(sch_comp)
        gains(i) = sch_comp(i).gain;
    end
    g_rat = 10.^(gains/10);
    
    % determine p1db cascade value
    tmp_p1db_mw = zeros(1, length(sch_comp));
    tmp_p1db_mw(1) = 10^(sch_comp(1).op1db/10);

    % cascade the other p1db values (mW)
    for p = 2:length(sch_comp)
        component_p1db_mw = 10^(sch_comp(p).op1db/10);
        tmp_p1db_mw(p) = 1/((1/(tmp_p1db_mw(p-1)*g_rat(p)) + 1/(component_p1db_mw)));
    end

    % p1db for cascade
    tmp_p1db_out = 10*log10(tmp_p1db_mw);
    tmp_p1db_in = tmp_p1db_out - (g - 1);

    % system values
    pt_p1db = tmp_p1db_in(end);
    
    % find power limit
    iip3_limit = -output_evm_cap/2 + pt_iip3; 
    p1db_limit = (pt_p1db + 1) - PAPR;
    
    powercap = min([iip3_limit, p1db_limit]);
    
    % compile return values
    my_chain_info = {pt_nf, pt_iip3, pt_p1db, powercap};
    
end


% Working
% Verification test
% 
% my_chain_info = chain_info(sch_comp);
% [nf, iip3, ip1db, powercap] = deal(my_chain_info{:}); 
% disp(nf);
% disp(iip3);
% disp(ip1db);
% disp(powercap);
