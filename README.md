## Firefox Docker

A Docker container to run Jenkins for a Firefox build


#### Building the Docker Image

Navigate to the root directory where the `Dockerfile` is located

```
sudo docker build -t myuser/firefox-docker:v1 .
```

This will run the docker build based on the Ubuntu Image and will install Jenkins WAR.


#### Running the Docker Image

While you can run the Docker image directly it is preferred to connect an external volume to store the Jenkins workspace.  
This is due to the scale of the data saved.  Re-pulling the full Mozilla Central branch takes a long time.


```
sudo docker run -d -p 8080:8080 -v /home/local/path:/opt/jenkins -i myuser/firefox-docker:v1
```

##### Manage Jenkins
Set the Jenkins workspace directory to the volume referenced by `/opt/jenkins`

> Manage Jenkins -> Jenkins Home -> Advanced -> workspace = /opt/jenkins/workspace

#### Saving the Jenkins Configuration

The docker image does not contain any build jobs.  You must create a build job to run Firefox Build.

##### Setup Jenkins Job

1. Install the `Mercurial Plugin`
2. Setup a Mercurial module to the Mozilla Central code
    > https://hg.mozilla.org/mozilla-central
    
3. Set up job to `Build Periodically`
    > H H * * *
4. Set up `Execute Shell`
    
    > ./mach clobber && ./mach build && ./mach package

5. Commit the package to Nexus repository

```
curl -v --user 'user:password' --upload-file /opt/jenkins/workspace/FirefoxBuild/obj-x86_64-pc-linux-gnu/dist/firefox-53.0a1.en-US.linux-x86_64.tar.bz2 \
http://localhost:8081/repository/firefox-builds/firefox-53.0a1.en-US.linux-x86_64.tar.bz2
```

##### Commit the Docker Image

```
sudo docker commit -m "Firefox Docker v1" <container ID> myuser/firefox-docker:v1
```




