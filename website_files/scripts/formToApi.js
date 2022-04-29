function formToApi(event) {
    event.preventDefault()
    
    var data = {
        destinationEmail: document.getElementsByName('email')[0].value,
        message: document.getElementsByName('message')[0].value
    }

    fetch( "https://pldjrzsr1g.execute-api.us-east-1.amazonaws.com/sendingStage/sending", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data),
        mode: "no-cors"
    })


}