// @title: TagoSQL - Execute a Stored Query
// @description: Execute a stored TagoSQL query from an analysis using an Access Management grant
// @tags: tagosql, sql, stored query, access management, query

/*
 ** Analysis Example
 ** TagoSQL - Execute a Stored Query
 **
 ** Executes a stored TagoSQL query (POST /sql/{id}/execute) with the analysis' own token,
 ** overriding one of the query's saved parameter defaults. Stored queries are the recommended
 ** way to reuse SQL: they are versioned, can be cached, and can be granted to analyses and
 ** Run users through Access Management.
 **
 ** How to use:
 ** 1 - Create a stored query with POST /sql (or from the admin) that uses a $1 parameter,
 **     for example: SELECT variable, value, time FROM device_tag('type', 'sensor') AS d
 **     WHERE variable = $1 ORDER BY time DESC LIMIT 10
 ** 2 - Grant this analysis access to it at https://admin.tago.io/am:
 **     - Click "Add Policy";
 **     - In the Target selector, select Analysis with the field set as "ID" and choose this analysis;
 **     - Click "Click to add a new permission", select "SQL Query" with the rule "Execute",
 **       matching the query by ID (or by tag to grant a group of queries);
 **     - Save the policy.
 ** 3 - Add the stored query id to the analysis environment variables:
 **     sql_id = your stored query id
 **
 ** Granting execution of a query grants its full result set: the query runs with the
 ** profile's data access, so only grant queries whose results the target may see.
 */

import type { TagoContext } from "npm:@tago-io/sdk";
import { Analysis, Utils } from "npm:@tago-io/sdk";

const TAGOIO_API = "https://api.tago.io";

async function startAnalysis(context: TagoContext): Promise<void> {
  const envVars = Utils.envToJson(context.environment);
  if (!envVars.sql_id) {
    return context.log("Add a sql_id to the analysis environment variables");
  }

  const response = await fetch(`${TAGOIO_API}/sql/${envVars.sql_id}/execute`, {
    method: "POST",
    headers: { token: context.token, "Content-Type": "application/json" },
    // The body is optional: a bare POST runs the query with its saved parameter defaults.
    // Values sent here override the saved defaults per key.
    body: JSON.stringify({
      params: [{ key: "$1", value: "temperature" }],
    }),
  });

  const body = await response.json();
  if (!response.ok || !body.status) {
    // A 403 here means this analysis has no Access Management policy granting
    // the Execute action on this query. See the instructions above.
    return context.log(`Query failed (${response.status}): ${body.message}`);
  }

  const { rows, row_count, served_from_cache } = body.result;
  context.log(`Got ${row_count} rows (served_from_cache: ${served_from_cache})`);
  for (const row of rows) {
    context.log(JSON.stringify(row));
  }
}

Analysis.use(startAnalysis);
