# To use first
# export DT_BASEURL=https://YOUR-TENANT.live.dynatrace.com
# export DT_API_TOKEN=YOUR-API-TOKEN
if [ -z $DT_BASEURL ]; then echo "Missing DT_BASEURL" && exit 1 ; fi
if [ -z $DT_API_TOKEN ]; then echo "Missing DT_API_TOKEN" && exit 1 ; fi

# adjust for your local path
SOURCE_FILE_PATH=/Users/rob.jahn/dev/dt-demos/jfrog-pipelines-dynatrace-example

echo "docker run -e DT_BASEURL=$DT_BASEURL -e DT_API_TOKEN=$DT_API_TOKEN -e NEW_CLI=1 -v $SOURCE_FILE_PATH:/monaco-mount/ "dynatraceace/monaco-runner:release-v1.5.3 "monaco deploy -v --environments /monaco-mount/monaco/environments.yml --project demoapp /monaco-mount/monaco/projects"
docker run -e DT_BASEURL=$DT_BASEURL -e DT_API_TOKEN=$DT_API_TOKEN -e NEW_CLI=1 -v $SOURCE_FILE_PATH:/monaco-mount/ dynatraceace/monaco-runner:release-v1.5.3 "monaco deploy -v --environments /monaco-mount/monaco/environments.yml --project demoapp /monaco-mount/monaco/projects"
