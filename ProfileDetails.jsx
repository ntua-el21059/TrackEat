import React from 'react';

function ProfileDetails({ name, username }) {
    return (
        <div>
            <div className="profile-info">
                <h2>{name}</h2>
                <p>@{username}</p>
            </div>
            <div className="profile-stats">
                {/* Other profile details */}
            </div>
        </div>
    );
}

export default ProfileDetails; 