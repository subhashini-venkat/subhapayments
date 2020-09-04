
const paymentMethodsResponse = JSON.parse(
  document.getElementById("paymentMethodsResponse").innerHTML
);

console.log(paymentMethodsResponse)

const configuration = {
  paymentMethodsResponse, // The `/paymentMethods` response from the server.
  clientKey: "test_GWXWP766DVDVHP3NUESVCEBV5AKZCOGJ",
  locale: "en_US",
  environment: "test",
  onSubmit: (state, dropin) => {
   // Function calling the server to make the `/payments` request
  return makePayment(state.data).then (response => {
        console.log('back to js')
        if (response.action) {
          // Drop-in handles the action object from the /payments response
          dropin.handleAction(response.action);
        } else {
          // Function to show the final result to the shopper
          showFinalResult(response.resultCode);
        }
      }).catch(error => {
        throw Error(error);
      });
  }, 

paymentMethodsConfiguration: {
  card: { 
    hasHolderName: true,
    holderNameRequired: true,
    enableStoreDetails: true,
    hideCVC: false, 
    name: 'Credit or debit card'
  }
}
};

function makePayment(data){
  var promise = fetch ("/api/initiatePayment", {
    method: "POST",
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json",
    },
  })
  return promise.then((res) => res.json());
}

function showFinalResult(resultCode){
  switch (resultCode) {
    case "Authorised":
      window.location.href = "/success";
      break;
    case "Pending":
      window.location.href = "/pending";
      break;
    case "Refused":
      window.location.href = "/failed";
      break;
    default:
      window.location.href = "/error";
      break;
  }
}

// Mounting Drop-in instance
const checkout = new AdyenCheckout(configuration);
const dropin = checkout.create('dropin').mount('#dropin-container');