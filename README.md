# Kubeflow
Deploying Kubeflow on Kubernetes in GCP

Download the files to the cloud shell terminal
Set the parameters in the configuration.config file
make the script.sh file executable

Before executing the script.sh ensure that you have enabled cloud deployment manager API.
Run the script.sh (It takes around 10 to 15 minutes to create the cluster). After creating the cluster it takes 5 to 10 minutes to create the end point(Kubeflow UI) which can be accessed at https://<KF_NAME>.endpoints.<project-id>.cloud.goog/
