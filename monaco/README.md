# Overview

Automation is the key to successful IT operations. Automation is also the key to successful monitoring and how you set up your monitoring environment or software intelligence platform.

Without such rules, configuring your environments can result in chaos, with losses in flexibility, speed, and stability.

The [Dynatrace configuration API](https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/) helps you keep track of your Dynatrace monitoring environment configurations.

One option that to automation is this is the [Monaco is CLI tool](https://dynatrace-oss.github.io/dynatrace-monitoring-as-code/) that tool automates deployment of Dynatrace Monitoring Configuration to one or multiple Dynatrace environments. 

To automate `monaco` within this pipeline, the Dynatrace services team created this [Monaco Runner](https://github.com/dynatrace-ace/monaco-runner) which is a container image that contains Dynatrace's Monaco (Monitoring as Code) toolset.

# Development

1. Create or adjust the various configuration YAML files according the [monaco configuration structure](https://dynatrace-oss.github.io/dynatrace-monitoring-as-code/configuration/yaml_confg)

1. Set the Dynatrace URL and API Token and local variables

    ```
    export DT_BASEURL=[YOUR URL]
    export DT_API_TOKEN=[YOUR API TOKEN]
    ```

1. Run Docker image with a volume mount

```
docker run -e DT_BASEURL=$DT_BASEURL -e DT_API_TOKEN=$DT_API_TOKEN -e NEW_CLI=1 -v $(pwd):/monaco-mount/ dynatraceace/monaco-runner:release-v1.5.3 "monaco deploy -v --environments /monaco-mount/monaco/environments.yml --project demoapp /monaco-mount/monaco/projects"
```