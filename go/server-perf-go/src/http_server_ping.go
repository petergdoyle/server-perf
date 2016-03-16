package main

import (
  "fmt"
  "log"
  "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    //fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
        //fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
    fmt.Fprintf(w, "", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    log.Println("Go HTTP Server listening on http://0.0.0.0:6000/")
    http.ListenAndServe(":6000", nil)
}
