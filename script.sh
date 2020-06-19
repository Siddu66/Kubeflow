#Script for kubeflow deployment

#!/bin/sh -x
source $PWD/demo.config
#Enabling some apis
echo "enabling apis"
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  iam.googleapis.com \
  file.googleapis.com \
  ml.googleapis.com

gcloud services enable container.googleapis.com

#Installing Kustomize
echo "Installing Kustomize"
WORKING_DIR=$PWD
mkdir $WORKING_DIR/bin
wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/kubeflow-resources/kustomize_2.0.3_linux_amd64 -O $WORKING_DIR/bin/kustomize
chmod +x $WORKING_DIR/bin/kustomize
PATH=$PATH:${WORKING_DIR}/bin

#Installing kfctl
echo "Installing kfctl"
wget -P /tmp https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/kubeflow-resources/kfctl_v1.0-0-g94c35cf_linux.tar.gz
tar -xvf /tmp/kfctl_v1.0-0-g94c35cf_linux.tar.gz -C ${WORKING_DIR}/bin


#Setting env variables
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
gcloud config set project $PROJECT_ID

echo "ZONE of your kubeflow deployment is $zone"
export ZONE=$zone
gcloud config set compute/zone $ZONE

export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_gcp_iap.v1.0.2.yaml"

echo "your CLIENT_ID is $client_id"
export CLIENT_ID=$client_id

echo "your CLIENT_SECRET is $client_secret"
export CLIENT_SECRET=$client_secret

echo "The name for the Kubeflow deployment is $name"
export KF_NAME=$name

export KF_DIR=${WORKING_DIR}/${KF_NAME}


mkdir -p ${KF_DIR}
cd ${KF_DIR}

kfctl build -V -f ${CONFIG_URI}

#Customise your kubeflow deployment
echo "Customising your kubeflow deployment to set machine type 'n1-standard-2' which creates 3 compute engines of 2 CPU's each"
sed -i 's/n1-standard-8/n1-standard-2/g' gcp_config/cluster-kubeflow.yaml
export CONFIG_FILE=${KF_DIR}/kfctl_gcp_iap.v1.0.2.yaml
kfctl apply -V -f ${CONFIG_FILE}

#Use gcloud to fetch the credentials so you can communicate with it using kubectl
gcloud container clusters get-credentials ${KF_NAME} --zone ${ZONE} --project ${PROJECT_ID}

