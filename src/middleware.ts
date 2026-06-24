export async function onRequest(
  context: { request: Request; locals: Record<string, unknown> },
  next: () => Promise<Response>,
): Promise<Response> {
  const cookies = context.request.headers.get('cookie') || ''
  for (const c of cookies.split(';')) {
    const [name, ...rest] = c.trim().split('=')
    if (name.trim() === 'sb-access-token') {
      context.locals.token = decodeURIComponent(rest.join('=').trim())
      break
    }
  }
  return next()
}
