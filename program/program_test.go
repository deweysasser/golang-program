package program

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/zenizh/go-capturer"
)

func TestOptions_Run(t *testing.T) {
	var program Options

	exitValue := -1
	exitFunc = func(x int) {
		exitValue = x
	}
	defer func() { exitFunc = os.Exit }()

	out := capturer.CaptureStdout(func() {

		_, err := program.Parse([]string{"--version"})

		assert.NoError(t, err)

		// version output is done as part of parsing, so we don't need to run the program
	})

	assert.Equal(t, exitValue, 0)
	assert.Equal(t, "unknown\n", out)
}
