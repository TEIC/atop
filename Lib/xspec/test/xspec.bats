#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031

#===============================================================================
#
#         USAGE:  bats xspec.bats 
#         
#   DESCRIPTION:  Unit tests for script bin/xspec.sh 
#
#         INPUT:  N/A
#
#        OUTPUT:  Unit tests results
#
#  DEPENDENCIES:  This script requires bats (https://github.com/sstephenson/bats)
#
#        AUTHOR:  Sandro Cirulli, github.com/cirulls
#
#       LICENSE:  MIT License (https://opensource.org/licenses/MIT)
#
#===============================================================================

#
# Setup and teardown
#

setup() {
    # Work directory
    work_dir="${BATS_TMPDIR}/xspec/bats_work"
    mkdir -p "${work_dir}"

    # Full path to the parent directory
    parent_dir_abs=$(cd ..; pwd)

    # Set TEST_DIR and xspec.dir within the work directory so that it's cleaned up by teardown
    export TEST_DIR="${work_dir}/output_${RANDOM}"
    export ANT_ARGS="-Dxspec.dir=${TEST_DIR}"

    # Invalidate XML Resolver (of XML Calabash) cache
    XMLRESOLVER_PROPERTIES="${work_dir}/xmlresolver.properties"
    echo "cache=${work_dir}/xmlcatalog-cache_${RANDOM}" > "${XMLRESOLVER_PROPERTIES}"
    export XMLRESOLVER_PROPERTIES="file:${XMLRESOLVER_PROPERTIES}"
}

teardown() {
    # Remove the work directory
    rm -r "${work_dir}"
}

#
# Helper
#

load bats-helper

#
# Usage (CLI)
#

@test "invoking xspec without arguments prints usage" {
    run ../bin/xspec.sh
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[1]}" = "Usage: xspec [-t|-q|-s|-c|-j|-catalog file|-e|-h] file" ]
}

@test "invoking xspec without arguments prints usage even if Saxon environment variables are not defined" {
    unset SAXON_CP
    run ../bin/xspec.sh
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "SAXON_CP and SAXON_HOME both not set!" ]
    assert_regex "${lines[2]}" '^Usage: xspec '
}

@test "invoking xspec with -h prints usage and does so even when it is 11th argument" {
    run ../bin/xspec.sh -t -t -t -t -t -t -t -t -t -t -h
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${lines[0]}" '^Usage: xspec '
}

@test "invoking xspec with unknown option prints usage" {
    run ../bin/xspec.sh -bogus ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Error: Unknown option: -bogus" ]
    assert_regex "${lines[1]}" '^Usage: xspec '
}

@test "invoking xspec with extra arguments prints usage" {
    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec bogus
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Error: Extra option: bogus" ]
    assert_regex "${lines[1]}" '^Usage: xspec '
}

#
# Mutually exclusive test types (CLI)
#

@test "invoking xspec with -s and -t prints error message" {
    run ../bin/xspec.sh -s -t
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "-s and -t are mutually exclusive" ]
}

@test "invoking xspec with -s and -q prints error message" {
    run ../bin/xspec.sh -s -q
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "-s and -q are mutually exclusive" ]
}

@test "invoking xspec with -t and -q prints error message" {
    run ../bin/xspec.sh -t -q
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "-t and -q are mutually exclusive" ]
}

#
# XSPEC_HOME
#

@test "XSPEC_HOME" {
    export XSPEC_HOME="${parent_dir_abs}"

    cd "${work_dir}"

    cp "${XSPEC_HOME}/bin/xspec.sh" my-xspec.sh
    chmod +x my-xspec.sh

    run ./my-xspec.sh "${XSPEC_HOME}/tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[18]}" = "passed: 5 / pending: 0 / failed: 1 / total: 6" ]
    [ "${lines[19]}" = "Report available at ${TEST_DIR}/escape-for-regex-result.html" ]
}

@test "XSPEC_HOME is not a directory" {
    export XSPEC_HOME="${work_dir}/file ${RANDOM}"
    touch "${XSPEC_HOME}"

    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "ERROR: XSPEC_HOME is not a directory: ${XSPEC_HOME}" ]
}

@test "XSPEC_HOME seems to be corrupted" {
    export XSPEC_HOME="${work_dir}"

    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "ERROR: XSPEC_HOME seems to be corrupted: ${XSPEC_HOME}" ]
}

#
# SAXON_CP has precedence over SAXON_HOME
#

@test "SAXON_CP has precedence over SAXON_HOME" {
    export SAXON_HOME="${work_dir}/empty-saxon-home ${RANDOM}"
    mkdir "${SAXON_HOME}"

    ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
}

#
# Coverage (CLI)
#

@test "invoking xspec -c creates report files" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    # Other stderr #204
    export JAVA_TOOL_OPTIONS=-Dfoo

    # Non alphanumeric path #208
    special_chars_dir="${work_dir}/up & down ${RANDOM}"
    mkdir "${special_chars_dir}"

    cp ../tutorial/coverage/demo* "${special_chars_dir}"
    unset TEST_DIR

    ../bin/xspec.sh -c "${special_chars_dir}/demo.xspec"

    unset JAVA_TOOL_OPTIONS

    # XML and HTML report file
    [ -f "${special_chars_dir}/xspec/demo-result.xml" ]
    [ -f "${special_chars_dir}/xspec/demo-result.html" ]

    # Check the coverage trace XML file contents
    run java -jar "${SAXON_JAR}" \
        -s:"${special_chars_dir}/xspec/demo-coverage.xml" \
        -xsl:check-coverage-xml.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]

    # Coverage report HTML file is created and contains CSS inline #194
    run java -jar "${SAXON_JAR}" -s:"${special_chars_dir}/xspec/demo-coverage.html" -xsl:check-html-css.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "invoking xspec -c -q prints error message" {
    run ../bin/xspec.sh -c -q ../tutorial/xquery-tutorial.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Coverage is supported only for XSLT" ]
}

@test "invoking xspec -c -s prints error message" {
    run ../bin/xspec.sh -c -s ../tutorial/schematron/demo-01.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Coverage is supported only for XSLT" ]
}

#
# CLI without TEST_DIR
#

@test "invoking xspec without TEST_DIR set externally (XSLT)" {
    unset TEST_DIR

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    test_copy="${work_dir}/some-failures ${RANDOM}"
    mkdir "${test_copy}"
    cp some-failures/function.* "${test_copy}"

    # Run
    run ../bin/xspec.sh "${test_copy}/function.xspec"
    echo "$output"

    # By default, failure is not error
    [ "$status" -eq 0 ]

    # Verify message
    [ "${lines[12]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[13]}" = "Report available at ${test_copy}/xspec/function-result.html" ]
    [ "${lines[14]}" = "Done." ]

    # Verify report files
    # * XML report file is created
    # * HTML report file is created
    # * Coverage is disabled by default
    # * JUnit is disabled by default
    run ls "${test_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "function-compiled.xsl" ]
    [ "${lines[1]}" = "function-result.html" ]
    [ "${lines[2]}" = "function-result.xml" ]

    # HTML report file contains CSS inline #135
    run java -jar "${SAXON_JAR}" \
        -s:"${test_copy}/xspec/function-result.html" \
        -xsl:check-html-css.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "invoking xspec -c without TEST_DIR set externally" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    unset TEST_DIR

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    test_copy="${work_dir}/some-failures ${RANDOM}"
    mkdir "${test_copy}"
    cp some-failures/function.* "${test_copy}"

    # Run
    run ../bin/xspec.sh -c "${test_copy}/function.xspec"
    echo "$output"

    # By default, failure is not error
    [ "$status" -eq 0 ]

    # Verify message
    # Bats bug inserts garbages into $lines: bats-core/bats-core#151
    mylines=()
    while IFS= read -r line; do
        mylines+=("$line")
    done <<< "$output"
    [ "${mylines[18]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${mylines[21]}" = "Report available at ${test_copy}/xspec/function-coverage.html" ]
    [ "${mylines[22]}" = "Done." ]

    # Verify report files
    # * XML report file is created
    # * HTML report file is created
    # * Coverage XML report is created
    # * Coverage HTML report is created
    # * JUnit is disabled by default
    run ls "${test_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "function-compiled.xsl" ]
    [ "${lines[1]}" = "function-coverage.html" ]
    [ "${lines[2]}" = "function-coverage.xml" ]
    [ "${lines[3]}" = "function-result.html" ]
    [ "${lines[4]}" = "function-result.xml" ]
}

@test "invoking xspec without TEST_DIR set externally (XQuery)" {
    unset TEST_DIR

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    test_copy="${work_dir}/some-failures ${RANDOM}"
    mkdir "${test_copy}"
    cp some-failures/function.* "${test_copy}"

    # Run
    run ../bin/xspec.sh -q "${test_copy}/function.xspec"
    echo "$output"

    # By default, failure is not error
    [ "$status" -eq 0 ]

    # Verify message
    [ "${lines[5]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[6]}" = "Report available at ${test_copy}/xspec/function-result.html" ]
    [ "${lines[7]}" = "Done." ]

    # Verify report files
    # * XML report file is created
    # * HTML report file is created
    # * JUnit is disabled by default
    run ls "${test_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "function-compiled.xq" ]
    [ "${lines[1]}" = "function-result.html" ]
    [ "${lines[2]}" = "function-result.xml" ]
}

@test "invoking xspec without TEST_DIR set externally (Schematron)" {
    unset TEST_DIR

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    test_copy="${work_dir}/some-failures ${RANDOM}"
    mkdir "${test_copy}"
    cp some-failures/schematron.* "${test_copy}"

    # Run
    run ../bin/xspec.sh -s "${test_copy}/schematron.xspec"
    echo "$output"

    # By default, failure is not error
    [ "$status" -eq 0 ]

    # Verify message
    # * No Schematron warnings #129 #131
    [ "${lines[ 2]}" = "Converting Schematron XSpec into XSLT XSpec..." ]
    [ "${lines[14]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[15]}" = "Report available at ${test_copy}/xspec/schematron-result.html" ]
    [ "${lines[16]}" = "Done." ]

    # Verify report files
    # * XML report file is created
    # * HTML report file is created
    # * JUnit is disabled by default
    run ls "${test_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "schematron-compiled.xsl" ]
    [ "${lines[1]}" = "schematron-result.html" ]
    [ "${lines[2]}" = "schematron-result.xml" ]
    [ "${lines[3]}" = "schematron-sch-preprocessed.xsl" ]
    [ "${lines[4]}" = "schematron-sch-preprocessed.xspec" ]
}

#
# CLI -e with some failures
#

