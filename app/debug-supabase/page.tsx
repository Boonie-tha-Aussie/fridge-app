// app/debug-supabase/page.tsx
import supabase from "../../lib/supabaseClient";

export default async function DebugSupabasePage() {
  const { data: recipes, error } = await supabase
    .from("recipes")
    .select("*")
    .limit(5);

  if (error) {
    return (
      <main className="p-8">
        <h1 className="text-2xl font-bold mb-4">Supabase Debug</h1>
        <p className="text-red-600">Error: {error.message}</p>
      </main>
    );
  }

  return (
    <main className="p-8">
      <h1 className="text-2xl font-bold mb-4">Supabase Debug</h1>
      <p className="mb-4">First 5 recipes from the database:</p>

      <pre className="bg-gray-900 text-green-100 p-4 rounded text-sm overflow-x-auto">
        {JSON.stringify(recipes, null, 2)}
      </pre>
    </main>
  );
}
