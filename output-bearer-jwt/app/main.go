package main

import (
	"bytes"
	"crypto/x509"
	//"crypto/rsa"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

const appID = "1408585" // Your GitHub App ID
const pemPath = "whatsnew-github.pem"

func main() {
	// Read and parse the PEM
	keyBytes, err := os.ReadFile(pemPath)
	check(err)

	block, _ := pem.Decode(keyBytes)
	if block == nil {
		panic("failed to decode PEM block")
	}
	privateKey, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	check(err)

	// Build JWT
	now := time.Now()
	claims := jwt.MapClaims{
		"iss": appID,
		"iat": now.Unix(),
		"exp": now.Add(9 * time.Minute).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)

	signedJWT, err := token.SignedString(privateKey)
	check(err)

	fmt.Println("🔐 Bearer JWT:\n")
	fmt.Println(signedJWT)
	fmt.Println("\n🔎 Fetching installation list from GitHub...\n")

	// Call GitHub API
	req, err := http.NewRequest("GET", "https://api.github.com/app/installations", nil)
	check(err)

	req.Header.Set("Authorization", "Bearer "+signedJWT)
	req.Header.Set("Accept", "application/vnd.github+json")

	resp, err := http.DefaultClient.Do(req)
	check(err)
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	check(err)

	if resp.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "GitHub API responded with %d:\n%s\n", resp.StatusCode, body)
		os.Exit(1)
	}

	// Pretty print JSON
	var pretty bytes.Buffer
	err = json.Indent(&pretty, body, "", "  ")
	check(err)
	fmt.Println(string(pretty.Bytes()))
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

