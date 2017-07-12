dopeStream_range = 1+mod(dopeStream.smax:dopeStream.smax+size(dopeStream_chunk_clr,2)-1,dopeStream.buffer_len);
dopeStream.marker_pos(:,dopeStream_range) = 0;
dopeStream.buffer(:,dopeStream_range) = dopeStream_chunk_clr;
dopeStream.smax = dopeStream.smax + size(dopeStream_chunk_clr,2);