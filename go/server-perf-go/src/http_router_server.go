package main

import (
    "fmt"
    "html"
    "log"
    "net/http"
)

func main() {
    http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "echo, %q", html.EscapeString(r.URL.Path))
    })
    http.HandleFunc("/upload", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "upload, %q", html.EscapeString(r.URL.Path))
    })
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "default, %q", html.EscapeString(r.URL.Path))
    })

    log.Fatal(http.ListenAndServe(":6001", nil))

}
