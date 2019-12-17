#!/bin/bash
set -e

wait_for_url()
{
    local url="$1"
    local counter="$2"
    local accept="$3"
    i=1

    while [ "$i" -le "$counter" ] && ! curl -s --head "${url}" -H "Accept: ${accept}" >/dev/null 2>&1
    do
        sleep 1 ;
        i=$(( i+1 ))
    done

    if ! curl -s --head "${url}" -H "Accept: ${accept}" >/dev/null 2>&1 ; then
        echo "${url} not responding, exiting..."
        exit 1
    fi
}

import_file()
{
    local filename="$1"
    local endpoint="$2"
    local content_type="$3"

    curl -s --show-error "${endpoint}" -d @"${filename}" -H "Content-Type: ${content_type}"
}

process_init_files()
{
    local dir="$1"
    local endpoint="$2"

    echo
    for f in "$dir"/*; do
        case "$f" in
        *.ttl)     echo "Importing $f"
                   import_file "$f" "${endpoint}" "text/turtle" >/dev/null 2>&1
        ;;
        *.trig)    echo "Importing $f"
                   import_file "$f" "${endpoint}" "application/trig" >/dev/null 2>&1
        ;;
        *.nt)      echo "Importing $f"
                   import_file "$f" "${endpoint}" "application/n-triples" >/dev/null 2>&1
        ;;
        *.nq)      echo "Importing $f"
                   import_file "$f" "${endpoint}" "application/n-quads" >/dev/null 2>&1
        ;;
        *.rdf)      echo "Importing $f"
                   import_file "$f" "${endpoint}" "application/rdf+xml" >/dev/null 2>&1
        ;;
        *)         echo "Ignoring $f" ;;
        esac
        echo
    done
}

# if TDB data dir is empty, launch a temporary server and import init files
if [ -z "$(ls -A "$DATA")" ]; then
    echo "Starting temporary server"
    exec java -jar -Dlog4j.configuration=file:"$BASE"/log4j.properties "$RUN"/fuseki-server.jar --port 3333 "$@" &
    pid=$!
    echo "Temporary server started."

    wait_for_url "http://localhost:3333/ds/" 10 "application/trig"
    process_init_files "$INIT_D" http://localhost:3333/ds/

    echo "Stopping temporary server"
    kill $pid &>/dev/null
    echo "Temporary server stopped"

    echo
    echo "Fuseki init process done. Ready for start up."
    echo
fi

# launch the server proper
exec java -jar -Dlog4j.configuration=file:"$BASE"/log4j.properties "$RUN"/fuseki-server.jar "$@"