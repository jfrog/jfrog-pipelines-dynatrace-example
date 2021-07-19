#!/bin/bash

# Copyright 2021 JFrog, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script creates a new k8s Service Account and generates a kubeconfig with
# its credentials. This Service Account has all the necessary permissions for
# JFrog Pipelines. The static kubeconfig is written in the current directory.
#
# You must configure your local kubectl to point to the right k8s cluster and
# have admin-level access.


set -eu -o pipefail

# Allow passing in common name and username in environment. If not provided,
# use default.
SA_NAME=pipelines-sa
NAMESPACE=pipelines

# Set OS specific values.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    BASE64_DECODE_FLAG="-d"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    BASE64_DECODE_FLAG="-D"
elif [[ "$OSTYPE" == "linux-musl" ]]; then
    BASE64_DECODE_FLAG="-d"
else
    echo "Unknown OS ${OSTYPE}"
    exit 1
fi

echo "Creating the Kubernetes Service Account with required RBAC permissions."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${SA_NAME}
  namespace: ${NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: dynatrace-role
rules:
- apiGroups:
  - "*"
  - "apps"
  resources:
  - "*"
  - groups
  - services
  - pods
  - serviceaccounts
  - secrets
  - deployments
  - pvcs
  - configmaps
  - deployments
  - namespaces
  - roles
  - podsecuritypolicies
  - customresourcedefinitions
  - clusterroles
  - rolebindings
  - clusterrolebindings
  - events
  - oneagentapms
  - leases
  - nodes
  - mutatingwebhookconfigurations
  verbs:
  - use
  - impersonate
  - get
  - watch
  - list
  - create
  - update
  - delete
- apiGroups:
  - "authorization.k8s.io"
  resources:
  - selfsubjectaccessreviews
  - selfsubjectrulesreviews
  verbs:
  - create
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dynatrace-crb
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: dynatrace-role
subjects:
- kind: ServiceAccount
  name: ${SA_NAME}
  namespace: ${NAMESPACE}
EOF
# Get the service account token and CA cert.
SA_SECRET_NAME=$(kubectl get -n ${NAMESPACE} sa/${SA_NAME} -o "jsonpath={.secrets[0]..name}")
# Note: service account token is stored base64-encoded in the secret but must
# be plaintext in kubeconfig.
SA_TOKEN=$(kubectl get -n ${NAMESPACE} secrets/${SA_SECRET_NAME} -o "jsonpath={.data['token']}" | base64 ${BASE64_DECODE_FLAG})
CA_CERT=$(kubectl get -n ${NAMESPACE} secrets/${SA_SECRET_NAME} -o "jsonpath={.data['ca\.crt']}")

# Extract cluster IP from the current context
CURRENT_CONTEXT=$(kubectl config current-context)
CURRENT_CLUSTER=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"${CURRENT_CONTEXT}\"})].context.cluster}")
CURRENT_CLUSTER_ADDR=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CURRENT_CLUSTER}\"})].cluster.server}")

echo "Writing kubeconfig."
cat > kubeconfig <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${CA_CERT}
    server: ${CURRENT_CLUSTER_ADDR}
  name: ${CURRENT_CLUSTER}
contexts:
- context:
    cluster: ${CURRENT_CLUSTER}
    user: ${SA_NAME}
  name: ${CURRENT_CONTEXT}
current-context: ${CURRENT_CONTEXT}
kind: Config
preferences: {}
users:
- name: ${SA_NAME}
  user:
    token: ${SA_TOKEN}
EOF

echo "---
Done!
Copy the generated kubeconfig file"