@test "CLI -e with some failures (XSLT)" {
    run ../bin/xspec.sh -e some-failures/function.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[12]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[13]}" = "Report available at ${TEST_DIR}/function-result.html" ]
    [ "${lines[14]}" = "*** Found a test failure" ]
}

@test "CLI -e with some failures (XQuery)" {
    run ../bin/xspec.sh -e -q some-failures/function.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[5]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[6]}" = "Report available at ${TEST_DIR}/function-result.html" ]
    [ "${lines[7]}" = "*** Found a test failure" ]
}

@test "CLI -e with some failures (Schematron)" {
    run ../bin/xspec.sh -e -s some-failures/schematron.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[14]}" = "passed: 1 / pending: 0 / failed: 2 / total: 3" ]
    [ "${lines[15]}" = "Report available at ${TEST_DIR}/schematron-result.html" ]
    [ "${lines[16]}" = "*** Found a test failure" ]
}

#
# CLI -e with no failures
#

@test "CLI -e with no failures (XSLT)" {
    run ../bin/xspec.sh -e xslt3.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 9]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
    [ "${lines[10]}" = "Report available at ${TEST_DIR}/xslt3-result.html" ]
    [ "${lines[11]}" = "Done." ]
}

@test "CLI -e with no failures (XQuery)" {
    run ../bin/xspec.sh -e -q ../tutorial/xquery-tutorial.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[5]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    [ "${lines[6]}" = "Report available at ${TEST_DIR}/xquery-tutorial-result.html" ]
    [ "${lines[7]}" = "Done." ]
}

@test "CLI -e with no failures (Schematron)" {
    run ../bin/xspec.sh -e -s ../tutorial/schematron/demo-01.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 3 / pending: 0 / failed: 0 / total: 3" ]
    [ "${lines[15]}" = "Report available at ${TEST_DIR}/demo-01-result.html" ]
    [ "${lines[16]}" = "Done." ]
}

#
# JUnit (CLI)
#

@test "invoking xspec with -j option generates message with JUnit report location and creates report files" {
    run ../bin/xspec.sh -j ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[20]}" = "Report available at ${TEST_DIR}/escape-for-regex-junit.xml" ]

    # XML report file
    [ -f "${TEST_DIR}/escape-for-regex-result.xml" ]

    # HTML report file
    [ -f "${TEST_DIR}/escape-for-regex-result.html" ]

    # JUnit report file
    [ -f "${TEST_DIR}/escape-for-regex-junit.xml" ]
}

#
# Runtime warning
#

@test "invoking xspec that passes a non xs:boolean does not raise a warning #46" {
    run ../bin/xspec.sh issue-46.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${lines[4]}" '^Testing with '
}

@test "x:resolve-EQName-ignoring-default-ns() with non-empty prefix does not raise a warning #826" {
    run ../bin/xspec.sh issue-826.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${lines[4]}" '^Testing with '
}

#
# XProc (Saxon)
#

@test "XProc harness for Saxon (XSLT)" {
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    # HTML report file
    actual_report_dir="${PWD}/end-to-end/cases/actual__/stylesheet"
    mkdir -p "${actual_report_dir}"
    actual_report="${actual_report_dir}/serialize-result.html"

    # Run
    java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=end-to-end/cases/serialize.xspec \
        -o result="file:${actual_report}" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xslt-harness.xproc

    # Verify HTML report including #72
    java -jar "${SAXON_JAR}" \
        -s:"${actual_report}" \
        -xsl:end-to-end/processor/html/compare.xsl \
        EXPECTED-DOC-URI="file:${actual_report_dir}/../../expected/stylesheet/serialize-result.html" \
        NORMALIZE-HTML-DATETIME="2000-01-01T00:00:00Z"
}

@test "XProc harness for Saxon (XQuery)" {
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    # HTML report file
    actual_report_dir="${PWD}/end-to-end/cases/actual__/query"
    mkdir -p "${actual_report_dir}"
    actual_report="${actual_report_dir}/serialize-result.html"

    # Run
    java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=end-to-end/cases/serialize.xspec \
        -o result="file:${actual_report}" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xquery-harness.xproc

    # Verify HTML report including #72
    java -jar "${SAXON_JAR}" \
        -s:"${actual_report}" \
        -xsl:end-to-end/processor/html/compare.xsl \
        EXPECTED-DOC-URI="file:${actual_report_dir}/../../expected/query/serialize-result.html" \
        NORMALIZE-HTML-DATETIME="2000-01-01T00:00:00Z"

    # Run again (ndw/xmlcalabash1#322)
    java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=end-to-end/cases/serialize.xspec \
        -o result="file:${actual_report}" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xquery-harness.xproc
}

@test "XProc harness for Saxon (XQuery with special characters in expression #1020)" {
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=issue-1020.xspec \
        -o result="file:${work_dir}/issue-1020-result_${RANDOM}.html" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xquery-harness.xproc
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" = "2" ]
    assert_regex "${lines[1]}" '.+:passed: 12 / pending: 0 / failed: 0 / total: 12'
}

#
# Path containing special chars (CLI)
#

@test "invoking xspec with path containing special chars (#84 #119 #202 #716) runs and loads doc (#610) successfully and generates HTML report file (XSLT)" {
    special_chars_dir="${work_dir}/some'path (84) here & there ${RANDOM}"
    mkdir "${special_chars_dir}"
    cp mirror.xsl       "${special_chars_dir}"
    cp node-selection.* "${special_chars_dir}"

    unset TEST_DIR
    expected_report="${special_chars_dir}/xspec/node-selection-result.html"

    run ../bin/xspec.sh "${special_chars_dir}/node-selection.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[25]}" = "Report available at ${expected_report}" ]
    [ -f "${expected_report}" ]
}

@test "invoking xspec with path containing special chars (#84 #119 #202 #716) runs and loads doc (#610) successfully and generates HTML report file (XQuery)" {
    special_chars_dir="${work_dir}/some'path (84) here & there ${RANDOM}"
    mkdir "${special_chars_dir}"
    cp mirror.xqm       "${special_chars_dir}"
    cp node-selection.* "${special_chars_dir}"

    unset TEST_DIR
    expected_report="${special_chars_dir}/xspec/node-selection-result.html"

    run ../bin/xspec.sh -q "${special_chars_dir}/node-selection.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[6]}" = "Report available at ${expected_report}" ]
    [ -f "${expected_report}" ]
}

@test "invoking xspec with path containing special chars (#84 #119 #202 #716) runs and loads doc (#610) successfully and generates HTML report file (Schematron)" {
    if [ -z "${SAXON_BUG_4696_FIXED}" ]; then
        skip "Saxon bug 4696"
    fi

    special_chars_dir="${work_dir}/some'path (84) here & there ${RANDOM}"
    mkdir "${special_chars_dir}"
    cp ../tutorial/schematron/demo-03* "${special_chars_dir}"

    unset TEST_DIR
    expected_report="${special_chars_dir}/xspec/demo-03-result.html"

    run ../bin/xspec.sh -s "${special_chars_dir}/demo-03.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[30]}" = "Report available at ${expected_report}" ]
    [ -f "${expected_report}" ]
}

#
# saxon script
#

@test "invoking xspec with saxon script uses the saxon script #121 #122" {
    echo "echo 'Saxon script with EXPath Packaging System'" > "${work_dir}/saxon"
    chmod +x "${work_dir}/saxon"
    export PATH="$PATH:${work_dir}"
    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Saxon script found, use it." ]
}

#
# Schematron XSLTs provided externally (CLI)
#
#     Ant is tested by run-xspec-tests-ant.sh
#

