# To use first
# export DT_BASEURL=https://YOUR-TENANT.live.dynatrace.com
# export DT_API_TOKEN=YOUR-API-TOKEN

if [ -z $DT_BASEURL ]; then echo "Missing DT_BASEURL" && exit 1 ; fi
if [ -z $DT_API_TOKEN ]; then echo "Missing DT_API_TOKEN" && exit 1 ; fi

DEPLOYMENT_PROJECT=demoapp
DEPLOYMENT_VERSION=123
CI_BACK_LINK=https://www.jfrog.com
SOURCE=JFrogPipeline
IMAGE_NAME=dynatracedemos.jfrog.io/art-docker-dynatrace/demoapp:0.1.44
HELM_CHART=demoapp
JFROG_USER=rob.jahn@dynatrace.com
JFROG_ARTIFACTORY_URL=https://dynatracedemos.jfrog.io/
PIPELINE_REPO=https://github.com/dt-demos/jfrog-pipelines-dynatrace-example
JFROG_PIPELINE_NAME=demo
JFROG_RUN_NUMBER=123
JFROG_PROJECT=dynatrace-demos
TAG_RULE="{\"meTypes\":[\"PROCESS_GROUP_INSTANCE\"],\"tags\":[{\"context\":\"CONTEXTLESS\",\"key\":\"service\",\"value\":\"$DT_TAG_SERVICE\"},{\"context\":\"CONTEXTLESS\",\"key\":\"project\",\"value\":\"$DT_TAG_PROJECT\"},{\"context\":\"CONTEXTLESS\",\"key\":\"stage\",\"value\":\"$DT_TAG_STAGE\"}]}"
. ../sendDynatraceEvent.sh ${DT_BASEURL} ${DT_API_TOKEN} ${DEPLOYMENT_PROJECT} ${DEPLOYMENT_VERSION} ${CI_BACK_LINK} ${SOURCE} ${IMAGE_NAME} ${HELM_CHART} ${JFROG_USER} ${JFROG_ARTIFACTORY_URL} ${PIPELINE_REPO} ${JFROG_PIPELINE_NAME} ${JFROG_RUN_NUMBER} ${JFROG_PROJECT} ${TAG_RULE}