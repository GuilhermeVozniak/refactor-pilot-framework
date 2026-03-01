import React from 'react';
import { UserCard } from './UserCard';
import { useUsers } from '../hooks/useUsers';

export const Dashboard: React.FC = () => {
  const { users, loading } = useUsers();
  if (loading) return <div>Loading...</div>;
  return (
    <div>
      {users.map(u => <UserCard key={u.id} {...u} />)}
    </div>
  );
};
