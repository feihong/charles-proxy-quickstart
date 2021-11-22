# Feihong's Charles Proxy Quickstart

## Installation

Download tarball from https://www.charlesproxy.com/download/

    tar xvfz charles-proxy-4.6.2_amd64.tar.gz
    mv charles ~

[Install Janet](https://github.com/feihong/janet-quickstart#installation)

    jpm install sqlite3 json https://github.com/joy-framework/codec

## Configuration

Export root certificate to .pem file

1. Help > SSL Proxying > Save Charles Root Certificate...
1. Remember to write in the name of the file
1. Click OK

Import certificate in Brave (doesn't seem to work)

1. Settings > Privacy and security > Security > Manage certificates > Authorities
1. Click Import and choose the .pem file you exported
1. Will appear in list as "org-XK72 Ltd"

Import certificate in Mobile Safari

1. Visit https://chls.pro/ssl

## Charles Proxy UI actions

View IP address of proxy: Help > Local IP Address

## Commands

Start Charles Proxy

    ~/opt/charles/bin/charles

Convert session HAR file to database file

    make db

Consolidate images into CBZ files

    make cbz
