# Feihong's Charles Proxy Quickstart

## Prerequisites

Install jq

    sudo apt-get install jq

Download tarball from https://www.charlesproxy.com/download/

    tar xvfz charles-proxy-4.6.2_amd64.tar.gz
    mv charles ~/opt

## Installation

    pip install coconut

## Configuration

Export root certificate to .pem file

1. Help > SSL Proxying > Save Charles Root Certificate...
1. Choose to export as "Base 64 encoded certificate (.pem)"
1. Click OK

Import certificate in Chrome (doesn't seem to work in Brave)

1. Settings > Privacy and security > Security > Manage certificates > Authorities
1. Click Import and choose the .pem file you exported
1. Will appear in list as "org-XK72 Ltd"

Import certificate on iOS

1. Switch to Manual in HTTP Proxy setting
1. Visit https://chls.pro/ssl
1. Modal will appear asking if you want to allow download of configuration profile. Tap Allow.
1. Select iPhone
1. Go to Settings > General > VPN & Device Management > Downloaded Profile and tap the profile you just downloaded
1. Tap Install, Install, Done
1. Go to Settings > General > About > Certificate Trust Settings
1. Enable the certificate for the profile you just installed

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

## Instructions

1. Go to Settings > General > About > Certificate Trust Settings
1. Turn on Charles Proxy CA
1. Run `make proxy` to start Charles Proxy
1. Select Help > Local IP Address to get the IP address to connect to
1. Go to Settings > Wi-Fi > (name of your wifi network) > (i) > Configure Proxy
1. Select Manual
1. For Server, enter the IP address of Charles Proxy
1. For Port, enter 8888
1. Tap Save
1. Do the browsing you need to do
   1. Select Settings > Clear cached files
   1. Tap 书架
   1. Select the series
   1. Tap (downward arrow) button
   1. Select the chapter you want to download, then tap 免费缓存
   1. Repeat until all chapters are downloaded
1. Select File > Export Session...
1. Save as session.har
1. Run `make process` to generate the .cbz files
