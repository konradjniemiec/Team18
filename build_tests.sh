#!/bin/bash

GTEST_DIR=googletest/googletest
case `uname` in
  Linux)
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -I${GTEST_DIR} -pthread -fprofile-arcs -ftest-coverage -c ${GTEST_DIR}/src/gtest-all.cc
    ar -rv libgtest.a gtest-all.o
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage server_test.cc request.cc response.cc echo_handler.cc static_handler.cc session.cc server.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o server_test -lboost_system
    ./server_test && gcov -r server.cc
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage session_test.cc request.cc response.cc echo_handler.cc static_handler.cc session.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o session_test -lboost_system
    ./session_test && gcov -r session.cc
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage response_test.cc response.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o response_test
    ./response_test && gcov -r response.cc
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage echo_handler_test.cc echo_handler.cc response.cc request.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o echo_handler_test
    ./echo_handler_test && gcov -r echo_handler.cc
    g++ -std=c++0x -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage config_parser_test.cc config_parser.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o config_parser_test
    ./config_parser_test && gcov -r config_parser.cc;;
  Darwin)
    clang++ -std=c++11 -stdlib=libc++ -isystem ${GTEST_DIR}/include -I${GTEST_DIR} -pthread -fprofile-arcs -ftest-coverage -c ${GTEST_DIR}/src/gtest-all.cc
    ar -rv libgtest.a gtest-all.o
    clang++ -std=c++11 -stdlib=libc++ -isystem ${GTEST_DIR}/include -pthread -fprofile-arcs -ftest-coverage config_parser_test.cc config_parser.cc ${GTEST_DIR}/src/gtest_main.cc libgtest.a -o config_parser_test ;;
  *)
    echo "Unknown operating system." ;;
esac
