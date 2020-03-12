# Jenkins testing environment deployment

> Summary of the proposed change

Deploy Jenkins testing environment to be able to integrate it with the Metrics app and be able to have a more real-world environment for testing.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Jenkins](https://jenkins.io/)  
- [Google Cloud Jenkins application](https://github.com/GoogleCloudPlatform/click-to-deploy/blob/master/k8s/jenkins/README.md)
- [Amazon AWS](https://aws.amazon.com/)

# Motivation

> What problem is this project solving?

Creating the Jenkins test environment will provide the data for the Metrics application.
The Jenkins test environment will give us the ability to test the whole process of importing and displaying the project metrics data.

# Goals

> Identify success metrics and measurable goals.

* The Jenkins instance is running and available for testing by anyone in the team.
* The Jenkins instance is configured to run the tests from the test project. 

# Non-Goals

> Identify what's not in scope.

Creating the test project is out of the scope.

# Design

> Explain and diagram the technical design

`Amazon AWS instance` -> `Jenkins Server`

> Identify risks and edge cases

Since different builds require different environments for Jenkins to run them 
(in our case - we have to run builds with `npm`, so Node.js is required),
we have to run builds in a separate Docker container and this could require an additional configuration.
For instance, configuring a Docker client, or Jenkins user roles to be able to run the Docker container, etc.

# API

> What will the proposed API look like?

## Why Amazon AWS

- The AWS instance is free for one year.
- Has an excellent [Set Up a Jenkins Build Server guide](https://d1.awsstatic.com/Projects/P5505030/aws-project_Jenkins-build-server.pdf) that explains how to create an instance and deploy the Jenkins server.
- Easy to maintain. You could just connect to the AWS instance and use it and use it the way that you would use a computer in front of you.

## Deployment complications

Deploying to the Amazon AWS needs configuration of the AWS instance and firewall rules manually via 
the user interface (no automation available), which takes a bit more time in comparison to using the Google Kubernetes deployment.

## Deploying to the Amazon AWS and configuring Jenkins instance

To deploy the Jenkins instance to the Amazon AWS, follow the steps of the setup guide.

After the Jenkins instance is running on your Amazon AWS EC2 instance, you need to configure the Jenkins and tools for it.

1. Connect to your Amazon EC2 instance following the instructions from the `Connect to Your Linux Instance` paragraph from the setup guide.
2. Install the `git` on your instance using the `sudo yum install git` command.
3. Open the Jenkins root page and go to the `Manage Jenkins` -> `Global tools configuration`.
4. Add the path to your git installation to the Git paragraph.

Now, the Jenkins instance is ready, and you can configure your first Jenkins Pipeline using the [Pipelines Getting Started](https://jenkins.io/pipeline/getting-started-pipelines/) guide.

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
         - Easy to set up. The configuration process is fully automated - only Jenkins projects configuration is required.
           It is needed just to go through the [Jenkins Google cloud setup flow](https://console.cloud.google.com/marketplace/details/google/jenkins).
         - Jenkins has a [free application](https://console.cloud.google.com/marketplace/details/google/jenkins) on the Google Cloud.
    - Cons: 
         - The Kubernetes Engine is the paid feature of the Google Cloud that uses a couple of other paid features like Compute Engine.
         - Hard to maintain because you cannot just SSH connect to the instance with the Jenkins server to make any changes. For connection, you need to use the `kubectl` CLI.
         
         
* Serve the Jenkins server using the local machine and `ngrok`.
    - Pros:
         - Easy to setup. You need just to run the Jenkins locally and set up the tunnel to the localhost using the ngrok for other users to be able to connect.
    - Cons: 
         - Because Jenkins stores the data (pipeline configurations, build, build artifacts, etc.) locally,
          using the file system, the Jenkins instance should be running on the same machine all the time.
         - The server will be very dependent on that configured server availability (app availability, computer availability).
         
         
* Setup Jenkins on Google Compute Engine.
    - Pros:
         - Easy to connect to the container using SSH to make any changes to the Jenkins.
    - Cons: 
         - Pretty complicated setup mechanism because we have a lot of configuration items.
         - We should set up the Jenkins storage manually in some other place like [Cloud Storage](https://cloud.google.com/storage)
          because the Compute Engine instance has too few memory to store all tools, required by Jenkins, and builds with artifacts on the instance.
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

The Jenkins instance is running and available for all team members. Also, it is configured to run the tests from the test project.