import axios from 'axios';

const client = axios.create({ baseURL: '/api' });

export async function fetchUsers() {
  const { data } = await client.get('/users');
  return data;
}

export async function fetchUser(id: string) {
  const { data } = await client.get(`/users/${id}`);
  return data;
}
