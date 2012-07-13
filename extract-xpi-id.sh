#!/bin/sh
cd $1 \
	&& sed -e "1,/urn:mozilla:install-manifest/d" install.rdf \
	| grep -m1 -o -e "em:id\(>\|=\"\)[^<\"]\+" \
	| sed -e "s/em:id\(>\|=\"\)//"
