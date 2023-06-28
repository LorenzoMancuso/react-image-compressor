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

## Kubernetes

### Deployment and service

1. Install the deployment

```
kubectl apply -f deployment.yml
```

2. Install the service

```
kubectl apply -f service.yml
```

3. Install the ingress

```
kubectl apply -f ingress.yml
```

### Nginx ingress
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Improvements
1. Resources requests and limits on the deployment
2. Certificates for the ingress: would require also the installation of cert-manager to be used together with Let's Encrypt
3. Replace Nginx ingress annotation with an IngressClass