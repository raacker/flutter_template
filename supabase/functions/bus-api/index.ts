import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (request) => {
  const apiKey = Deno.env.get("BUS_API_KEY");

  if (!apiKey) {
    return new Response("BUS_API_KEY is not configured.", { status: 500 });
  }

  const upstreamUrl = new URL("https://example.com/bus-api");
  upstreamUrl.search = new URL(request.url).search;
  upstreamUrl.searchParams.set("serviceKey", apiKey);

  const response = await fetch(upstreamUrl);

  return new Response(response.body, {
    status: response.status,
    headers: {
      "content-type": response.headers.get("content-type") ?? "application/json",
    },
  });
});
