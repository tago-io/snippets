import type { APIRoute } from "astro";
// @ts-ignore
import snippetsData from "../../../data/snippets.json";

export const prerender = true;

export async function getStaticPaths() {
  const paths: { params: { runtime: string; filename: string } }[] = [];
  for (const runtime of Object.keys(snippetsData.tagosql)) {
    const runtimeData = snippetsData.tagosql[runtime];
    for (const snippet of runtimeData.snippets) {
      paths.push({ params: { runtime, filename: snippet.filename } });
    }
  }
  return paths;
}

export const GET: APIRoute = async ({ params }) => {
  const runtime = params.runtime!;
  const filename = params.filename!;

  const runtimeData = snippetsData.tagosql[runtime as keyof typeof snippetsData.tagosql];
  if (!runtimeData) return new Response("Runtime not found", { status: 404 });

  const snippet = runtimeData.snippets.find((s: any) => s.filename === filename);
  if (!snippet) return new Response("File not found", { status: 404 });

  return new Response(snippet.code, {
    headers: { "Content-Type": "text/plain; charset=utf-8" },
  });
};
