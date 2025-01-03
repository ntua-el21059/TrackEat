import React from 'react';
import firebase from './firebase';

function ProfileScreen() {
    const currentUser = firebase.auth().currentUser;
    
    // Initialize with actual values, never use "Loading..."
    const [profile, setProfile] = React.useState(() => ({
        name: currentUser?.displayName || localStorage.getItem('profileName') || 'Profile',  // Default to 'Profile' instead of Loading
        username: currentUser?.email?.split('@')[0] || localStorage.getItem('profileUsername') || 'user',  // Use email username as fallback
        image: currentUser?.photoURL || localStorage.getItem('profileImage') || '/default-avatar.png'
    }));

    React.useEffect(() => {
        // Immediately get stored data
        const storedProfile = {
            name: localStorage.getItem('profileName'),
            username: localStorage.getItem('profileUsername'),
            image: localStorage.getItem('profileImage')
        };

        if (storedProfile.name && storedProfile.username) {
            setProfile(current => ({
                ...current,
                ...storedProfile
            }));
        }

        // Then listen for updates
        const unsubscribe = firebase.firestore()
            .collection('profiles')
            .doc(currentUser?.uid || 'userId')
            .onSnapshot((doc) => {
                if (doc.exists) {
                    const data = doc.data();
                    setProfile(current => ({
                        ...current,
                        name: data.name || current.name,
                        username: data.username || current.username,
                        image: data.image || current.image
                    }));

                    // Store for next time
                    if (data.name) localStorage.setItem('profileName', data.name);
                    if (data.username) localStorage.setItem('profileUsername', data.username);
                    if (data.image) localStorage.setItem('profileImage', data.image);
                }
            });

        return () => unsubscribe();
    }, [currentUser]);

    // Always show actual content, never loading
    return (
        <div>
            <div className="profile-header">
                <img 
                    src={profile.image} 
                    alt="" 
                    onError={(e) => {
                        e.target.src = '/default-avatar.png';
                    }}
                />
                <h2>{profile.name}</h2>
                <p>@{profile.username}</p>
            </div>
            {/* Rest of your profile content */}
        </div>
    );
}

export default ProfileScreen; 