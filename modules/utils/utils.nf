import groovy.json.JsonSlurper

def read_json(json_path) {
    def jsonSlurper = new JsonSlurper()
    def json = jsonSlurper.parseText(file(json_path).text)

    return json
}