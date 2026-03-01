import { render } from '@testing-library/react';
import { UserCard } from '../components/UserCard';

test('renders user name', () => {
  const { getByText } = render(
    <UserCard name="Alice" email="alice@example.com" createdAt={new Date()} />
  );
  expect(getByText('Alice')).toBeTruthy();
});
