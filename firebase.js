// Import Firebase modules
import firebase from 'firebase/app';
import 'firebase/auth'; // Add other services as needed

// Your Firebase configuration object
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    // ...other configuration properties
};

// Initialize Firebase only if it hasn't been initialized yet
if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
}

// Export the Firebase instance for use in other parts of your app
export default firebase; 