package main

import (
	"context"
	"fmt"
	"os"

	"github.com/deweysasser/golang-program/program"
	"github.com/rs/zerolog/log"
)

func main() {

	var options program.Options

	kongContext, err := options.Parse(os.Args[1:])

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Put the default logger in the background context so that it's available everywhere
	ctx := log.Logger.WithContext(context.Background())

	// Make sure the background context is accessible everywhere
	kongContext.BindTo(ctx, (*context.Context)(nil))

	// And make sure it's a binding as well
	kongContext.Bind(log.Logger)

	// And just in case anyone needs access to the full program options, bind those too
	kongContext.Bind(options)

	// This ends up calling options.Run()
	if err := kongContext.Run(&options); err != nil {
		log.Err(err).Msg("Program failed")
		os.Exit(1)
	}
}
