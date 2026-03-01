import React from 'react';
import { formatDate } from '../utils/formatDate';
import { validateEmail } from '../utils/validate';

interface UserCardProps {
  name: string;
  email: string;
  createdAt: Date;
}

// TODO: fix this later
export const UserCard: React.FC<UserCardProps> = ({ name, email, createdAt }) => {
  const isValid = validateEmail(email);
  return (
    <div className="user-card">
      <h2>{name}</h2>
      <p>{isValid ? email : 'Invalid email'}</p>
      <p>Joined: {formatDate(createdAt)}</p>
    </div>
  );
};
