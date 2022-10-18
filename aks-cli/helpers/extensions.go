package helpers

import (
	"bytes"
	"encoding/json"
	"errors"
	"regexp"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/google/uuid"
)

func SetDefaultIfEmpty(variable string, defaulttt string) string {
	if variable != "" {
		return variable
	}

	return defaulttt
}

func PrependWithDash(prefix string, str string) string {
	return IfElse(prefix, Format("%s-%s", prefix, str), str)
}

func IfF(test string, formatString string) string {
	return If(test, Format(formatString, test))
}

func If[T string | int | bool, K any](test T, value1 K) K {
	var value2 K
	return IfElse(test, value1, value2)
}

func IfElseF(test string, formatString string, value2 string) string {
	return IfElse(test, Format(formatString, test), value2)
}

func IfElse[T string | int | bool, K any](test T, value1 K, value2 K) K {
	if IsSet(test) {
		return value1
	}
	return value2
}

func IsSet[T string | int | bool](test T) bool {
	switch p := any(test).(type) {
	case string:
		return p != ""
	case int:
		return p != 0
	case bool:
		return p
	}
	return false
}

func prependString(y string, x []string) []string {
	x = append(x, "")
	copy(x[1:], x)
	x[0] = y
	return x
}

func prependInt(y int, x []int) []int {
	x = append(x, 0)
	copy(x[1:], x)
	x[0] = y
	return x
}

func Fields(input string) []string {
	return strings.Fields(input)
}

func JoinF(input []string, sep string) string {
	return strings.Join(input, sep)
}

func Join(input []string) string {
	return strings.Join(input, " ")
}

func ReplaceAllString(input string, pattern string, replace string) string {
	regexString, _ := regexp.Compile(pattern)
	return regexString.ReplaceAllString(input, replace)
}

func MatchString(pattern string, s string) bool {
	return HandleError(regexp.MatchString(pattern, s))
}

func ReplaceAll(s string, old string, new string) string {
	return strings.Replace(s, old, new, -1)
}

func Contains(s string, substr string) bool {
	return strings.Contains(s, substr)
}

func Atoi(s string) int {
	return HandleError(strconv.Atoi(s))
}

//	func splitString(s string) []string {
//		r := regexp.MustCompile(`[^\s]+|"([^"]*)"|'([^']*)'`)
//		// r := regexp.MustCompile(`[^\s"']+|"([^"]*)"|'([^']*)'`)
//		m := regexp.MustCompile(`^("([^"]*)"|'([^']*)')$`)
//		strings := make([]string, 0)
//		for _, e := range r.FindAllString(s, -1) {
//			strings = append(strings, m.ReplaceAllString(e, "$2"))
//		}
//		for i, e := range strings {
//			fmt.Printf("arg%d: %s\n", i, e)
//		}
//		return strings
//	}

var (
	UnterminatedSingleQuoteError = errors.New("Unterminated single-quoted string")
	UnterminatedDoubleQuoteError = errors.New("Unterminated double-quoted string")
	UnterminatedEscapeError      = errors.New("Unterminated backslash-escape")
)

var (
	splitChars        = " \n\t"
	singleChar        = '\''
	doubleChar        = '"'
	escapeChar        = '\\'
	doubleEscapeChars = "$`\"\n\\"
)

func splitString(input string) (words []string, err error) {
	var buf bytes.Buffer
	words = make([]string, 0)

	for len(input) > 0 {
		// skip any splitChars at the start
		c, l := utf8.DecodeRuneInString(input)
		if strings.ContainsRune(splitChars, c) {
			input = input[l:]
			continue
		} else if c == escapeChar {
			// Look ahead for escaped newline so we can skip over it
			next := input[l:]
			if len(next) == 0 {
				err = UnterminatedEscapeError
				return
			}
			c2, l2 := utf8.DecodeRuneInString(next)
			if c2 == '\n' {
				input = next[l2:]
				continue
			}
		}

		var word string
		word, input, err = splitWord(input, &buf)
		if err != nil {
			return
		}
		words = append(words, word)
	}
	// for i, e := range words {
	// 	fmt.Printf("arg%d: %s\n", i, e)
	// }
	return
}

