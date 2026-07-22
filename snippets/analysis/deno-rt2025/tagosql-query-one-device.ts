// @title: TagoSQL - Query One Device
// @description: Run a one-off TagoSQL query to read the latest values of a variable from a single device
// @tags: tagosql, sql, data, query, device

/*
 ** Analysis Example
 ** TagoSQL - Query One Device
 **
 ** Runs a one-off TagoSQL query (POST /sql/execute) that reads the latest readings of one
 ** variable from a single device, using positional parameters ($1, $2) instead of string
 ** concatenation.
 **
 ** How to use:
 ** One-off queries require a profile token. Go to your profile settings, create a token,
 ** and add it to the analysis environment variables:
 **   profile_token = your profile token
 **   device_id     = the id of the device to query
 ** Queries you run regularly should be stored with POST /sql instead; see the
 ** "TagoSQL - Execute a Stored Query" snippet.
 */

import type { TagoContext } from "npm:@tago-io/sdk";
import { Analysis, Utils } from "npm:@tago-io/sdk";

const TAGOIO_API = "https://api.tago.io";

interface SqlResult {
  columns: { name: string; type: string }[];
  rows: Record<string, unknown>[];
  row_count: number;
  execution_ms: number;
  served_from_cache: boolean;
}

async function startAnalysis(context: TagoContext): Promise<void> {
  const envVars = Utils.envToJson(context.environment);
  if (!envVars.profile_token) {
    return context.log("Add a profile_token to the analysis environment variables");
  }
  if (!envVars.device_id) {
    return context.log("Add a device_id to the analysis environment variables");
  }

  // $1 binds the device id and $2 the variable name. Parameters are typed and validated
  // by the API, so values never need to be escaped into the query string.
  const query = `
    SELECT variable, value, time
    FROM device($1) AS d
    WHERE variable = $2
    ORDER BY time DESC
    LIMIT 10
  `;

  const response = await fetch(`${TAGOIO_API}/sql/execute`, {
    method: "POST",
    headers: { token: envVars.profile_token, "Content-Type": "application/json" },
    body: JSON.stringify({
      query,
      params: [
        { key: "$1", value: envVars.device_id },
        { key: "$2", value: "temperature" },
      ],
    }),
  });

  const body = await response.json();
  if (!response.ok || !body.status) {
    return context.log(`Query failed (${response.status}): ${body.message}`);
  }

  const result: SqlResult = body.result;
  context.log(`Got ${result.row_count} rows in ${result.execution_ms}ms`);
  for (const row of result.rows) {
    context.log(`${row.time} | ${row.variable} = ${row.value}`);
  }
}

Analysis.use(startAnalysis);
