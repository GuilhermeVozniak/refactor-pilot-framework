export function validateEmail(email: string): boolean {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

export function validateName(name: string): boolean {
  return name.length > 0 && name.length <= 100;
}