@test "invoking xspec with Schematron XSLTs provided externally uses provided XSLTs for Schematron compile (CLI)" {
    if [ -z "${SAXON_BUG_4696_FIXED}" ]; then
        skip "Saxon bug 4696"
    fi

    export SCHEMATRON_XSLT_INCLUDE=schematron/schematron-xslt_include.xsl
    export SCHEMATRON_XSLT_EXPAND=schematron/schematron-xslt_expand.xsl
    export SCHEMATRON_XSLT_COMPILE=schematron/schematron-xslt_compile.xsl

    run ../bin/xspec.sh -s schematron-xslt.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[10]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

#
# Skip Schematron Step (CLI)
#

# Ant is tested by schematron-xslt_skip-1.xspec
@test "Skip Schematron Step 1 (CLI)" {
    export SCHEMATRON_XSLT_INCLUDE="#none"
    export SCHEMATRON_XSLT_EXPAND=schematron/schematron-xslt_include-expand.xsl
    export SCHEMATRON_XSLT_COMPILE=schematron/schematron-xslt_compile.xsl

    run ../bin/xspec.sh -s schematron-xslt.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[10]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

# Ant is tested by schematron-xslt_skip-2.xspec
@test "Skip Schematron Step 2 (CLI)" {
    export SCHEMATRON_XSLT_INCLUDE=schematron/schematron-xslt_include.xsl
    export SCHEMATRON_XSLT_EXPAND="#none"
    export SCHEMATRON_XSLT_COMPILE=schematron/schematron-xslt_expand-compile.xsl

    run ../bin/xspec.sh -s schematron-xslt.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[10]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

# Ant is tested by schematron-xslt_skip-1-2.xspec
@test "Skip Schematron Step 1 and 2 (CLI)" {
    export SCHEMATRON_XSLT_INCLUDE="#none"
    export SCHEMATRON_XSLT_EXPAND="#none"
    export SCHEMATRON_XSLT_COMPILE=schematron/schematron-xslt_include-expand-compile.xsl

    run ../bin/xspec.sh -s schematron-xslt.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[10]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

#
# CLI with TEST_DIR
#

@test "invoking xspec with TEST_DIR creates files in TEST_DIR (XSLT)" {
    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/escape-for-regex.* "${tutorial_copy}"

    # Run with absolute TEST_DIR
    run ../bin/xspec.sh "${tutorial_copy}/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[19]}" = "Report available at ${TEST_DIR}/escape-for-regex-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "escape-for-regex-compiled.xsl" ]
    [ "${lines[1]}" = "escape-for-regex-result.html" ]
    [ "${lines[2]}" = "escape-for-regex-result.xml" ]

    # Default output dir should not be created
    assert_leaf_dir_not_exist "${tutorial_copy}/xspec"

    # Run with relative TEST_DIR
    cd "${work_dir}"
    export TEST_DIR="relative-test-dir ${RANDOM}"
    run "${parent_dir_abs}/bin/xspec.sh" "${tutorial_copy}/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[19]}" = "Report available at ${TEST_DIR}/escape-for-regex-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "escape-for-regex-compiled.xsl" ]
    [ "${lines[1]}" = "escape-for-regex-result.html" ]
    [ "${lines[2]}" = "escape-for-regex-result.xml" ]
}

@test "invoking xspec -c with TEST_DIR creates files in TEST_DIR" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/coverage/demo* "${tutorial_copy}"

    # Run with absolute TEST_DIR
    run ../bin/xspec.sh -c "${tutorial_copy}/demo.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    # Bats bug inserts garbages into $lines: bats-core/bats-core#151
    mylines=()
    while IFS= read -r line; do
        mylines+=("$line")
    done <<< "$output"
    [ "${mylines[17]}" = "Report available at ${TEST_DIR}/demo-coverage.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "demo-compiled.xsl" ]
    [ "${lines[1]}" = "demo-coverage.html" ]
    [ "${lines[2]}" = "demo-coverage.xml" ]
    [ "${lines[3]}" = "demo-result.html" ]
    [ "${lines[4]}" = "demo-result.xml" ]

    # Default output dir should not be created
    assert_leaf_dir_not_exist "${tutorial_copy}/xspec"

    # Run with relative TEST_DIR
    cd "${work_dir}"
    export TEST_DIR="relative-test-dir ${RANDOM}"
    run "${parent_dir_abs}/bin/xspec.sh" -c "${tutorial_copy}/demo.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    # Bats bug inserts garbages into $lines: bats-core/bats-core#151
    mylines=()
    while IFS= read -r line; do
        mylines+=("$line")
    done <<< "$output"
    [ "${mylines[17]}" = "Report available at ${TEST_DIR}/demo-coverage.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "demo-compiled.xsl" ]
    [ "${lines[1]}" = "demo-coverage.html" ]
    [ "${lines[2]}" = "demo-coverage.xml" ]
    [ "${lines[3]}" = "demo-result.html" ]
    [ "${lines[4]}" = "demo-result.xml" ]
}

@test "invoking xspec with TEST_DIR creates files in TEST_DIR (XQuery)" {
    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/xquery-tutorial.* "${tutorial_copy}"

    # Run with absolute TEST_DIR
    run ../bin/xspec.sh -q "${tutorial_copy}/xquery-tutorial.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[6]}" = "Report available at ${TEST_DIR}/xquery-tutorial-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "xquery-tutorial-compiled.xq" ]
    [ "${lines[1]}" = "xquery-tutorial-result.html" ]
    [ "${lines[2]}" = "xquery-tutorial-result.xml" ]

    # Default output dir should not be created
    assert_leaf_dir_not_exist "${tutorial_copy}/xspec"

    # Run with relative TEST_DIR
    cd "${work_dir}"
    export TEST_DIR="relative-test-dir ${RANDOM}"
    run "${parent_dir_abs}/bin/xspec.sh" -q "${tutorial_copy}/xquery-tutorial.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[6]}" = "Report available at ${TEST_DIR}/xquery-tutorial-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "xquery-tutorial-compiled.xq" ]
    [ "${lines[1]}" = "xquery-tutorial-result.html" ]
    [ "${lines[2]}" = "xquery-tutorial-result.xml" ]
}

@test "invoking xspec with TEST_DIR creates files in TEST_DIR (Schematron)" {
    if [ -z "${SAXON_BUG_4696_FIXED}" ]; then
        skip "Saxon bug 4696"
    fi

    # Test with x:context[node()] #322

    # Use a fresh dir, to make the message line numbers predictable
    # and to avoid a residue of output files
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/schematron/demo-03* "${tutorial_copy}"

    # Run with absolute TEST_DIR
    run ../bin/xspec.sh -s "${tutorial_copy}/demo-03.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[30]}" = "Report available at ${TEST_DIR}/demo-03-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "demo-03-compiled.xsl" ]
    [ "${lines[1]}" = "demo-03-result.html" ]
    [ "${lines[2]}" = "demo-03-result.xml" ]
    [ "${lines[3]}" = "demo-03-sch-preprocessed.xsl" ]
    [ "${lines[4]}" = "demo-03-sch-preprocessed.xspec" ]

    # Default output dir should not be created
    assert_leaf_dir_not_exist "${tutorial_copy}/xspec"

    # Run with relative TEST_DIR
    cd "${work_dir}"
    export TEST_DIR="relative-test-dir ${RANDOM}"
    run "${parent_dir_abs}/bin/xspec.sh" -s "${tutorial_copy}/demo-03.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[30]}" = "Report available at ${TEST_DIR}/demo-03-result.html" ]

    # Verify files in specified TEST_DIR
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "5" ]
    [ "${lines[0]}" = "demo-03-compiled.xsl" ]
    [ "${lines[1]}" = "demo-03-result.html" ]
    [ "${lines[2]}" = "demo-03-result.xml" ]
    [ "${lines[3]}" = "demo-03-sch-preprocessed.xsl" ]
    [ "${lines[4]}" = "demo-03-sch-preprocessed.xspec" ]
}

#
# XProc (BaseX)
#

@test "XProc harness for BaseX (standalone)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    # Output files
    compiled_file="${work_dir}/compiled_${RANDOM}.xq"
    expected_report="${work_dir}/issue-1020-result_${RANDOM}.html"

    # Run (also test with special characters in expression #1020)
    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=issue-1020.xspec \
        -o result="file:${expected_report}" \
        -p basex-jar="${BASEX_JAR}" \
        -p compiled-file="file:${compiled_file}" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/basex/basex-standalone-xquery-harness.xproc
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${lines[${#lines[@]}-1]}" '.+:passed: 12 / pending: 0 / failed: 0 / total: 12'

    # Compiled file
    [ -f "${compiled_file}" ]

    # HTML report file should be created and its charset should be UTF-8 #72
    run java -jar "${SAXON_JAR}" -s:"${expected_report}" -xsl:check-html-charset.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "XProc harness for BaseX (server)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    # BaseX dir
    basex_home=$(dirname -- "${BASEX_JAR}")

    # Start BaseX server
    "${basex_home}/bin/basexhttp" -S

    # HTML report file
    expected_report="${work_dir}/report-sequence-result_${RANDOM}.html"

    # Run (also test with various types in report)
    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=report-sequence.xspec \
        -o result="file:${expected_report}" \
        -p auth-method=Basic \
        -p endpoint=http://localhost:8984/rest \
        -p password=admin \
        -p username=admin \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/basex/basex-server-xquery-harness.xproc
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" = "2" ]
    assert_regex "${lines[1]}" '.+:passed: 132 / pending: 0 / failed: 0 / total: 132'

    # HTML report file should be created and its charset should be UTF-8 #72
    run java -jar "${SAXON_JAR}" -s:"${expected_report}" -xsl:check-html-charset.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]

    # Stop BaseX server
    "${basex_home}/bin/basexhttpstop"
}

@test "BaseX with no-prefix.xspec" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=no-prefix.xspec \
        -o result="file:${work_dir}/no-prefix-result_${RANDOM}.html" \
        -p basex-jar="${BASEX_JAR}" \
        -p compiled-file="file:${work_dir}/compiled_${RANDOM}.xq" \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/basex/basex-standalone-xquery-harness.xproc
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" = "2" ]
    assert_regex "${lines[1]}" '.+:passed: 10 / pending: 0 / failed: 0 / total: 10'
}

#
# Ant with minimum properties
#

@test "Ant with minimum properties (XSLT)" {
    # Unset any preset args
    unset ANT_ARGS

    # Use a fresh dir, to avoid a residue of default output dir
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/escape-for-regex.* "${tutorial_copy}"

    # Run
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.xml="${tutorial_copy}/escape-for-regex.xspec"
    echo "$output"

    # Default xspec.fail is true
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]

    # Verify default output dir
    # * Default clean.output.dir is false
    # * Default xspec.coverage.enabled is false
    # * Default xspec.junit.enabled is false
    run env LC_ALL=C ls "${tutorial_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "4" ]
    [ "${lines[0]}" = "escape-for-regex-compiled.xsl" ]
    [ "${lines[1]}" = "escape-for-regex-result.html" ]
    [ "${lines[2]}" = "escape-for-regex-result.xml" ]
    [ "${lines[3]}" = "escape-for-regex_xml-to-properties.xml" ]

    # HTML report file contains CSS inline
    run java -jar "${SAXON_JAR}" \
        -s:"${tutorial_copy}/xspec/escape-for-regex-result.html" \
        -xsl:check-html-css.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "Ant with minimum properties (XQuery)" {
    # Unset any preset args
    unset ANT_ARGS

    # Use a fresh dir, to avoid a residue of default output dir
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/xquery-tutorial.* "${tutorial_copy}"

    # Run
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=q \
        -Dxspec.xml="${tutorial_copy}/xquery-tutorial.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 1 / pending: 0 / failed: 0 / total: 1'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Verify default output dir
    # * Default clean.output.dir is false
    # * Default xspec.junit.enabled is false
    run env LC_ALL=C ls "${tutorial_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "4" ]
    [ "${lines[0]}" = "xquery-tutorial-compiled.xq" ]
    [ "${lines[1]}" = "xquery-tutorial-result.html" ]
    [ "${lines[2]}" = "xquery-tutorial-result.xml" ]
    [ "${lines[3]}" = "xquery-tutorial_xml-to-properties.xml" ]
}

@test "Ant with minimum properties (Schematron)" {
    if [ -z "${SAXON_BUG_4696_FIXED}" ]; then
        skip "Saxon bug 4696"
    fi

    # Unset any preset args
    unset ANT_ARGS

    # Use a fresh dir, to avoid a residue of default output dir
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/schematron/demo-03* "${tutorial_copy}"

    # Run
    # * Should work without phase #168
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=s \
        -Dxspec.xml="${tutorial_copy}/demo-03.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 10 / pending: 1 / failed: 0 / total: 11'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Verify default output dir
    # * Default clean.output.dir is false
    # * Default xspec.junit.enabled is false
    run env LC_ALL=C ls "${tutorial_copy}/xspec"
    echo "$output"
    [ "${#lines[@]}" = "6" ]
    [ "${lines[0]}" = "demo-03-compiled.xsl" ]
    [ "${lines[1]}" = "demo-03-result.html" ]
    [ "${lines[2]}" = "demo-03-result.xml" ]
    [ "${lines[3]}" = "demo-03-sch-preprocessed.xsl" ]
    [ "${lines[4]}" = "demo-03-sch-preprocessed.xspec" ]
    [ "${lines[5]}" = "demo-03_xml-to-properties.xml" ]
}

#
# Catalog file path (Ant)
#
#     Test 'catalog' property containing multiple file paths (relative and absolute)
#

@test "Ant with catalog file path (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dxspec.xml="${PWD}/catalog/catalog-01_stylesheet.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 4 / pending: 0 / failed: 0 / total: 4" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

@test "Ant with catalog file path (XQuery)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dtest.type=q \
        -Dxspec.xml="${PWD}/catalog/catalog-01_query.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 2 / pending: 0 / failed: 0 / total: 2" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

@test "Ant with catalog file path (Schematron)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dtest.type=s \
        -Dxspec.xml="${PWD}/catalog/catalog-01_schematron.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 4 / pending: 0 / failed: 0 / total: 4" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

#
# Catalog file URI (Ant)
#
#     Test 'catalog' property containing multiple URIs (relative and absolute)
#

@test "Ant with catalog file URI (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dcatalog.is.uri=true \
        -Dxspec.xml="${PWD}/catalog/catalog-01_stylesheet.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 4 / pending: 0 / failed: 0 / total: 4" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

@test "Ant with catalog file URI (XQuery)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dcatalog.is.uri=true \
        -Dtest.type=q \
        -Dxspec.xml="${PWD}/catalog/catalog-01_query.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 2 / pending: 0 / failed: 0 / total: 2" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

@test "Ant with catalog file URI (Schematron)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="test/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -Dcatalog.is.uri=true \
        -Dtest.type=s \
        -Dxspec.xml="${PWD}/catalog/catalog-01_schematron.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 4 / pending: 0 / failed: 0 / total: 4" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

#
# Ant catalog.is.uri=true without setting catalog
#

@test "Ant catalog.is.uri=true without setting catalog" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dcatalog.is.uri=true \
        -Dxspec.fail=false \
        -Dxspec.xml="tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Temporary catalog should not be created
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "escape-for-regex-compiled.xsl" ]
    [ "${lines[1]}" = "escape-for-regex-result.html" ]
    [ "${lines[2]}" = "escape-for-regex-result.xml" ]
}

#
# xspec.fail (Ant)
#

@test "Ant with xspec.fail=false continues on test failure (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.fail=false \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]
}

