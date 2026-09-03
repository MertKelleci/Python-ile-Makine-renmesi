FROM python:3.10-trixie

WORKDIR /PYTHON_ML

COPY requirements.txt .

# --no-chache-dir: Prevents pip from caching the downloaded packages, which reduces the size of the Docker image.
# But this also means whenever you change the requirements.txt file, all packages will be redownloaded and reinstalled, which can take time.
# Mount a persistent pip cache directory across Docker builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

EXPOSE 8888

COPY *.csv .

# This will copy all files and directories from the current directory on the host to the working directory in the container, excluding any CSV files. This is useful if you have large CSV files that you don't want to include in the Docker image, but still want to have them available in your local development environment.
COPY --exclude=**/*.csv --exclude=*.csv . .

# Start Jupyter Notebook server.
# --ip=0.0.0.0: Listens on all container network interfaces so external connections (like host VS Code) are accepted.
#--no-browser: Prevents Docker from trying to open a web browser window inside the headless container.
#--allow-root: Allows Jupyter to run as the default root user inside Docker.
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.allow_origin=*"]