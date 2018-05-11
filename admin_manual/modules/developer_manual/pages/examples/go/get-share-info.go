package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	serverUri := "https://your.owncloud.install.com/owncloud/ocs/v1.php/apps/files_sharing/api/v1"
	username := "your.username"
	passwd := "your.password"

	client := &http.Client{}

	req, err := http.NewRequest("GET", fmt.Sprintf("%s/%s", serverUri, "shares/115464"), nil)
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
