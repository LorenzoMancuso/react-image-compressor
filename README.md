# React Image Compressor

## Overview

A simple image compressor built with [react](https://reactjs.org/) and [browser-image-compression](https://www.npmjs.com/package/browser-image-compression).

## Functionalities

- Compress Image By Reducing Resolution and Size
- Offline Compression

## Built With

- ReactJS
- React Bootstrap
- Browser Image Compression

## Development

1. Clone the repository and change directory.

```
git clone https://github.com/RaulB-masai/react-image-compressor.git
cd react-image-compressor
```

2. Install npm dependencies

```
npm install
```

3. Run the app locally.

```
npm start
```

## Docker
In your local environment you can use docker to run the application:

1. Create the docker image:

```
docker build -t react-image-compressor .
``` 

2. Start the docker container exposing the port 3000:

```
docker run -p 3000:3000 react-image-compressor
``` 

### Docker-compose

The docker-compose app will create the container for the `react-image-compressor` app together with an `nginx` container which acts as reverse proxy and logs every request. The nginx configuration is saved in **config/nginx.conf** .

## Kubernetes

### Deployment and service

1. Install the deployment

```
kubectl apply -f deployment.yml
```

The deployment has only one replica of the pod and uses the image with the "latest" tag.

2. Install the service

```
kubectl apply -f service.yml
```

3. (Optional) Install the ingress

```
kubectl apply -f ingress.yml
```

### Nginx ingress controller

In order to use Nginx as ingress controller you need to install it. You can do it using the official helm chart:

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

This command will create a dedicated nginx namespace called `ingress-nginx` which will contain all the resources.

## Local Testing
In order to test the kubernetes resources in your local environment you have few options:

- **Minikube**: the most popular choice, it offers advanced features. Moreover is open source
- **Kind**: runs a local Kubernetes cluser using containers as nodes
- **Hyperkube**: a single node Kubernetes cluster using a Docker container
- **K3s**: a lightweight version of Kubernetes ideal for local development. Runs well on Raspberrys and other small devices

If you want to test your resources you can just deploy your deployment, the service and the ingress. Then you can open in the browser the url you used inside the nginx ingress. 

If you didn't install the nginx ingress controller or you didn't define an ingress, you can just do a port forward:

```
kubectl port-forward <POD-NAME> TARGET-PORT:CONTAINER-PORT
```

## Terraform

The terraform stack creates:

- The **ECR repository** with default configuration
- The **CodeBuild project** configured to run on amazon-linux2 using small as compute type. The source is the github repository containing the fork of react-image-compressor. The build is triggered by a commit on the master branch

[OPTIONAL] Other than that, the stack contains the definition of the IAM Role and the IAM Policy which allows to:
- push images to the ECR repository
- create log groups, log streams and log events
- interact with the EKS cluster in order to update the deployment after the build

## CodeBuild
The codebuild project contains these phases:
1. **Install**: installation of kubectl and application dependencies using npm
2. **Pre-build**: Linting of the code, login to ECR and EKS cluster configuration in kubeconfig
3. **Build**: docker image creation
4. **Post-build**: push of the docker image to the ECR repository, tagging the image with both the commit hash and the "latest" tag. After that it injects the new image tag inside the kubernetes deployment and then executes `kubectl apply` in order to update the deployment and perform the rolling update on the EKS cluster.

## Future improvements
1. Resources requests and limits on the deployment
2. Certificates for the ingress: would require also the installation of cert-manager to be used together with Let's Encrypt
3. Replacing Nginx ingress annotation with an IngressClass
4. Using Helm with a custom chart to deploy the applications inside the Kubernetes cluster
5. Redefining the build and deployment triggers, for example starting the build when there is a push on master branch and deploying the application when a new tag on master is created.
