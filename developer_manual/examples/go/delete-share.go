package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	serverUri := "https://your.owncloud.install.com/owncloud/ocs/v1.php/apps/files_sharing/api/v1"
	username := "your.username"
	passwd := "your.password"

	client := &http.Client{}

	// Build the core request object
	req, _ := http.NewRequest(
		"DELETE",
		fmt.Sprintf("%s/%s", serverUri, "shares/115470"),
		nil,
	)
	req.SetBasicAuth(username, passwd)

	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	bodyText, err := ioutil.ReadAll(resp.Body)
	fmt.Println(string(bodyText))
}
