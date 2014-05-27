#/bin/bash
docker build -t apttarbuilder . && docker run apttarbuilder | docker import - apt

