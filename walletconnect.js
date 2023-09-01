const WalletConnect = require('walletconnect');

const connectWalletButton = document.getElementById('connectWalletButton');
const walletConnectModal = document.getElementById('walletConnectModal');

const connector = new WalletConnect({ bridge: 'https://bridge.walletconnect.org' });

// Handle the button click to open the modal
connectWalletButton.addEventListener('click', () => {
    // Generate and display the QR code for WalletConnect
    connector.createSession().then(() => {
        const uri = connector.uri;
        // Display the URI as a QR code or in any way you prefer
        // For displaying QR codes, you can use libraries like "qrcode"
        // Set walletConnectModal.style.display to "block" to show the modal
    });
});

// Handle closing the modal
// For example, by adding a close button in the modal
const closeButton = document.getElementById('closeButton');
closeButton.addEventListener('click', () => {
    walletConnectModal.style.display = 'none';
});

// Listen for connection events
connector.on('session_request', (error, payload) => {
    if (error) {
        throw error;
    }
    // Approve or reject the connection request based on user interaction
    // Typically, you'll display the request to the user and wait for their input
    const approved = confirm('Do you want to connect your wallet to this website?');
    if (approved) {
        connector.approveSession({ accounts: [] });
    } else {
        connector.rejectSession();
    }
});

// Listen for other WalletConnect events and handle them accordingly
connector.on('connect', (error, payload) => {
    if (error) {
        throw error;
    }
    // Handle the connection event, e.g., update UI to show the connected wallet
});

// Handle disconnect events if needed
connector.on('disconnect', (error, payload) => {
    if (error) {
        throw error;
    }
    // Handle the disconnect event, e.g., update UI to show wallet disconnected
});
