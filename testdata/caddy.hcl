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