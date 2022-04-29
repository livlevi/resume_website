const GET_url = 'https://h8uzwyjlp6.execute-api.us-east-1.amazonaws.com/prod/get-count';
const POST_url = 'https://h8uzwyjlp6.execute-api.us-east-1.amazonaws.com/prod/post-count';

async function getFromAPI() {
    const response = await fetch(GET_url, {
        method: 'GET',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json',
            'Origin': 'livlevi2.com'                    
            }
        });  // headers required by fetch() and API gateway

    const data = await response.json();

    document.getElementById("countget").innerHTML = "This site has been visited " + data.lastVisit + " times.";

} // ******* End of getToAPI function ***

async function postToAPI () {
    const response = await fetch(POST_url, { 
    method: 'POST',
    mode: 'cors',
    headers:{
        'Content-Type': 'application/json',
        'Origin': 'livlevi2.com',         
        }
    });  // headers required by fetch() and API gateway

    const data = await response.json();

} // **** End of postToAPI function ****


