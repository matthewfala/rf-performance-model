function nf = att_nf(chain, g, att_indx, default_indexed_comps, splitter)
    split_att = splitter(g, default_indexed_comps);
    for i = 1:length(att_indx)
        chain(att_indx(i)).gain = g*split_att(i);
        chain(att_indx(i)).nf = abs(chain(att_indx(i)).gain);
%         disp('gain');
%         disp(chain(att_indx(i)).gain);
%         disp('nf');
%         disp(chain(att_indx(i)).nf);
    end 
    my_chain_info = chain_info(chain);
    [nf, iip3, ip1db, powercap] = deal(my_chain_info{:}); 
end