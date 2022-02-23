package main

import (
	"github.com/mymhimself/core-api/app"
)

func main(){
	if err := app.Run(); err != nil {
		panic(err)
	}

}
