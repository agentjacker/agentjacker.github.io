console.log("JS running: "+document.location.origin);

window.addEventListener('load', async () => {
  if (window.ethereum) {

    console.log("Ethereum object available.");
    console.log(window.ethereum);

    try {
      let accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      console.log(accounts);
    } catch (err) {a
      console.log("Error executing eth_requestAccounts: " + err);
    }
  }

});
