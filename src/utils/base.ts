/** Resolve a site path against the configured Astro base URL. */
export function withBase(path: string = ''): string {
  const base = import.meta.env.BASE_URL;
  if (!path) return base;
  const normalizedPath = path.startsWith('/') ? path.slice(1) : path;
  return `${base}${normalizedPath}`;
}