func splitWord(input string, buf *bytes.Buffer) (word string, remainder string, err error) {
	buf.Reset()

raw:
	{
		cur := input
		for len(cur) > 0 {
			c, l := utf8.DecodeRuneInString(cur)
			cur = cur[l:]
			if c == singleChar {
				buf.WriteString(input[0 : len(input)-len(cur)-l])
				input = cur
				goto single
			} else if c == doubleChar {
				buf.WriteString(input[0 : len(input)-len(cur)-l])
				input = cur
				goto double
			} else if c == escapeChar {
				buf.WriteString(input[0 : len(input)-len(cur)-l])
				input = cur
				goto escape
			} else if strings.ContainsRune(splitChars, c) {
				buf.WriteString(input[0 : len(input)-len(cur)-l])
				return buf.String(), cur, nil
			}
		}
		if len(input) > 0 {
			buf.WriteString(input)
			input = ""
		}
		goto done
	}

escape:
	{
		if len(input) == 0 {
			return "", "", UnterminatedEscapeError
		}
		c, l := utf8.DecodeRuneInString(input)
		if c == '\n' {
			// a backslash-escaped newline is elided from the output entirely
		} else {
			buf.WriteString(input[:l])
		}
		input = input[l:]
	}
	goto raw

single:
	{
		i := strings.IndexRune(input, singleChar)
		if i == -1 {
			return "", "", UnterminatedSingleQuoteError
		}
		buf.WriteString(input[0:i])
		input = input[i+1:]
		goto raw
	}

double:
	{
		cur := input
		for len(cur) > 0 {
			c, l := utf8.DecodeRuneInString(cur)
			cur = cur[l:]
			if c == doubleChar {
				buf.WriteString(input[0 : len(input)-len(cur)-l])
				input = cur
				goto raw
			} else if c == escapeChar {
				// bash only supports certain escapes in double-quoted strings
				c2, l2 := utf8.DecodeRuneInString(cur)
				cur = cur[l2:]
				if strings.ContainsRune(doubleEscapeChars, c2) {
					buf.WriteString(input[0 : len(input)-len(cur)-l-l2])
					if c2 == '\n' {
						// newline is special, skip the backslash entirely
					} else {
						buf.WriteRune(c2)
					}
					input = cur
				}
			}
		}
		return "", "", UnterminatedDoubleQuoteError
	}

done:
	return buf.String(), input, nil
}

func JqCommand(json string, command string) string {
	// q,err := gojq.Parse(json)
	// if err != nil {
	// 	fmt.Println("Error: " + err.Error())<
	// }
	// return q.Run(command)
	return ""
}

func DeserializeB[T any](jsonBytes []byte, t T) T {
	WriteErrorIf(json.Unmarshal(jsonBytes, &t))
	return t
}

func DeserializeT[T any](jsonString string) T {
	t := *new(T)
	WriteErrorIf(json.Unmarshal([]byte(jsonString), &t))
	return t
}

func Deserialize[T any](jsonString string, t T) T {
	WriteErrorIf(json.Unmarshal([]byte(jsonString), &t))
	return t
}

func Serialize[T any](t T) string {
	return string(HandleError(json.Marshal(t)))
}

func Guid() string {
	return uuid.New().String()
}

func GuidFormat(format string) string {
	return Format(format, Guid())
}

func TimeNow() time.Time {
	return time.Now()
}

func Where[T any](list []T, predicate func(T) bool) []T {
	newList := make([]T, 0)
	for _, e := range list {
		if predicate(e) {
			newList = append(newList, e)
		}
	}
	return newList
}

func First[T any](list []T, predicate func(T) bool) T {
	for _, e := range list {
		if predicate(e) {
			return e
		}
	}
	return *new(T)
}

func Any[T any](list []T, predicate func(T) bool) bool {
	var result bool
	for _, e := range list {
		if predicate(e) {
			result = true
		}
	}
	return result
}
