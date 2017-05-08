package main

import (
	"fmt"
	"github.com/google/go-querystring/query"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	serverUri := "https://your.owncloud.install.com/ocs/v1.php/apps/files_sharing/api/v1/sharees?format=json"
	username := "your.username"
	passwd := "your.password"

	client := &http.Client{}

	// Simplify building an encoded query string
	type QueryOptions struct {
		ItemType  string `url:"itemType"`
		ShareType int    `url:"shareType"`
		PerPage   int    `url:"perPage"`
	}
	opt := QueryOptions{"file", 0, 1}
	v, _ := query.Values(opt)

	req, err := http.NewRequest("GET", fmt.Sprintf("%s&%s", serverUri, v.Encode()), nil)
	if err != nil {
		log.Print(err)
		os.Exit(1)
	}

	req.SetBasicAuth(username, passwd)

	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	bodyText, err := ioutil.ReadAll(resp.Body)
	fmt.Println(string(bodyText))
}
