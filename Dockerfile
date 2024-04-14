# Use an official Elixir runtime as a parent image
FROM elixir:latest

# Set the working directory in the container
WORKDIR /app

# Install Hex package manager

RUN mix archive.install github hexpm/hex branch latest --force

RUN mix local.rebar --force

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN mix deps.get

# Compile the project
RUN mix do compile

# Run the application on container startup
CMD ["mix", "run"]
