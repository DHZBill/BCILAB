mou_range = 1+mod(mou.smax:mou.smax+size(mou_chunk_clr,2)-1,mou.buffer_len);
mou.marker_pos(:,mou_range) = 0;
mou.buffer(:,mou_range) = mou_chunk_clr;
mou.smax = mou.smax + size(mou_chunk_clr,2);