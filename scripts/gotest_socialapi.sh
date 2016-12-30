#!/bin/bash

#  make relative paths work.
cd $(dirname $0)/..

CONFIG=${2:-'-c=./go/src/socialapi/config/dev.toml'}
action="sh -c"

go list -f '{{if len .TestGoFiles}}"go test -v -cover -o={{.Dir}}/{{.Name}}.test -c {{.ImportPath}}"{{end}}' $1 | grep -v vendor | xargs -L 1 $action
go list -f '{{if len .TestGoFiles}}"{{.Dir}}/{{.Name}}.test -test.coverprofile={{.Dir}}/coverage.txt "{{end}}' $1 | xargs -L 1 -I{} $action {}$CONFIG
go list -f '{{if len .TestGoFiles}}"rm {{.Dir}}/{{.Name}}.test "{{end}}' $1 | xargs -L 1 $action

bash <(curl -s https://codecov.io/bash) -t $CODECOV_TOKEN -X gcov -X fix
