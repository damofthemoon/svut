// Copyright 2019 Damien Pretet
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


`ifndef INFO
`define INFO(msg) \
    $display("%c[0;37mINFO:     [%g] %s%c[0m", 27, $time, msg, 27)
`endif

`ifndef SUCCESS
`define SUCCESS(msg) \
    $display("%c[0;32mSUCCESS:  [%g] %s%c[0m", 27, $time, msg, 27)
`endif

`ifndef WARNING
`define WARNING(msg) \
    $display("%c[1;33mWARNING:  [%g] %s%c[0m", 27, $time, msg, 27); \
    svut_warning = svut_warning + 1
`endif

`ifndef CRITICAL
`define CRITICAL(msg) \
    $display("%c[1;35mCRITICAL: [%g] %s%c[0m", 27, $time, msg, 27); \
    svut_critical = svut_critical + 1
`endif

`ifndef ERROR
`define ERROR(msg) \
    $display("%c[1;31mERROR:    [%g] %s%c[0m", 27, $time, msg, 27); \
    svut_error = svut_error + 1
`endif

`ifndef SVUT_SETUP
`define SVUT_SETUP \
    integer svut_warning = 0; \
    integer svut_critical = 0; \
    integer svut_error = 0; \
    integer svut_nb_test = 0; \
    integer svut_nb_test_success = 0; \
`endif

`ifndef FAIL_IF
`define FAIL_IF(exp) \
    if (exp) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_NOT
`define FAIL_IF_NOT(exp) \
    if (!exp) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_EQUAL
`define FAIL_IF_EQUAL(a,b) \
    if (a === b) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_NOT_EQUAL
`define FAIL_IF_NOT_EQUAL(a,b) \
    if (a !== b) \
        svut_error = svut_error + 1
`endif

`define UNIT_TESTS \
    task run(); \
    begin \
    $display("\n%c[0;36mINFO:     Testsuite execution started%c[0m\n", 27, 27); \

`define UNIT_TEST(TESTNAME) \
    begin : TESTNAME \
        setup(); \
        svut_error = 0; \
        svut_nb_test = svut_nb_test + 1; \

`define UNIT_TEST_END \
        #0; \
        teardown(); \
        if (svut_error == 0) begin \
            svut_nb_test_success = svut_nb_test_success + 1; \
            `SUCCESS("Test successful"); \
        end else begin \
            `ERROR("Test failed"); \
        end \
    end \

`define UNIT_TESTS_END \
    end \
    endtask \
    initial begin\
        run(); \
        $display("\n%c[0;36mINFO:     Testsuite execution finished @ %g%c[0m\n", 27, $time, 27); \
        if (svut_warning > 0) begin \
            $display("\t  -> %c[1;33mWarning number: %4d%c[0m", 27, svut_warning, 27); \
        end\
        if (svut_critical > 0) begin \
            $display("\t  -> %c[1;35mCritical number: %4d%c[0m", 27, svut_critical, 27); \
        end\
        if (svut_nb_test_success != svut_nb_test) begin \
            $display("\t  -> %c[1;31mERROR: %3d / %3d tests passed%c[0m\n", 27, svut_nb_test_success, svut_nb_test, 27); \
        end else begin \
            $display("\t  -> %c[0;32mSUCCESS: %3d / %3d tests passed%c[0m\n", 27, svut_nb_test_success, svut_nb_test, 27); \
        end \
        $finish(); \
    end \

