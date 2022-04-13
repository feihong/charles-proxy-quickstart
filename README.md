# Feihong's Charles Proxy Quickstart

## Prerequisites

Install jq

    sudo apt-get install jq

Download tarball from https://www.charlesproxy.com/download/

    tar xvfz charles-proxy-4.6.2_amd64.tar.gz
    mv charles ~/opt

## Installation

    pip install --user coconut

## Configuration

Export root certificate to .pem file

1. Help > SSL Proxying > Save Charles Root Certificate...
1. Choose to export as "Base 64 encoded certificate (.pem)"
1. Click OK

Import certificate in Chrome (doesn't seem to work in Brave)

1. Settings > Privacy and security > Security > Manage certificates > Authorities
1. Click Import and choose the .pem file you exported
1. Will appear in list as "org-XK72 Ltd"

Import certificate in Mobile Safari

1. Visit https://chls.pro/ssl

For Chrome, you must change your system HTTP/HTTPS Proxy settings to point to 127.0.0.1:8888

## Charles Proxy UI actions

View IP address of proxy: Help > Local IP Address

## Commands

Start Charles Proxy

    make proxy

Convert session HAR file to database file

    make db

Consolidate images into CBZ files

    make cbz

Combine chapter CBZ files into a volume CBZ file:

    make volume

## Steps

1. Go to Settings > General > About > Certificate Trust Settings
1. Turn on Charles Proxy CA
1. ...
