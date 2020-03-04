# Jenkins testing environment deployment

> Summary of the proposed change

Deploy Jenkins testing environment to be able to integrate it with the Metrics app.

# References

> Link to supporting documentation, GitHub tickets, etc.

[Jenkins](https://jenkins.io/)  
[Google Cloud Jenkins application](https://github.com/GoogleCloudPlatform/click-to-deploy/blob/master/k8s/jenkins/README.md)

# Motivation

> What problem is this project solving?

Creating the Jenkins test environment will provide the data for the Metrics application.
The Jenkins test environment will give us the ability to test the whole process of importing and displaying the project metrics data.

# Goals

> Identify success metrics and measurable goals.

* Jenkins server is running and available for testing by anyone in the team.
* Configuration of the Jenkins to run the tests from the test project. 

# Non-Goals

> Identify what's not in scope.

The creation of the test project is not in the scope of this project.

# Design

> Explain and diagram the technical design

`Kubernetes Engine` -> `Jenkins Server`

> Identify risks and edge cases

Running the builds in the separate docker containers could require an additional configuration.

# API

> What will the proposed API look like?

The Jenkins API is described in this article: [Jenkins remote access api](https://wiki.jenkins.io/display/JENKINS/Remote+access+API).

# Dependencies

> What is the project blocked on?

No blockers.

> What will be impacted by the project?

Testing of the Jenkins integration will be impacted.

# Testing

> How will the project be tested?

This project will be tested manually.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

* Setup Jenkins on Google Kubernetes Engine.
    - Pros:  
         - Easy to set up. The configuration process is fully automated, and it is needed just to configure Jenkins projects.
           It is needed just to go through the [Jenkins Google cloud setup flow](https://console.cloud.google.com/marketplace/details/google/jenkins).
         - Jenkins has a [free application](https://console.cloud.google.com/marketplace/details/google/jenkins) on the Google Cloud.
    - Cons: 
         - The Kubernetes Engine is the paid feature of the Google Cloud that uses a couple of other paid features like Compute Engine.
         
         
* Serve the Jenkins server using the local machine and ngrok.
    - Pros:
         - Easy to setup. You need just to run the Jenkins locally and set up the tunnel to the localhost using the ngrok.
    - Cons: 
         - Because Jenkins stores the data (pipeline configurations, build, build artifacts, etc.) locally,
          using the file system, the Jenkins instance should be running on one machine each time.
         - The server will be very human-sensitive. It means that the instance of Jenkins will be available only when it is running on someone's machine.
         
         
* Setup Jenkins on Google Compute Engine.
    - Pros:
         - In case the Jenkins server is running on the machine, it will be needed to just connect to this machine using SSH to make any changes to the Jenkins server.
    - Cons: 
         - Pretty complicated setup mechanism.
         - We should set up the Jenkins storage manually in some other place like [Cloud Storage](https://cloud.google.com/storage).
         - The Compute Engine is a paid feature on the Google Cloud.

# Timeline

> Document milestones and deadlines.

DONE:
  - Investigation of ways to deploy the Jenkins server.
  - Found the best approach to create the Jenkins server.

NEXT:
  - Create the Jenkins server.
  - Set up the test project tests running on Jenkins.
  
# Results

> What was the outcome of the project?

We decided to use the Kubernetes engine to serve the Jenkins server because this is the easies 
and the most convenient way to set up the Jenkins testing environment.

The Jenkins builds configuration is in progress.