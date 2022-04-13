# Notes

Brave doesn't work with Charles Proxy, but has no issues at all with mitmproxy.

Charles Proxy works much better with iOS apps than mitmproxy.

HAR files exported by Charles Proxy don't work with `haraylzer` Python library.

Remember to right-click on a domain and select Enable SSL Proxy. Not sure if the export file's contents are affected by
this setting.

It's not clear how to parse the binary payloads in the .trace files exported by Charles Proxy. Running `gzip.decompress` on them didn't work, even after stripping newlines.