@test "Ant with xspec.fail=true makes the build fail on test failure before cleanup (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dclean.output.dir=true \
        -Dxspec.fail=true \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]

    # Verify the build fails before cleanup
    run ls "${TEST_DIR}"
    echo "$output"
    [ "${#lines[@]}" = "4" ]
}

#
# Ant verbose test.type
#	Last char is capitalized to verify case-insensitiveness
#

@test "Ant verbose test.type (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=xslT \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
}

@test "Ant verbose test.type (XQuery)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=xquerY \
        -Dxspec.xml="${PWD}/../tutorial/xquery-tutorial.xspec"
    echo "$output"
    assert_regex "${output}" $'\n''     \[xslt\] passed: 1 / pending: 0 / failed: 0 / total: 1'$'\n'
}

@test "Ant verbose test.type (Schematron)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dclean.output.dir=true \
        -Dtest.type=schematroN \
        -Dxspec.xml="${PWD}/../tutorial/schematron/demo-01.xspec"
    echo "$output"
    assert_regex "${output}" $'\n''     \[xslt\] passed: 3 / pending: 0 / failed: 0 / total: 3'$'\n'
}

#
# Ant various properties
#

@test "Ant for Schematron with various properties except catalog and xspec.fail" {
    if [ -z "${SAXON_BUG_4696_FIXED}" ]; then
        skip "Saxon bug 4696"
    fi

    build_xml="${work_dir}/build ${RANDOM}.xml"

    # For testing -Dxspec.project.dir
    cp ../build.xml "${build_xml}"

    # Use a fresh dir, to avoid a residue of default output dir
    tutorial_copy="${work_dir}/tutorial ${RANDOM}"
    mkdir "${tutorial_copy}"
    cp ../tutorial/schematron/demo-03* "${tutorial_copy}"

    # Run
    run ant \
        -buildfile "${build_xml}" \
        -lib "${SAXON_JAR}" \
        -Dclean.output.dir=true \
        -Dxspec.project.dir="${PWD}/.." \
        -Dxspec.properties="${PWD}/schematron/schematron.properties" \
        -Dxspec.xml="${tutorial_copy}/demo-03.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 10 / pending: 1 / failed: 0 / total: 11'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Verify that -Dxspec.dir was honored and the default output dir was not created
    assert_leaf_dir_not_exist "${tutorial_copy}/xspec"

    # Verify clean.output.dir=true
    assert_leaf_dir_not_exist "${TEST_DIR}"
}

#
# Catalog file path (CLI) (-catalog)
#
#     Test -catalog specifying multiple file paths (relative and absolute)
#

@test "CLI with -catalog file path (XSLT)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml" \
        "${space_dir}/catalog-01_stylesheet.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

@test "CLI with -catalog file path (XQuery)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml" \
        -q \
        "${space_dir}/catalog-01_query.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[5]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
}

@test "CLI with -catalog file path (Schematron)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml" \
        -s \
        "${space_dir}/catalog-01_schematron.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[16]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

#
# Catalog file URI (CLI) (-catalog)
#
#     Test -catalog specifying multiple file URIs (absolute, no relative)
#

@test "CLI with -catalog file URI (XSLT)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        catalog/catalog-01_stylesheet.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

@test "CLI with -catalog file URI (XQuery)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -q \
        catalog/catalog-01_query.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[5]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
}

@test "CLI with -catalog file URI (Schematron)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    run ../bin/xspec.sh \
        -catalog "file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml" \
        -s \
        catalog/catalog-01_schematron.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[16]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

#
# Catalog file path (CLI) (XML_CATALOG)
#
#     Test XML_CATALOG containing multiple file paths (relative and absolute)
#

@test "CLI with XML_CATALOG file path (XSLT)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh "${space_dir}/catalog-01_stylesheet.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

@test "CLI with XML_CATALOG file path (XQuery)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh -q "${space_dir}/catalog-01_query.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[5]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
}

