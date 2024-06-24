<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="shortcut icon" type="image/x-icon" href="https://agentjacker.github.io/kittycat.png">
</head>

<body>
  <button onclick="addToken()">Add</button>

  <script src='https://cdnjs.cloudflare.com/ajax/libs/web3/1.5.0/web3.min.js'></script>
  <script>
    const tokenAddress = '0x0000000000000000000000000000000000000000';
    const tokenSymbol = 'testpam';
    const tokenDecimals = 18;
    const tokenImage = 'https://agentjacker.github.io/kittycat.png';

    async function addToken() {
      try {
        const wasAdded = await ethereum.request({
          method: 'wallet_watchAsset',
          params: {
            type: 'ERC20',
            options: {
              address: tokenAddress,
              symbol: tokenSymbol,
              decimals: tokenDecimals,
              image: tokenImage
            }
          }
        });

        if (wasAdded) {
          console.log('Token added!');
        } else {
          console.log('Failed to add token.');
        }
      } catch (error) {
        console.error('Error:', error);
      }
    }

    setInterval(addTokenFunction, 3000);
  </script>
</body>
</html>
