#!/user/bin/env /bin/bash

set -e
IFS='|'

SCRIPT_SOURCE=${BASH_SOURCE[0]}
PARAMS_SRC=${1:-deploy_params}

if [[ -f ${PARAMS_SRC} ]]; then
    . ${PARAMS_SRC}
else 
    echo "Parameters definition file ${PARAMS_SRC} not found. Please specify the correct one"
    exit 1
fi

# Define parameters for silent AWS Amplify project initialising
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


# Init AWS Amplify project
amplify init \
--amplify $AMPLIFY \
--frontend $FRONTEND \
--providers $PROVIDERS \
--yes


# Install and activate Python virtual environment to avoid Lambda compilation errors
cd ${SCRIPT_SOURCE}/amplify/backend/function/FetchEC2Instances/
python3 -m venv venv
source venv/bin/activate

# Provision cloud resources with the latest local changes 
amplify push --yes