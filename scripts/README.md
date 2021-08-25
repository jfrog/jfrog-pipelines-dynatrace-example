# Overview

This folder contains 'demo' scripts used for this example pipeline.  The intention is to then invoke in a pipeline step for example:
* `$res_gitRepo_resourcePath/scripts/sendDynatraceEvent.sh ${DT_BASEURL} ${DT_API_TOKEN} ${DEPLOYMENT_PROJECT} ${DEPLOYMENT_VERSION} ${CI_BACK_LINK} ${SOURCE} ${IMAGE_NAME} ${HELM_CHART} ${PIPELINE_REPO} ${JFROG_PIPELINE_NAME} ${JFROG_RUN_NUMBER} ${JFROG_PROJECT} ${TAG_RULE}`

Open each script and review the comments at the top for additional details.

# Testing

A few helper scripts in the `testing` subfolder allow to test the script outside of a pipeline.  To run a test script, folllow this guide:
* be in the testing subfolder - `cd testing`
* export the required environment variables (see comments within each script for details)
* adjust and parameter values within the script
* run the script - for example: `./test-monaco.sh`