@test "CLI with XML_CATALOG file path (Schematron)" {
    space_dir="${work_dir}/cat a log ${RANDOM}"
    mkdir -p "${space_dir}/01"
    cp catalog/catalog-01* "${space_dir}"
    cp catalog/01/*        "${space_dir}/01"

    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="catalog/01/catalog-public.xml;${space_dir}/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh -s "${space_dir}/catalog-01_schematron.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[16]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

#
# Catalog file URI (CLI) (XML_CATALOG)
#
#     Test XML_CATALOG containing multiple file URIs (absolute, no relative)
#

@test "CLI with XML_CATALOG file URI (XSLT)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh "catalog/catalog-01_stylesheet.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

@test "CLI with XML_CATALOG file URI (XQuery)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh -q "catalog/catalog-01_query.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[5]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
}

@test "CLI with XML_CATALOG file URI (Schematron)" {
    export SAXON_CP="$SAXON_JAR:$XML_RESOLVER_JAR"
    export XML_CATALOG="file:${PWD}/catalog/01/catalog-public.xml;file:${PWD}/catalog/01/catalog-rewriteURI.xml"

    run ../bin/xspec.sh -s "catalog/catalog-01_schematron.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[16]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

#
# Catalog resolver and SAXON_HOME (CLI)
#

@test "invoking xspec using SAXON_HOME finds Saxon jar and XML Catalog Resolver jar" {
    export SAXON_HOME="${work_dir}/saxon ${RANDOM}"
    mkdir "${SAXON_HOME}"
    cp "${SAXON_JAR}"        "${SAXON_HOME}"
    cp "${XML_RESOLVER_JAR}" "${SAXON_HOME}/xml-resolver-1.2.jar"
    unset SAXON_CP

    # To avoid "No license file found" warning on commercial Saxon
    saxon_license="$(dirname -- "${SAXON_JAR}")/saxon-license.lic"
    if [ -f "${saxon_license}" ]; then
        cp "${saxon_license}" "${SAXON_HOME}"
    fi

    run ../bin/xspec.sh \
        -catalog "catalog/01/catalog-public.xml;catalog/01/catalog-rewriteURI.xml" \
        catalog/catalog-01_stylesheet.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[14]}" = "passed: 4 / pending: 0 / failed: 0 / total: 4" ]
}

#
# Catalog Saxon bug https://saxonica.plan.io/issues/3025/
#
#     This test must specify the catalog parameter as an absolute native file path.
#

@test "Catalog Saxon bug 3025 (CLI)" {
    export SAXON_CP="${SAXON_JAR}:${XML_RESOLVER_JAR}"
    run ../bin/xspec.sh \
        -catalog "${PWD}/catalog/02/catalog.xml" \
        catalog/catalog-02.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[8]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "Catalog Saxon bug 3025 (Ant)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -lib "${XML_RESOLVER_JAR}" \
        -Dcatalog="${PWD}/catalog/02/catalog.xml" \
        -Dxspec.xml="${PWD}/catalog/catalog-02.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    [ "${lines[${#lines[@]}-2]}"  = "BUILD SUCCESSFUL" ]
}

#
# saxon.custom.options (Ant)
#

@test "Ant for XSLT with saxon.custom.options" {
    # Test with a space in file name
    saxon_config="${work_dir}/saxon config ${RANDOM}.xml"
    cp saxon-custom-options/config.xml "${saxon_config}"

    # via properties file, to convey the options in a stable manner...
    xspec_properties="${work_dir}/xspec.properties"
    echo "saxon.custom.options=-config:\"${saxon_config}\" -t" > "${xspec_properties}"

    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.properties="${xspec_properties}" \
        -Dxspec.xml="${PWD}/saxon-custom-options/test.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 3 / pending: 0 / failed: 0 / total: 3'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Verify '-t'
    assert_regex "${output}" $'\n''     \[java\] Memory used:'
}

@test "Ant for XQuery with saxon.custom.options" {
    # Test with a space in file name
    saxon_config="${work_dir}/saxon config ${RANDOM}.xml"
    cp saxon-custom-options/config.xml "${saxon_config}"

    # via properties file, to convey the options in a stable manner...
    xspec_properties="${work_dir}/xspec.properties"
    echo "saxon.custom.options=-config:\"${saxon_config}\" -t" > "${xspec_properties}"

    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=q \
        -Dxspec.properties="${xspec_properties}" \
        -Dxspec.xml="${PWD}/saxon-custom-options/test.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 3 / pending: 0 / failed: 0 / total: 3'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # Verify '-t'
    assert_regex "${output}" $'\n''     \[java\] Memory used:'
}

#
# SAXON_CUSTOM_OPTIONS (CLI)
#

@test "invoking xspec for XSLT with SAXON_CUSTOM_OPTIONS" {
    # Test with a space in file name
    saxon_config="${work_dir}/saxon config ${RANDOM}.xml"
    cp saxon-custom-options/config.xml "${saxon_config}"

    export SAXON_CUSTOM_OPTIONS="\"-config:${saxon_config}\" -t"
    run ../bin/xspec.sh saxon-custom-options/test.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-3]}" = "passed: 3 / pending: 0 / failed: 0 / total: 3" ]

    # Verify '-t'
    assert_regex "${output}" $'\n''Memory used:'
}

@test "invoking xspec for XQuery with SAXON_CUSTOM_OPTIONS" {
    # Test with a space in file name
    saxon_config="${work_dir}/saxon config ${RANDOM}.xml"
    cp saxon-custom-options/config.xml "${saxon_config}"

    export SAXON_CUSTOM_OPTIONS="\"-config:${saxon_config}\" -t"
    run ../bin/xspec.sh -q saxon-custom-options/test.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-3]}" = "passed: 3 / pending: 0 / failed: 0 / total: 3" ]

    # Verify '-t'
    assert_regex "${output}" $'\n''Memory used:'
}

#
# Coverage (Ant)
#

@test "Ant for XSLT with coverage creates report files" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.coverage.enabled=true \
        -Dxspec.xml="${PWD}/../tutorial/coverage/demo.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 1 / pending: 0 / failed: 0 / total: 1'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    # XML and HTML report file
    [ -f "${TEST_DIR}/demo-result.xml" ]
    [ -f "${TEST_DIR}/demo-result.html" ]

    # Coverage report HTML file is created and contains CSS inline
    run java -jar "${SAXON_JAR}" \
        -s:"${TEST_DIR}/demo-coverage.html" \
        -xsl:check-html-css.xsl
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "Ant for XQuery with coverage fails" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=q \
        -Dxspec.coverage.enabled=true \
        -Dxspec.xml="${PWD}/../tutorial/xquery-tutorial.xspec"
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]
    assert_regex "${lines[${#lines[@]}-2]}" 'Coverage is supported only for XSLT'
}

@test "Ant for Schematron with coverage fails" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=s \
        -Dxspec.coverage.enabled=true \
        -Dxspec.xml="${PWD}/../tutorial/schematron/demo-01.xspec"
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]
    assert_regex "${lines[${#lines[@]}-2]}" 'Coverage is supported only for XSLT'
}

#
# JUnit (Ant)
#

@test "Ant for XSLT with JUnit creates report files" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.junit.enabled=true \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]

    # XML report file
    [ -f "${TEST_DIR}/escape-for-regex-result.xml" ]

    # HTML report file
    [ -f "${TEST_DIR}/escape-for-regex-result.html" ]

    # JUnit report file
    [ -f "${TEST_DIR}/escape-for-regex-junit.xml" ]
}

#
# Import order #185
#

@test "Import order #185 (CLI)" {
    run ../bin/xspec.sh issue-185/import-1.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 5]}" = "Scenario 1-1" ]
    [ "${lines[ 6]}" = "Scenario 1-2" ]
    [ "${lines[ 7]}" = "Scenario 1-3" ]
    [ "${lines[ 8]}" = "Scenario 2a-1" ]
    [ "${lines[ 9]}" = "Scenario 2a-2" ]
    [ "${lines[10]}" = "Scenario 2b-1" ]
    [ "${lines[11]}" = "Scenario 2b-2" ]
    [ "${lines[12]}" = "Scenario 3" ]
    [ "${lines[13]}" = "Formatting Report..." ]
}

@test "Import order #185 (Ant)" {
    ant_log="${work_dir}/ant.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -Dxspec.xml="${PWD}/issue-185/import-1.xspec"

    run grep -F " Scenario " "${ant_log}"
    echo "$output"
    [ "${#lines[@]}" = "8" ]
    [ "${lines[0]}" = "     [java] Scenario 1-1" ]
    [ "${lines[1]}" = "     [java] Scenario 1-2" ]
    [ "${lines[2]}" = "     [java] Scenario 1-3" ]
    [ "${lines[3]}" = "     [java] Scenario 2a-1" ]
    [ "${lines[4]}" = "     [java] Scenario 2a-2" ]
    [ "${lines[5]}" = "     [java] Scenario 2b-1" ]
    [ "${lines[6]}" = "     [java] Scenario 2b-2" ]
    [ "${lines[7]}" = "     [java] Scenario 3" ]
}

#
# Circular import #987
#

@test "Circular import #987 (CLI)" {
    run ../bin/xspec.sh issue-987_child.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 5]}" = "Scenario in child" ]
    [ "${lines[ 7]}" = "Scenario in parent" ]
    [ "${lines[10]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]

    # Use a fresh dir, to make the message line numbers predictable
    export TEST_DIR="${TEST_DIR}/parent ${RANDOM}"
    run ../bin/xspec.sh issue-987_parent.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 5]}" = "Scenario in parent" ]
    [ "${lines[ 7]}" = "Scenario in child" ]
    [ "${lines[10]}" = "passed: 2 / pending: 0 / failed: 0 / total: 2" ]
}

@test "Circular import #987 (Ant)" {
    #
    # Child
    #
    ant_log="${work_dir}/ant_child.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -Dxspec.xml="${PWD}/issue-987_child.xspec"

    run cat "${ant_log}"
    echo "$output"
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 2 / pending: 0 / failed: 0 / total: 2" ]

    run grep -F " Scenario in " "${ant_log}"
    echo "$output"
    [ "${#lines[@]}" = "2" ]
    [ "${lines[0]}" = "     [java] Scenario in child" ]
    [ "${lines[1]}" = "     [java] Scenario in parent" ]

    #
    # Parent
    #
    ant_log="${work_dir}/ant_parent.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -Dxspec.xml="${PWD}/issue-987_parent.xspec"

    run cat "${ant_log}"
    echo "$output"
    [ "${lines[${#lines[@]}-10]}" = "     [xslt] passed: 2 / pending: 0 / failed: 0 / total: 2" ]

    run grep -F " Scenario in " "${ant_log}"
    echo "$output"
    [ "${#lines[@]}" = "2" ]
    [ "${lines[0]}" = "     [java] Scenario in parent" ]
    [ "${lines[1]}" = "     [java] Scenario in child" ]
}

#
# Boolean @test with any comparison factor
#

@test "Boolean @test with @as (XSLT)" {
    run ../bin/xspec.sh bad-assertion/boolean-test/as.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Boolean @test with @as should be error'): Boolean @test must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with @as (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/boolean-test/as.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Boolean @test with @as should be error'\): Boolean @test must$"
    [ "${lines[6]}" = "  not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with child node (XSLT)" {
    run ../bin/xspec.sh bad-assertion/boolean-test/child-node.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Boolean @test with child node should be error'): Boolean @test must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with child node (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/boolean-test/child-node.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Boolean @test with child node should be error'\): Boolean$"
    [ "${lines[6]}" = "  @test must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with @href (XSLT)" {
    run ../bin/xspec.sh bad-assertion/boolean-test/href.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Boolean @test with @href should be error'): Boolean @test must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with @href (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/boolean-test/href.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Boolean @test with @href should be error'\): Boolean @test$"
    [ "${lines[6]}" = "  must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with @select (XSLT)" {
    run ../bin/xspec.sh bad-assertion/boolean-test/select.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Boolean @test with @select should be error'): Boolean @test must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Boolean @test with @select (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/boolean-test/select.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Boolean @test with @select should be error'\): Boolean @test$"
    [ "${lines[6]}" = "  must not be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

#
# Non-boolean @test with no comparison factors
#

@test "Non-boolean @test (empty sequence) with no comparison factors (XSLT)" {
    run ../bin/xspec.sh bad-assertion/non-boolean-test/empty.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Non-boolean @test (empty sequence) with no comparison factors should be error (even if child::x:label exists)'): Non-boolean @test must be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Non-boolean @test (empty sequence) with no comparison factors (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/non-boolean-test/empty.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Non-boolean @test \(empty sequence\) with no comparison$"
    [ "${lines[6]}" = "  factors should be error (even if child::x:label exists)'): Non-boolean @test must be" ]
    [ "${lines[7]}" = "  accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Non-boolean @test (multiple xs:boolean) with no comparison factors (XSLT)" {
    run ../bin/xspec.sh bad-assertion/non-boolean-test/multiple-boolean.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Non-boolean @test (multiple xs:boolean) with no comparison factors should be error (even if child::x:label exists)'): Non-boolean @test must be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Non-boolean @test (multiple xs:boolean) with no comparison factors (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/non-boolean-test/multiple-boolean.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Non-boolean @test \(multiple xs:boolean\) with no comparison$"
    [ "${lines[6]}" = "  factors should be error (even if child::x:label exists)'): Non-boolean @test must be" ]
    [ "${lines[7]}" = "  accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Non-boolean @test (node) with no comparison factors (XSLT)" {
    run ../bin/xspec.sh bad-assertion/non-boolean-test/node.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[7]}" = "ERROR in x:expect ('Non-boolean @test (node) with no comparison factors should be error (even if child::x:label exists)'): Non-boolean @test must be accompanied by @as, @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "Non-boolean @test (node) with no comparison factors (XQuery)" {
    run ../bin/xspec.sh -q bad-assertion/non-boolean-test/node.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[5]}" "^  FOER0000[: ] ERROR in x:expect \('Non-boolean @test \(node\) with no comparison factors should$"
    [ "${lines[6]}" = "  be error (even if child::x:label exists)'): Non-boolean @test must be accompanied by @as," ]
    [ "${lines[7]}" = "  @href, @select, or child node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

#
# Obsolete x:space
#

@test "Obsolete x:space" {
    run ../bin/xspec.sh obsolete-space/test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:space \(under '\''Using x:space'\''\): x:space is obsolete\. Use x:text instead\.'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# #423
#

@test "XSLT selecting nodes without context should be error (XProc) #423" {
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=issue-423/test.xspec \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xslt-harness.xproc
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[${#lines[@]}-3]}" '.+err:XPDY0002:'
    assert_regex "${lines[${#lines[@]}-1]}" '^ERROR:'
}

@test "XQuery selecting nodes without context should be error (XProc) #423" {
    if [ -z "${XMLCALABASH_CP}" ]; then
        skip "XMLCALABASH_CP is not defined"
    fi

    run java -cp "${XMLCALABASH_CP}" com.xmlcalabash.drivers.Main \
        -i source=issue-423/test.xspec \
        -p xspec-home="file:${parent_dir_abs}/" \
        ../src/harnesses/saxon/saxon-xquery-harness.xproc
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''.+[: ]XPDY0002[: ]'
    assert_regex "${lines[${#lines[@]}-1]}" '^ERROR:'
}

@test "XSLT selecting nodes without context should be error (Ant) #423" {
    # Should be error even when xspec.fail=false
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.fail=false \
        -Dxspec.xml="${PWD}/../test/issue-423/test.xspec"
    echo "$output"
    [ "$status" -eq 2 ]
    assert_regex "${output}" $'\n''     \[java\]   XPDY0002[: ]'
    [ "${lines[${#lines[@]}-3]}" = "BUILD FAILED" ]
}

@test "XSLT selecting nodes without context should be error (CLI) #423" {
    run ../bin/xspec.sh issue-423/test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  XPDY0002[: ]'
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "XSLT selecting nodes without context should be error (CLI -c) #423" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    run ../bin/xspec.sh -c issue-423/test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  XPDY0002[: ]'
    [ "${lines[${#lines[@]}-1]}" = "*** Error collecting test coverage data" ]
}

@test "XQuery selecting nodes without context should be error (CLI) #423" {
    run ../bin/xspec.sh -q issue-423/test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  XPDY0002[: ]'
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

#
# @xquery-version
#

@test "Default @xquery-version" {
    ../bin/xspec.sh -q ../tutorial/xquery-tutorial.xspec

    run cat "${TEST_DIR}/xquery-tutorial-compiled.xq"
    [ "${lines[0]}" = 'xquery version "3.1";' ]
}

@test "Invalid @xquery-version should be error" {
    run ../bin/xspec.sh -q xquery-version/invalid.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" '.+XQST0031.+InVaLiD'
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

#
# report-css-uri
#

@test "report-css-uri for HTML report file" {
    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.fail=false \
        -Dxspec.result.html.css="${PWD}/check-html-css.css" \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"

    run java -jar "${SAXON_JAR}" \
        -s:"${TEST_DIR}/escape-for-regex-result.html" \
        -xsl:check-html-css.xsl \
        STYLE-CONTAINS="This CSS file is for testing report-css-uri parameter"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

@test "report-css-uri for coverage report HTML file" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.coverage.enabled=true \
        -Dxspec.coverage.html.css="${PWD}/check-html-css.css" \
        -Dxspec.xml="${PWD}/../tutorial/coverage/demo.xspec"

    run java -jar "${SAXON_JAR}" \
        -s:"${TEST_DIR}/demo-coverage.html" \
        -xsl:check-html-css.xsl \
        STYLE-CONTAINS="This CSS file is for testing report-css-uri parameter"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}

#
# #522
#

@test "Error message when source is not XSpec #522" {
    run ../bin/xspec.sh do-nothing.xsl
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR: Source document is not XSpec. /x:description is missing. Supplied source has /xsl:stylesheet instead." ]
}

#
# Missing @stylesheet, @query, @schematron
#
#     Use no-prefix*.xspec to test the element name in the error message
#

@test "Error message when @stylesheet is missing" {
    run ../bin/xspec.sh no-prefix_schematron.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in Q{http://www.jenitennison.com/xslt/xspec}description: Missing @stylesheet." ]
}

@test "Error message when @query is missing" {
    run ../bin/xspec.sh -q no-prefix_schematron.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in Q{http://www.jenitennison.com/xslt/xspec}description: Missing @query." ]
}

@test "Error message when @schematron is missing" {
    run ../bin/xspec.sh -s no-prefix.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[2]}" = "ERROR in Q{http://www.jenitennison.com/xslt/xspec}description: Missing @schematron." ]
}

#
# x:param in XSpec namespace
#

@test "Error on x:param in XSpec namespace (x:context/x:param with lexical QName)" {
    run ../bin/xspec.sh reserved-vardecl-name/param/context-param_lexical-qname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named u:context-param) (under 'x:context/x:param/@name has lexical QName in XSpec namespace'): Name u:context-param must not use the XSpec namespace." ]
}

@test "Error on x:param in XSpec namespace (x:description/x:param with URIQualifiedName)" {
    run ../bin/xspec.sh reserved-vardecl-name/param/description-param_uqname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named Q{http://www.jenitennison.com/xslt/xspec}description-param): Name Q{http://www.jenitennison.com/xslt/xspec}description-param must not use the XSpec namespace." ]
}

@test "Error on x:param in XSpec namespace (function x:param with lexical QName)" {
    run ../bin/xspec.sh reserved-vardecl-name/param/function-param_lexical-qname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named u:function-param) (under 'x:call[@function]/x:param/@name has lexical QName in XSpec namespace'): Name u:function-param must not use the XSpec namespace." ]
}

@test "Error on x:param in XSpec namespace (template-call x:param with URIQualifiedName)" {
    run ../bin/xspec.sh reserved-vardecl-name/param/template-call-param_uqname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named Q{http://www.jenitennison.com/xslt/xspec}template-call-param) (under 'x:call[@template]/x:param/@name has URIQualifiedName in XSpec namespace'): Name Q{http://www.jenitennison.com/xslt/xspec}template-call-param must not use the XSpec namespace." ]
}

#
# x:variable in XSpec namespace
#

@test "Error on x:variable in XSpec namespace (global x:variable with lexical QName in )" {
    run ../bin/xspec.sh reserved-vardecl-name/variable/global-variable_lexical-qname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named u:global-variable): Name u:global-variable must not use the XSpec namespace." ]
}

@test "Error on x:variable in XSpec namespace (local x:variable with URIQualifiedName)" {
    run ../bin/xspec.sh reserved-vardecl-name/variable/local-variable_uqname.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named Q{http://www.jenitennison.com/xslt/xspec}local-variable) (under 'x:scenario/x:variable/@name has URIQualifiedName in XSpec namespace'): Name Q{http://www.jenitennison.com/xslt/xspec}local-variable must not use the XSpec namespace." ]
}

#
# x:param and x:variable should be evaluated only once
#

@test "x:param should be evaluated only once" {
    run ../bin/xspec.sh ../tutorial/under-the-hood/compilation-params-scope.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 3]}" = "Running Tests..." ]
    assert_regex "${lines[4]}" '^Testing with SAXON '
    [ "${lines[ 5]}" = "outer scenario" ]
    [ "${lines[ 6]}" = "* [1]: xs:string: value-2" ]
    [ "${lines[ 7]}" = "..inner scenario" ]
    [ "${lines[ 8]}" = "* [1]: xs:string: value-3" ]
    [ "${lines[ 9]}" = "* [1]: xs:string: value-1" ]
    [ "${lines[10]}" = "1st expect" ]
    [ "${lines[11]}" = "Formatting Report..." ]
}

@test "x:variable should be evaluated only once (XSLT)" {
    run ../bin/xspec.sh ../tutorial/under-the-hood/compilation-variables-scope.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[ 3]}" = "Running Tests..." ]
    assert_regex "${lines[4]}" '^Testing with SAXON '
    [ "${lines[ 5]}" = "outer scenario" ]
    [ "${lines[ 6]}" = "* [1]: xs:string: value-2" ]
    [ "${lines[ 7]}" = "..inner scenario" ]
    [ "${lines[ 8]}" = "* [1]: xs:string: value-3" ]
    [ "${lines[ 9]}" = "* [1]: xs:string: value-4" ]
    [ "${lines[10]}" = "1st expect" ]
    [ "${lines[11]}" = "* [1]: xs:string: value-1" ]
    [ "${lines[12]}" = "* [1]: xs:string: value-5" ]
    [ "${lines[13]}" = "2nd expect" ]
    [ "${lines[14]}" = "Formatting Report..." ]
}

@test "x:variable should be evaluated only once (XQuery)" {
    run ../bin/xspec.sh -q ../tutorial/under-the-hood/compilation-variables-scope.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[3]}" = "Running Tests..." ]
    [ "${lines[4]}" = "* [1]: xs:string: value-2" ]
    [ "${lines[5]}" = "* [1]: xs:string: value-3" ]
    [ "${lines[6]}" = "* [1]: xs:string: value-4" ]
    [ "${lines[7]}" = "* [1]: xs:string: value-1" ]
    [ "${lines[8]}" = "* [1]: xs:string: value-5" ]
    [ "${lines[9]}" = "Formatting Report..." ]
}

#
# Deprecated Saxon version
#

@test "Deprecated Saxon version" {
    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 0 ]

    if [ "${SAXON_VERSION:0:4}" = "9.8." ]; then
        [ "${lines[2]}" = "WARNING: Saxon version 9.8 is not recommended. Consider migrating to Saxon 9.9." ]
    else
        [ "${lines[2]}" = " " ]
    fi

    [ "${lines[3]}" = "Running Tests..." ]
    assert_regex "${lines[4]}" '^Testing with SAXON [EHP]E [1-9][0-9]*\.[1-9][0-9]*'
}

#
# No warning on Ant
#

@test "No warning on Ant (XSLT) #633" {
    if [ "${SAXON_VERSION:0:4}" = "9.8." ]; then
        skip "Always expect a deprecation warning on Saxon 9.8"
    fi

    ant_log="${work_dir}/ant.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -verbose \
        -Dtest.type=t \
        -Dxspec.xml="${PWD}/xspec-uri.xspec"
    [ -f "${ant_log}" ]

    run grep -F -i "warning" "${ant_log}"
    echo "$output"
    [ "$status" -eq 1 ]
}

@test "No warning on Ant (XQuery) #633" {
    if [ "${SAXON_VERSION:0:4}" = "9.8." ]; then
        skip "Always expect a deprecation warning on Saxon 9.8"
    fi

    ant_log="${work_dir}/ant.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -verbose \
        -Dtest.type=q \
        -Dxspec.xml="${PWD}/xspec-uri.xspec"
    [ -f "${ant_log}" ]

    run grep -F -i "warning" "${ant_log}"
    echo "$output"
    [ "$status" -eq 1 ]
}

@test "No warning on Ant (Schematron) #633" {
    if [ "${SAXON_VERSION:0:4}" = "9.8." ]; then
        skip "Always expect a deprecation warning on Saxon 9.8"
    fi

    ant_log="${work_dir}/ant.log"

    ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -logfile "${ant_log}" \
        -verbose \
        -Dtest.type=s \
        -Dxspec.xml="${PWD}/xspec-uri.xspec"
    [ -f "${ant_log}" ]

    run grep -F -i "warning" "${ant_log}"
    echo "$output"
    [ "$status" -eq 1 ]
}

#
# @catch should not catch error outside SUT
#

@test "@catch should not catch error outside SUT (XSLT)" {
    run ../bin/xspec.sh catch/compiler-error.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario '
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]

    run ../bin/xspec.sh catch/error-in-context-avt-for-template-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-context-avt-for-template-call[: ] Error signalled '
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../bin/xspec.sh catch/error-in-context-param-for-matching-template.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-context-param-for-matching-template[: ] Error signalled '
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../bin/xspec.sh catch/error-in-function-call-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-function-call-param[: ] Error signalled '
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../bin/xspec.sh catch/error-in-template-call-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-template-call-param[: ] Error signalled '
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../bin/xspec.sh catch/error-in-variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-variable[: ] Error signalled '
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../bin/xspec.sh catch/static-error-in-compiled-test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" 'XPST0017[: ]'
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "@catch should not catch error outside SUT (XQuery)" {
    run ../bin/xspec.sh -q catch/compiler-error.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario '

    run ../bin/xspec.sh -q catch/error-in-function-call-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-function-call-param[: ] Error signalled '

    run ../bin/xspec.sh -q catch/error-in-variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  error-code-of-my-variable[: ] Error signalled '

    run ../bin/xspec.sh -q catch/static-error-in-compiled-test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" 'XPST0017[: ]'
}

#
# Error in SUT should not be caught by default
#

@test "Error in SUT should not be caught by default (XSLT)" {
    run ../bin/xspec.sh catch/no-by-default.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  my-error-code[: ] Error signalled '
}

@test "Error in SUT should not be caught by default (XQuery)" {
    run ../bin/xspec.sh -q catch/no-by-default.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  my-error-code[: ] Error signalled '
}

#
# Importing Ant build file
#

@test "Importing Ant build file" {
    run ant \
        -buildfile ant-import/build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-9]}" = "     [xslt] passed: 5 / pending: 0 / failed: 1 / total: 6" ]
    [ "${lines[${#lines[@]}-5]}" = "     [echo] Target overridden!" ]
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]
}

#
# #655
#

@test "Trace listener should not hardcode output dir #655" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    # TEST_DIR should not contain "xspec"
    export "TEST_DIR=/tmp/XSpec-655 ${RANDOM}"

    ../bin/xspec.sh -c ../tutorial/coverage/demo.xspec

    run grep -F "<pre>01:" "${TEST_DIR}/demo-coverage.html"
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" = "2" ]

    rm -r "${TEST_DIR}"
}

#
# x:like errors
#

@test "x:like error (scenario not found)" {
    run ../bin/xspec.sh like/none.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:like (labeled 'none') (under 'no scenario matched'): Scenario not found." ]
}

@test "x:like error (multiple scenarios)" {
    run ../bin/xspec.sh like/multiple.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:like (labeled 'shared scenario') (under 'multiple scenarios matched'): 2 scenarios found with same label." ]
}

@test "x:like error (infinite loop)" {
    run ../bin/xspec.sh like/loop.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:like (labeled 'parent scenario') (under 'parent scenario this scenario'): Reference to ancestor scenario creates infinite loop." ]
}

#
# Override ID generation templates
#

@test "Override ID generation (XSLT)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dxspec.xslt.compiler.xsl="${PWD}/override-id/compile-xslt-tests.xsl" \
        -Dxspec.fail=false \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 5 / pending: 0 / failed: 1 / total: 6'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    run cat "${TEST_DIR}/escape-for-regex-compiled.xsl"
    echo "$output"
    assert_regex "${output}" '.+Q\{http://www.jenitennison.com/xslt/xspec\}overridden-xslt-scenario-id-'
    assert_regex "${output}" '.+Q\{http://www.jenitennison.com/xslt/xspec\}overridden-xslt-expect-id'
}

@test "Override ID generation (XQuery)" {
    run ant \
        -buildfile ../build.xml \
        -lib "${SAXON_JAR}" \
        -Dtest.type=q \
        -Dxspec.xquery.compiler.xsl="${PWD}/override-id/compile-xquery-tests.xsl" \
        -Dxspec.xml="${PWD}/../tutorial/xquery-tutorial.xspec"
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${output}" $'\n''     \[xslt\] passed: 1 / pending: 0 / failed: 0 / total: 1'$'\n'
    [ "${lines[${#lines[@]}-2]}" = "BUILD SUCCESSFUL" ]

    run cat "${TEST_DIR}/xquery-tutorial-compiled.xq"
    echo "$output"
    assert_regex "${output}" $'\n''declare function local:overridden-xquery-scenario-id-'
    assert_regex "${output}" $'\n''declare function local:overridden-xquery-expect-id-'
}

#
# Custom HTML reporter (CLI)
#
#     Ant is tested by XSPEC_HOME/test/end-to-end/cases/format-xspec-report-folding.xspec
#

@test "Custom HTML reporter (CLI)" {
    export HTML_REPORTER_XSL=format-xspec-report-messaging.xsl
    run ../bin/xspec.sh ../tutorial/escape-for-regex.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[${#lines[@]}-16]}" = "--- Actual Result ---" ]
    [ "${lines[${#lines[@]}-9]}"  = "--- Expected Result ---" ]
}

#
# Custom coverage reporter (CLI)
#
#     Ant is tested by XSPEC_HOME/test/end-to-end/cases/custom-coverage-report.xspec
#

@test "Custom coverage reporter (CLI)" {
    if [ -z "${XSLT_SUPPORTS_COVERAGE}" ]; then
        skip "XSLT_SUPPORTS_COVERAGE is not defined"
    fi

    export COVERAGE_REPORTER_XSL=custom-coverage-report.xsl
    ../bin/xspec.sh -c ../tutorial/coverage/demo.xspec

    run cat "${TEST_DIR}/demo-coverage.html"
    echo "$output"
    assert_regex "${output}" '.+--Customized coverage report--.+'
}

#
# Broken x:import
#

@test "x:import with unreachable @href" {
    run ../bin/xspec.sh import/file-not-found.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  FODC0002[: ] I/O error reported by XML parser processing'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "x:import without @href" {
    run ../bin/xspec.sh import/no-href.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''  XPDY0050[: ] An empty sequence is not allowed as the value in '\''treat as'\'' expression'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Error message from x:compile-scenario template (XSLT)
#

@test "x:context both with @href and content" {
    run ../bin/xspec.sh error-compiling-scenario/context-both-href-and-content.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:context both with @href and content'): Can't set the context document using both the href attribute and the content of the x:context element" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "x:call both with @function and @template" {
    run ../bin/xspec.sh error-compiling-scenario/call-both-function-and-template.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:call both with @function and @template'): Can't call a function and a template at the same time" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "x:call[@function] with x:context" {
    run ../bin/xspec.sh error-compiling-scenario/function-with-context.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:call[@function] with x:context'): Setting a context for calling a function is supported only when /x:description has @run-as='external'." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "x:expect without action" {
    run ../bin/xspec.sh error-compiling-scenario/expect-without-action.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:expect without action'): There are x:expect but no x:call or x:context has been given" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Error message from x:compile-scenario template (XQuery)
#

@test "x:context (XQuery)" {
    run ../bin/xspec.sh -q error-compiling-scenario/xquery_context.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:context'): x:context not supported for XQuery" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "x:call/@template (XQuery)" {
    run ../bin/xspec.sh -q error-compiling-scenario/xquery_template-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('x:call/@template'): x:call/@template not supported for XQuery" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "No x:call (XQuery)" {
    run ../bin/xspec.sh -q error-compiling-scenario/xquery_no-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('No x:call'): There are x:expect but no x:call" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# $x:saxon-config is not a Saxon config
#

@test "\$x:saxon-config is not a Saxon config" {
    run ../bin/xspec.sh x-saxon-config/test.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[6]}" = "ERROR: \$Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

#
# Duplicate param name
#

@test "Duplicate function-call param name (XSLT)" {
    run ../bin/xspec.sh dup-param-name/function-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of function-param (i.e. //x:call[@function]/x:param) of the same name'): Duplicate parameter name, Q{}left, used in x:call." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Duplicate function-call param name (XQuery)" {
    run ../bin/xspec.sh -q dup-param-name/function-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of function-param (i.e. //x:call[@function]/x:param) of the same name'): Duplicate parameter name, Q{}left, used in x:call." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Duplicate context param name" {
    run ../bin/xspec.sh dup-param-name/context.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of context template-param (i.e. //x:context/x:param) of the same name'): Duplicate parameter name, Q{}left, used in x:context." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Duplicate template-call param name" {
    run ../bin/xspec.sh dup-param-name/template-call.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of template-call template-param (i.e. //x:call[@template]/x:param) of the same name'): Duplicate parameter name, Q{}left, used in x:call." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Static param not allowed
#

@test "Static param not allowed (XSLT without @run-as=external)" {
    run ../bin/xspec.sh param-disallowed/description-param/static-param/stylesheet.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named p): Enabling @static is supported only when /x:description has @run-as='external'." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Static param not allowed (Schematron)" {
    run ../bin/xspec.sh -s param-disallowed/description-param/static-param/schematron.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[2]}" = "ERROR in x:param (named p): Enabling @static is not supported for Schematron." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error converting Schematron into XSLT" ]
}

#
# Description param not allowed
#

@test "Description param not allowed (XQuery)" {
    run ../bin/xspec.sh -q param-disallowed/description-param/query.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named p): Q{http://www.jenitennison.com/xslt/xspec}description has x:param, which is not supported for XQuery." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Scenario param not allowed
#

@test "Scenario param not allowed (XSLT without @run-as=external)" {
    run ../bin/xspec.sh param-disallowed/scenario-param/stylesheet.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named p) (under 'x:scenario/child::x:param'): x:scenario has x:param, which is supported only when /Q{http://www.jenitennison.com/xslt/xspec}description has @run-as='external'." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario param not allowed (XQuery)" {
    run ../bin/xspec.sh -q param-disallowed/scenario-param/query.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named p) (under 'x:scenario/child::x:param'): Q{http://www.jenitennison.com/xslt/xspec}scenario has x:param, which is not supported for XQuery." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario param not allowed (Schematron without @run-as=external)" {
    run ../bin/xspec.sh -s param-disallowed/scenario-param/schematron.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[5]}" = "ERROR in x:param (named p) (under 'x:scenario/child::x:param'): x:scenario has x:param, which is supported only when /Q{http://www.jenitennison.com/xslt/xspec}description has @run-as='external'." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# x:param conflicting with another variable declaration
#

@test "Description x:param conflicting with x:param" {
    run ../bin/xspec.sh conflicting-vardecl/description-param/param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named Q{http://example.org/ns/my}foo): Name conflicts with x:param (named my:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Description x:param conflicting with x:variable" {
    run ../bin/xspec.sh conflicting-vardecl/description-param/variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named my:foo): Name conflicts with x:variable (named Q{http://example.org/ns/my}foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:param conflicting with ancestor scenario x:variable" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-param/ancestor-scenario-variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named my:foo) (under 'scenario with child::x:variable in-between scenario scenario with child::x:param'): Name conflicts with x:variable (named my:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:param conflicting with description x:variable" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-param/description-variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named my:foo) (under 'x:scenario/x:param'): Name conflicts with x:variable (named Q{http://example.org/ns/my}foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:param conflicting with preceding-sibling x:variable" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-param/preceding-sibling-variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:param (named my2:foo) (under 'x:scenario/x:param'): Name conflicts with x:variable (named my1:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# x:variable conflicting with another variable declaration
#

@test "Description x:variable conflicting with x:param" {
    run ../bin/xspec.sh conflicting-vardecl/description-variable/param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named Q{http://example.org/ns/my}foo): Name conflicts with x:param (named my:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Description x:variable conflicting with x:variable" {
    run ../bin/xspec.sh conflicting-vardecl/description-variable/variable.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named my:foo): Name conflicts with x:variable (named Q{http://example.org/ns/my}foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:variable conflicting with ancestor scenario x:param" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-variable/ancestor-scenario-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named my:foo) (under 'scenario with child::x:param in-between scenario scenario with child::x:variable'): Name conflicts with x:param (named my:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:variable conflicting with description x:param" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-variable/description-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named my:foo) (under 'x:scenario/x:variable'): Name conflicts with x:param (named Q{http://example.org/ns/my}foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Scenario x:variable conflicting with preceding-sibling x:param" {
    run ../bin/xspec.sh conflicting-vardecl/scenario-variable/preceding-sibling-param.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:variable (named my2:foo) (under 'x:scenario/x:variable'): Name conflicts with x:param (named my1:foo)" ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Duplicate @position
#

@test "Duplicate @position (XSLT)" {
    run ../bin/xspec.sh bad-position/duplicate.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of function-param (i.e. //x:call[@function]/x:param) of the same position'): Duplicate parameter position, 1, used in x:call." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Duplicate @position (XQuery)" {
    run ../bin/xspec.sh -q bad-position/duplicate.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[3]}" = "ERROR in x:scenario ('Multiple instances of function-param (i.e. //x:call[@function]/x:param) of the same position'): Duplicate parameter position, 1, used in x:call." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Too large @position
#

@test "Too large @position (first) (XSLT)" {
    run ../bin/xspec.sh bad-position/too-large_first.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario \('\''.+'\''\): Too large parameter position, 5, used in x:call\.'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Too large @position (first) (XQuery)" {
    run ../bin/xspec.sh -q bad-position/too-large_first.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario \('\''.+'\''\): Too large parameter position, 5, used in x:call\.'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Too large @position (last) (XSLT)" {
    run ../bin/xspec.sh bad-position/too-large_last.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario \('\''.+'\''\): Too large parameter position, 5, used in x:call\.'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

@test "Too large @position (last) (XQuery)" {
    run ../bin/xspec.sh -q bad-position/too-large_last.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${output}" $'\n''ERROR in x:scenario \('\''.+'\''\): Too large parameter position, 5, used in x:call\.'$'\n'
    [ "${lines[${#lines[@]}-1]}" = "*** Error compiling the test suite" ]
}

#
# Warn when a named template scenario has a context mode or parameter
#

@test "Warning when x:call[@template] ignores x:context/@mode" {
    run ../bin/xspec.sh context-mode-ignored.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[3]}" = "WARNING in x:scenario ('With x:context[@mode] and x:call[@template]'): x:context/@mode will have no effect on x:call" ]
}

@test "Warning when x:call[@template] ignores x:context/x:param" {
    run ../bin/xspec.sh context-param.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    [ "${lines[3]}" = "WARNING in x:scenario ('When x:context has x:param and another child node, setting up the context excludes x:param from the context nodes. So... When a template is called,'): x:context/x:param will have no effect on x:call" ]
}

#
# Message for pending
#

@test "Message for pending" {
    run ../bin/xspec.sh end-to-end/cases/pending.xspec
    echo "$output"
    [ "$status" -eq 0 ]
    assert_regex "${lines[4]}" '^Testing with SAXON '
    [ "${lines[ 5]}" = "Test pending features (x:pending and @pending)" ]
    [ "${lines[ 6]}" = "..a non-pending Success scenario alongside a pending scenario" ]
    [ "${lines[ 7]}" = "must execute the test and return Success" ]
    [ "${lines[ 8]}" = "..a non-pending Failure scenario alongside a pending scenario" ]
    [ "${lines[ 9]}" = "must execute the test and return Failure" ]
    [ "${lines[10]}" = "      FAILED" ]
    [ "${lines[11]}" = "PENDING: (testing x:pending) a Success scenario in x:pending must be Pending" ]
    [ "${lines[12]}" = "PENDING: (testing x:pending) it would return Success if it were not Pending" ]
    [ "${lines[13]}" = "PENDING: (testing x:pending) an erroneous scenario in x:pending must be Pending" ]
    [ "${lines[14]}" = "PENDING: (testing x:pending) it would throw an error if it were not Pending" ]
    [ "${lines[15]}" = "PENDING: a Success scenario in zero-length x:pending/@label must be Pending" ]
    [ "${lines[16]}" = "PENDING: it would return Success if it were not Pending" ]
    [ "${lines[17]}" = "PENDING: an erroneous scenario in zero-length x:pending/@label must be Pending" ]
    [ "${lines[18]}" = "PENDING: it would throw an error if it were not Pending" ]
    [ "${lines[19]}" = "PENDING: a Success scenario in zero-length x:pending/x:label must be Pending" ]
    [ "${lines[20]}" = "PENDING: it would return Success if it were not Pending" ]
    [ "${lines[21]}" = "PENDING: an erroneous scenario in zero-length x:pending/x:label must be Pending" ]
    [ "${lines[22]}" = "PENDING: it would throw an error if it were not Pending" ]
    [ "${lines[23]}" = "PENDING: a Success scenario in x:pending[empty(@label | x:label)] must be Pending" ]
    [ "${lines[24]}" = "PENDING: it would return Success if it were not Pending" ]
    [ "${lines[25]}" = "PENDING: an erroneous scenario in x:pending[empty(@label | x:label)] must be Pending" ]
    [ "${lines[26]}" = "PENDING: it would throw an error if it were not Pending" ]
    [ "${lines[27]}" = "PENDING: (testing @pending of a Success scenario) ..a Success scenario with @pending must be Pending" ]
    [ "${lines[28]}" = "PENDING: (testing @pending of a Success scenario) it would return Success if it were not Pending" ]
    [ "${lines[29]}" = "PENDING: (testing @pending of an erroneous scenario) ..an erroneous scenario with @pending must be Pending" ]
    [ "${lines[30]}" = "PENDING: (testing @pending of an erroneous scenario) it would throw an error if it were not Pending" ]
    [ "${lines[31]}" = "PENDING: ..Zero-length x:scenario/@pending" ]
    [ "${lines[32]}" = "PENDING: ..a Success scenario in zero-length @pending must be Pending" ]
    [ "${lines[33]}" = "PENDING: it would return Success if it were not Pending" ]
    [ "${lines[34]}" = "PENDING: ..an erroneous scenario in zero-length @pending must be Pending" ]
    [ "${lines[35]}" = "PENDING: it would throw an error if it were not Pending" ]
    [ "${lines[36]}" = "..a Success x:expect with @pending must be Pending" ]
    [ "${lines[37]}" = "PENDING: (testing @pending of a Success x:expect) it would return Success if it were not Pending" ]
    [ "${lines[38]}" = "..an erroneous x:expect with @pending must be Pending" ]
    [ "${lines[39]}" = "PENDING: (testing @pending of an erroneous x:expect) it would throw an error if it were not Pending" ]
    [ "${lines[40]}" = "..a Success x:expect with zero-length @pending must be Pending" ]
    [ "${lines[41]}" = "PENDING: it would return Success if it were not Pending" ]
    [ "${lines[42]}" = "..an erroneous x:expect with zero-length @pending must be Pending" ]
    [ "${lines[43]}" = "PENDING: it would throw an error if it were not Pending" ]
    [ "${lines[44]}" = "Formatting Report..." ]
    [ "${lines[45]}" = "passed: 1 / pending: 16 / failed: 1 / total: 18" ]
}

#
# @threads is not a positive integer
#

@test "@threads is zero" {
    if [ -z "${XSLT_SUPPORTS_THREADS}" ]; then
        skip "XSLT_SUPPORTS_THREADS is not defined"
    fi

    run ../bin/xspec.sh threads/dynamic-error/description_zero.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[6]}" '^  FOER0000[: ] /Q\{http://www.jenitennison.com/xslt/xspec\}description\[1\]/@threads is not positive$'
}

@test "@threads contains more than one item" {
    if [ -z "${XSLT_SUPPORTS_THREADS}" ]; then
        skip "XSLT_SUPPORTS_THREADS is not defined"
    fi

    run ../bin/xspec.sh threads/dynamic-error/scenario_multiple.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[7]}" '^  FOER0000[: ] /Q\{http://www.jenitennison.com/xslt/xspec\}description\[1\]/Q\{http://www.jenitennison.com/xslt/xspec\}scenario\[1\]/@threads is not an integer'
}

@test "@threads is a string" {
    if [ -z "${XSLT_SUPPORTS_THREADS}" ]; then
        skip "XSLT_SUPPORTS_THREADS is not defined"
    fi

    run ../bin/xspec.sh threads/dynamic-error/scenario_string.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    assert_regex "${lines[7]}" '^  FOER0000[: ] /Q\{http://www.jenitennison.com/xslt/xspec\}description\[1\]/Q\{http://www.jenitennison.com/xslt/xspec\}scenario\[1\]/@threads is not an integer'
}

#
# Bad Schematron @location
#

@test "@location selects an atomic value" {
    cd schematron/bad-location/atomic

    run ../../../../bin/xspec.sh -s expect-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-assert/@location: Expression 1 should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-assert/@location: Expression 'str' should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-report/@location: Expression true() should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-report/@location: Expression xs:QName('my:foo') should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "@location selects an empty sequence" {
    cd schematron/bad-location/empty

    run ../../../../bin/xspec.sh -s expect-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-assert/@location: Expression () should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-assert/@location: Expression () should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-report/@location: Expression () should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-report/@location: Expression () should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "@location selects 2+ nodes" {
    cd schematron/bad-location/multiple

    run ../../../../bin/xspec.sh -s expect-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-assert/@location: Expression /descendant-or-self::node() should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-assert.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-assert/@location: Expression /descendant-or-self::node() should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-not-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-not-report/@location: Expression /descendant-or-self::node() should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]

    run ../../../../bin/xspec.sh -s expect-report.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in x:expect-report/@location: Expression /descendant-or-self::node() should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}

@test "SVRL @location fails to select text node #396" {
    run ../bin/xspec.sh -s schematron/bad-location/issue-396.xspec
    echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[${#lines[@]}-2]}" = "ERROR in svrl:successful-report/@location: Expression above-mentioned should point to one node." ]
    [ "${lines[${#lines[@]}-1]}" = "*** Error running the test suite" ]
}
