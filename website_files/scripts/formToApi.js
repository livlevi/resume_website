function formToApi(event, typeOfSending) {

    event.preventDefault()

    var data = {
        typeOfSending: typeOfSending,
        destinationEmail: document.getElementsByName('email')[0].value,
        message: document.getElementsByName('message')[0].value
    }

    fetch( "https://xjn7t5jrnf.execute-api.us-east-1.amazonaws.com/prod/sending" , {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data),
        mode: "no-cors"
    })
}