#################
## √ @Tom
#################

# √ Use the official Python image as the base image
FROM python:3.9

# √ Set an environment variable for the echo message
ENV ECHO_MESSAGE="Hello, Perimeter81!"

# √ Set the working directory in the container
WORKDIR /app

# √ Copy the application files into the container
COPY ./echo.py /app/echo.py
COPY ./index.html /app/index.html

# √ Install required dependencies
RUN pip install Flask requests

# √ Expose the port on which the application will run
EXPOSE 8080

# √ Define the command to run the application with the environment variable
CMD ["python3", "echo.py"]
