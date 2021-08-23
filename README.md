# Overview

![app](./images/banner.png)

The repo contains a reference JFrog pipeline that showcases how to integrate Dynatrace into JFrog software delivery pipelines for Kubernetes. Deployments are done using [Helm](https://helm.sh/) package manager.

# Repo structure

| File or Folder/ | Comment |
| ------ | ------- |
| pipeline.yml | JFrog pipeline file |
| setup/ | Bash scripts used one time as part of the setup process |
| scripts/ | Bash scripts called by the pipeline -- see [README](scripts/README.md)||
| chart/ | Helm charts used for sample application deployment |
| app/ | Sample application source code and Dockerfile -- see [README](app/README.md)|
| monaco/ | Dynatrace configuration files -- see [README](monaco/README.md) |
| images/ | README images |

# JFrog Pipeline integrations

Below are the integrations used in the reference pipeline. See the [JFrog Documentation](https://www.jfrog.com/confluence/display/JFROG/Pipelines+Integrations) for more details.
| Integration | Comment |
| ----------- | ------- |
| Artifactory | Used to connect the JFrog Pipeline Automation platform to an installation of Artifactory to push artifacts including Docker images, and maintain build information |
| Generic Integration | Used to store the Dynatrace URL and API tokens|
| GitHub | Used to connect the JFrog Pipelines platform to GitHub. |
| Kubernetes | Used to connect JFrog Pipelines platform to self-hosted Kubernetes clusters so that you can deploy Docker based applications.|

# Setup Details

Below are the components and setup details as prerequisites to running the pipeline.

1. [JFrog Account](https://jfrog.com/start-free/) with permissions to add repositories, pipeline sources, and pipeline integrations.
1. [Dynatrace tenant](https://www.dynatrace.com/trial). The Dynatrace tenant URL and an API token are saved in the Generic JFrog Integration.  
1. GitHub account with a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token). This is used in the GitHub JFrog integration.
1. Kubernetes Cluster installed with the [Dynatrace Operator](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/).  This demo used Google GKE using the default settings from the Google console.
    * cluster-version "1.20.8-gke.900"
    * 3 nodes (12GB 6 CPU) machine-type "e2-medium"

1. The Kubernetes cluster setup with a service account and namespace by running the `setup/createKubernetesServiceAccounts.sh` script. The script also generates a `kubeconfig` file whose contents are then pasted into the JFrog Kubernetes integration settings.
1. Kubernetes cluster setup with a viewer Role used by the Dynatrace Kubernetes integration using this command:

    ```
    kubectl create -f setup/dynatrace-oneagent-metadata-viewer.yaml
    ``` 
    
    See [Dynatrace Documentation](https://www.dynatrace.com/support/help/shortlink/kubernetes-tagging#anchor_viewer) for more details and ways this role can be configured.

1. Kubernetes cluster is setup with a secret containing the JFrog Docker Artifactory login credentials. 

    ```
    # login to JFrog account
    docker login ABC.jfrog.io

    # Export credentials into a Kubernetes secret
    kubectl -n dev create secret generic regcred --from-file=.dockerconfigjson=/home/username/.docker/config.json --type=kubernetes.io/dockerconfigjson
    ```

    See [Kubernetes Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for more details.