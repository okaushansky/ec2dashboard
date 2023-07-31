#!/bin/bash

set -e
IFS='|'

PARAMS_SRC=${1:-deploy_params}

if [[ -f ${PARAMS_SRC} ]]; then
    . ${PARAMS_SRC}
else 
    echo "Parameters definition file ${PARAMS_SRC} not found. Please specify the correct one"
    exit 1
fi


REACTCONFIG="{\
\"SourceDir\":\"src\",\
\"DistributionDir\":\"dist\",\
\"BuildCommand\":\"yarn run-script build\",\
\"StartCommand\":\"yarn run-script start\"\
}"

AWSCLOUDFORMATIONCONFIG="{\
\"useProfile\":false,\
\"profileName\":\"default\",\
\"accessKeyId\":\"${ACCESS_KEY_ID}\",\
\"secretAccessKey\":\"${SECRET_ACCESS_KEY}\",\
\"region\":\"${REGION}\"\
}"

AMPLIFY="{\
\"projectName\":\"${PROGECT_NAME}\",\
\"envName\":\"${ENV_NAME}\",\
\"defaultEditor\":\"code\"\
}"

FRONTEND="{\
\"frontend\":\"javascript\",\
\"framework\":\"react\",\
\"config\":$REACTCONFIG\
}"

PROVIDERS="{\
\"awscloudformation\":$AWSCLOUDFORMATIONCONFIG\
}"


amplify init \
--amplify $AMPLIFY \
--frontend $FRONTEND \
--providers $PROVIDERS \
--yes