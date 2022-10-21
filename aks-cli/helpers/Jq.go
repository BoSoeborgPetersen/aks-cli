package helpers

import "github.com/itchyny/gojq"

func JqQuery(json string, query string) []string {
	WriteVerbose(Format("QUERY: %s", query))

	q, err := gojq.Parse(query)
	WriteErrorIf(err)
	jsonObj := DeserializeL(json)
	iter := q.Run(jsonObj)
	results := []string{}
	for {
		v, ok := iter.Next()
		if !ok {
			break
		}
		if err, ok := v.(error); ok {
			WriteErrorIf(err)
		}
		results = append(results, v.(string))
	}

	WriteVerbose(Format("QUERY - RESULT: \n%s", TakeS(Join(results), 1000)))

	return results
}
