# To use first
# export JFROG_BASE_URL=https://YOUR_ACCOUNT.jfrog.io/artifactory
# export JFROG_API_KEY=YOUR-API-TOKEN

if [ -z $JFROG_BASE_URL ]; then echo "Missing JFROG_BASE_URL" && exit 1 ; fi
if [ -z $JFROG_API_KEY ]; then echo "Missing JFROG_API_KEY" && exit 1 ; fi

REPO=art_dynatrace_charts   # adjust for with your repo name
CHART=demoapp-0.1.0
CLUSTER=my-cluster-name

. ../updateHelmChartProperties.sh ${JFROG_BASE_URL} ${JFROG_API_KEY} ${REPO} ${CHART} ${CLUSTER} 