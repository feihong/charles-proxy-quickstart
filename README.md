# Feihong's Charles Proxy Quickstart

## Installation

Download tarball from https://www.charlesproxy.com/download/

    tar xvfz charles-proxy-4.6.2_amd64.tar.gz
    mv charles ~

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

## Notes

Brave doesn't work with Charles Proxy, but has no issues at all with mitmproxy.

Charles Proxy works much better with iOS apps than mitmproxy.

HAR files exported by Charles Proxy don't work with `haraylzer` Python library.

Remember to right-click on a domain and select Enable SSL Proxy. Not sure if the export file's contents are affected by
this setting.
