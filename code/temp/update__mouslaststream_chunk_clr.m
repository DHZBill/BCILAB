mouslaststream_range = 1+mod(mouslaststream.smax:mouslaststream.smax+size(mouslaststream_chunk_clr,2)-1,mouslaststream.buffer_len);
mouslaststream.marker_pos(:,mouslaststream_range) = 0;
mouslaststream.buffer(:,mouslaststream_range) = mouslaststream_chunk_clr;
mouslaststream.smax = mouslaststream.smax + size(mouslaststream_chunk_clr,2);