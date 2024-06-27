try {
  const bannedReferrers = [/news\.ycombinator\.com/i, /reddit\.com/i]
  if (document.referrer) {
    const ref = new URL(document.referrer)
    if (
      !/bad-networks/i.test(window.location.href) &&
      bannedReferrers.some((r) => r.test(ref.host))
    ) {
      window.location.href = "https://www.pcloadletter.dev/blog/bad-networks"
    }
  }
} catch (e) {}
