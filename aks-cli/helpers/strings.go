package helpers

import (
	"strings"
	s "strings"
)

func StringMiddle(str string) string {
	return s.Split(str, "-")[1]
}

func StringUnixName(name string) string {
	return s.Replace(s.Replace(s.ToLower(name), " - ", " ", -1), "\\W", "-", -1)
}

func Trim(s string, cutset string) string {
	return strings.Trim(s, cutset)
}