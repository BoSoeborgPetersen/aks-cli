package helpers

import (
	"github.com/itchyny/gojq"
)

func JqList(json string, query string) []string {
	return Select(jqQuery(DeserializeL(json), query), func(i interface{}) string { return i.(string) })
}

func JqObject(json string, query string) []string {
	return Select(jqQuery(DeserializeG(json), query), func(i interface{}) string { return i.(string) })
}

func JqObjectToInt(json string, query string) int {
	return Select(jqQuery(DeserializeG(json), query), func(i interface{}) int { return i.(int) })[0]
}

func JqObjectToFloat(json string, query string) float64 {
	return Select(jqQuery(DeserializeG(json), query), func(i interface{}) float64 { return i.(float64) })[0]
}

func jqQuery(jsonObj interface{}, query string) []interface{} {
	WriteVerbose(Format("QUERY: %s", query))

	q, err := gojq.Parse(query)
	WriteErrorIf(err)
	iter := q.Run(jsonObj)
	results := make([]interface{}, 0)
	for {
		v, ok := iter.Next()
		if !ok {
			break
		}
		if err, ok := v.(error); ok {
			WriteErrorIf(err)
		}
		WriteVerbose(Format("QUERY - RESULT: \n%s", v))
		results = append(results, v)
	}

	return results
}
