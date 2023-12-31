1. Python server application

To run the server, execute the following command in the terminal:

# python3 echo.py

By running the script, you start the Flask development server, which listens for incoming HTTP requests. 
The defined route functions handle different paths and return appropriate responses. When you visit http://localhost:8080/, you'll see "Simple Echo Server." 
Accessing http://localhost:8080/echo will return the echo_message, http://localhost:8080/index.html will serve the content of the index.html file, and http://localhost:8080/geolocation will return the user's IP address and geolocation based on the IPinfo API data.

2. Docker

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

# docker build -t "docker-image-name" .

Replace the "docker-image-name" with your desired Docker image name

To run the container and set the environment variable, use the following command:

# docker run -p 8080:8080 -e ECHO_MESSAGE="Your custom message" echo-server-image

Replace "Your custom message" with the desired echo message you want the server to echo. For example

# docker run -p 8080:8080 -e ECHO_MESSAGE=“production” echo-server-image  # TESTING THE IMAGE LOCALLY

The container will now run the echo server application, and the specified message will be echoed when you access http://localhost:8080/echo.

Pushing the container to ECR:

Run the following commands to tag the image and push the image to ECR

# docker tag tomagembo-echo-server:latest public.ecr.aws/z8r9g7l9/tomagembo-echo-server:latest

# docker push public.ecr.aws/z8r9g7l9/tomagembo/echo-server-image:latest


3. Helm

create a ConfigMap to include the index.html file content:

# kubectl create configmap echo-server-configmap --from-file=path/to/index.html

Finally, package and install the Helm chart:

# helm package echo-server-chart
# helm install echo-server ./echo-server-chart-1.0.0.tgz


4. Terraform/Terragrunt

Run

# terragrunt apply

within the root directory of the AWS EKS cluster along with the echo server Helm deployment.

The kubeconfig output will give you the configuration to connect to the EKS cluster, and the echo_server_url output will give you the URL to access the echo server LoadBalancer.


The config files to access the cluster using kubectl are in ./config file