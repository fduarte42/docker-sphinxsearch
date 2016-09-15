#!/bin/sh

if [ "$(ls -A /var/lib/sphinxsearch/data)" ]; then
    echo "index already there, not indexing";
else
    echo "no index found, starting to index...";
    indexer --all
fi
searchd --nodetach