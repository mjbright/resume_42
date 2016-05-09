# Docker demo image, as used on try.jupyter.org and tmpnb.org

FROM ubuntu:xenial

MAINTAINER Michael Bright  <dockerfile@mjbright.net>

# Perform initial update/upgrade to get latest packages/security updates:
RUN apt-get update && \
    apt-get upgrade -y

# Install texlive++ for latex->PDF conversion:
RUN apt-get install -y texlive && \
    apt-get install -y texlive-latex-extra

# Install Python3:
RUN apt-get install -y python3

# Install Python3 modules for reading xlsx files, handling yaml, templates:
RUN apt-get install -y python3-xlrd python3-yaml python3-jinja2
