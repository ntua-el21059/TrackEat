// Import the Firebase configuration to establish the connection immediately
import './firebase';

// ...other imports
import React from 'react';
import SocialProfileMyself from './social_profile_myself.jsx';

function App() {
    return (
        <div>
            <SocialProfileMyself />
            {/* ...other components */}
        </div>
    );
}

export default App; 