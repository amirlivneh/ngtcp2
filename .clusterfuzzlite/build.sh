#!/bin/bash -eu

autoreconf -i
./configure --disable-dependency-tracking --enable-lib-only
make -j$(nproc)

$CXX $CXXFLAGS -std=c++17 -Ilib/includes -Ilib -I. -DHAVE_CONFIG_H \
     fuzz/read_write_pkt.cc -o $OUT/read_write_pkt \
     $LIB_FUZZING_ENGINE lib/.libs/libngtcp2.a

zip -j $OUT/decode_frame_seed_corpus.zip fuzz/corpus/decode_frame/*
zip -j $OUT/ksl_seed_corpus.zip fuzz/corpus/ksl/*
zip -j $OUT/read_write_pkt.zip fuzz/corpus/read_write_pkt/*
zip -j $OUT/read_write_handshake_pkt.zip fuzz/corpus/read_write_handshake_pkt/*

# cp .clusterfuzzlite/*.options $OUT/
cp fuzz/*.dict $OUT/
