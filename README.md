# Jenkins for mono + net462

This is a docker image of Jenkins for .NET projects.
We need windows servers for .NET CI, this presented Linux contener with mono products.

```
docker pull akrisiun/jenkins-mono
IP=192.168.1.9 docker run -d -e DISPLAY=$IP:0 --name jenk8090 -p 8090:8080 akrisiun/jenkins-mono

```

You can access http://localhost:8090/
