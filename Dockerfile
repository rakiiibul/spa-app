# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest
LABEL maintainer="Raikibul <therakiiibul@outlook.com>"

#uncomment system libraries if you need to update
# system libraries of general use
## install debian packages
#RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    #libxml2-dev \
    #libcairo2-dev \
    #libsqlite3-dev \
    #libmariadbd-dev \
    #libpq-dev \
    #libssh2-1-dev \
    #unixodbc-dev \
    #libcurl4-openssl-dev \
    #libssl-dev

## update system libraries
#RUN apt-get update && \
    #apt-get upgrade -y && \
    #apt-get clean

# copy necessary files
## renv.lock file
COPY ./renv.lock ./renv.lock
## app folder
COPY ./app ./app

# install renv & restore packages
RUN R -e "install.packages(c('shiny', 'tibble', 'dplyr', 'RSQLite', 'radarchart', 'tidyr', 'DT', 'fmsb'))"
#if you want to install the package from renv then comment previous line and uncomment below line
#RUN Rscript -e 'install.packages("renv")'
#RUN Rscript -e 'renv::restore()'

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
