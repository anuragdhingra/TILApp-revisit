import 'whatwg-fetch'
class ApiHelper {
    static getAllAcronyms() {
        const url = 'http://localhost:8080/api/acronyms';
        return fetch(url, { method: 'GET' })
            .then(function(response) {
                return response.json();
            })
    }
}

export default ApiHelper