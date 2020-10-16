# caddy-hcl

[![Go](https://github.com/francislavoie/caddy-hcl/workflows/Go/badge.svg)](https://github.com/francislavoie/caddy-hcl/actions)

Caddy config adapter for [HCL](https://github.com/hashicorp/hcl/blob/hcl2/hclsyntax/spec.md) (HashiCorp Configuration Language)

A significant chunk of the code is borrowed from https://github.com/tmccombs/hcl2json, credit to them for figuring out the HCL to JSON conversion.

## Install

Install with [xcaddy](https://github.com/caddyserver/xcaddy).

```
xcaddy build \
    --with github.com/francislavoie/caddy-hcl
```

Or download from the Caddy website: https://caddyserver.com/download

## Usage

Specify the `--adapter` flag to `caddy run`

```
caddy run --config /path/to/hcl/caddy.hcl --adapter hcl
```

## Limitations

Note that currently, HCL block syntax is not properly supported, because of ambiguity in the HCL syntax which makes objects at the end of blocks get wrapped with an array. This meant that block syntax generates JSON that Caddy considers invalid, because for example, it expects objects as the value for each server. Ideally, if I had my way, the config would look more like this (but this doesn't work):

```hcl
apps http servers srv0 {
    ...
}
```

## Example

Here's an example of a simple proxy server.

```hcl
apps = {
  http = {
    servers = {
      srv0 = {
        listen = [":443"]

        routes = [
          {
            match = [{ host = ["example.com"] }]
            handle = [{
              handler = "subroute"
              routes = [{
                handle = [{
                  handler = "reverse_proxy"
                  upstreams = [{ dial = "localhost:8000" }]
                }]
              }]
            }]

            terminal = true
          }
        ]
      }
    }
  }
}
```