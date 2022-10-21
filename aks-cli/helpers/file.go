package helpers

import (
	"io/ioutil"
	"os"
)

func SaveTempFile(arguments any) string {
	filepath := GuidFormat("~/%s.json")
	json := Serialize(arguments)
	WriteVerbose(json)
	SaveFile(json, filepath)
	return filepath
}

func DeleteTempFile(filepath string) {
	os.Remove(filepath)
}

func SaveFile(content string, filePath string) {
	WriteVerbose(Format("Writing file '%s'", filePath))
	err := os.WriteFile(filePath, []byte(content), 0644)
	WriteErrorIf(err)
}

func LoadFileRelative(filepath string) string {
	path := ExeLocation()
	return LoadFile(path + filepath)
}

func LoadFile(filepath string) string {
	return string(HandleError(os.ReadFile(filepath)))
}

func DirExists(path string) bool {
	return FileExists(path)
}

func FileExists(path string) bool {
	_, err := os.Stat(path)
	if err == nil {
		return true
	}
	if os.IsNotExist(err) {
		return false
	}
	WriteErrorIf(err)
	return false
}

func MakeDir(name string) {
	os.Mkdir(name, os.ModePerm)
}

func ExeLocation() string {
	return HandleError(os.Getwd())
	// return HandleError(os.Executable())
}

func ReadDir(path string) []string {
	files := HandleError(ioutil.ReadDir(path))

	fileNames := make([]string, 0)
	for _, file := range files {
		fileNames = append(fileNames, file.Name())
	}
	return fileNames
}
