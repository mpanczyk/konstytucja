#!/bin/bash

function process() {
    URL="${1}"
    FILENAME="${2}"
    SED_SCRIPT_PATH="$(dirname $0)/fix_formatting.sed"
    echo "Processing $URL ..." >&2
    curl "${URL}" 2>/dev/null \
        | iconv --from-code=iso8859-2 --to-code=utf8 \
        | pandoc -f html -t markdown \
        | cut -c3- \
        | sed -f "${SED_SCRIPT_PATH}"
}

process 'https://www.sejm.gov.pl/prawo/konst/polski/wstep.htm' | sed 's/\\//g' | grep -v '^$' > 'preambula.md'

for I in $(seq 1 13)
    do
        process "https://www.sejm.gov.pl/prawo/konst/polski/${I}.htm" > "rozdzial_${I}.md"
    done

